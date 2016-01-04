//
//  HKDownloadCenter.m
//  Hankai
//
//  Created by 韩凯 on 3/24/14.
//  Copyright (c) 2014 Hankai. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "HKDownloadCenter.h"
#import "NSDate+LangExt.h"
#import "NSString+LangExt.h"
#import "HKVars.h"
#import "HKHttpRequest.h"

#define HKDownloaderCacheDir     ([AppCachesDirectory stringByAppendingPathComponent:@"Download"])

NSString * NDownloadFinished                           = @"NDDownloadFinished";
NSString * NHttpResourceIdentifierUserInfoKey          = @"NDHttpResourceIdentifierUserInfoKey";
NSString * NHttpResourceDataUserInfoKey                = @"NDHttpResourceDataUserInfoKey";
NSString * NHttpResourceUrlUserInfoKey                 = @"NDHttpResourceUrlUserInfoKey";
NSString * NHttpResourceContextUserInfoKey             = @"NDHttpResourceContextUserInfoKey";

NSString * NDHttpResourceReceiverUserInfoKey            = @"NDHttpResourceReceiverUserInfoKey";


@implementation HKDefaultDownloader

- (NSData *)downloadResourceAt:(NSURL *)url error:(NSError *__autoreleasing *)error {
    __block BOOL done = NO;
    __block NSData * data = nil;
    httpGet(url.absoluteString, nil, ^(NSError *error, HKHttpRequest * originalRequest) {
        if (error == nil) {
            data = originalRequest.responseData;
        }
        done = YES;
    });
    while (!done && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {}
    return data;
}

@end

@interface NDHttpResourceOperation : NSOperation

@property (nonatomic, strong) id                                groupId;

@property (nonatomic, strong) NSURL *                           url;

@property (nonatomic, assign) id<HKDownloader>                  downloader;

@property (nonatomic, strong) NSData *                          response;

@property (nonatomic, strong) NSError *                         error;

@property (nonatomic, assign) id                                delegate;

@property (nonatomic, assign) SEL                               didFinishSelector;

/*
 并非多余的，配合didFinishSelector，用于存储回调函数块。
 由于下载中心不允许重复下载同一个url资源，因此多处调用如果有重复url，将会将其回调块加入回调数组，以便收到回调
 */
@property (nonatomic, strong) NSMutableArray *                  callbacks;

@property (nonatomic, assign) BOOL                              cacheEnabled;//是否缓存到本地硬盘

- (id)initWithURL:(NSURL *)url;

@end

@implementation NDHttpResourceOperation

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    
    if (self != nil) {
        self.url = url;
        self.callbacks = [NSMutableArray array];
    }
    
    return self;
}

- (void)main {
    NSError * err = nil;
    self.response = [self.downloader downloadResourceAt:self.url error:&err];
    self.error = err;
    if ([self.delegate respondsToSelector:self.didFinishSelector]) {
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:self.didFinishSelector withObject:self];
    }
}

@end

@interface HKDownloadCenter () {
@private
    CFMutableDictionaryRef  _tasks;
    id<HKDownloader>        _downloader;
    NSOperationQueue *      _queue;
    NSTimer *               _logTimer;
}

- (void)httpDownloadFinished:(NDHttpResourceOperation *)operation;

@end

@implementation HKDownloadCenter

- (id)init {
    self = [super init];
    
    if (self != nil) {
        _tasks = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        _downloader = [HKDefaultDownloader new];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 4;
        _cacheExpiry = SecondsPerDay * 3;
    }
    
    return self;
}

- (NSString *)generateResourceCachePath:(NSString *)url {
    NSString * dir = HKDownloaderCacheDir;
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir] || !isDir) {
        NSError * error = nil;
        BOOL succeeded = [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                                   withIntermediateDirectories:YES
                                                                    attributes:nil
                                                                         error:&error];
        if (!succeeded && self.loggingEnabled) {
            NSLog(@"Failed to create cache directory, downloader cache feature not working.");
        }
    }
    
    NSString * fileName = [url md5EncryptedStringWithEncoding:NSUTF8StringEncoding];
    NSMutableString * path = [NSMutableString stringWithString:dir];
    if (isEmptyString(url.pathExtension)) {
        [path appendFormat:@"/%@", fileName];
    } else {
        [path appendFormat:@"/%@.%@", fileName, url.pathExtension];
    }
    return [NSString stringWithString:path];
}

- (void)httpDownloadFinished:(NDHttpResourceOperation *)operation {
    NSString * url = operation.url.absoluteString;
    
    if (operation.error == nil) {
        if (operation.cacheEnabled) {
            NSString * path = [self generateResourceCachePath:url];
            
            [operation.response writeToFile:path atomically:NO];
        }
    }
    
    __block NDHttpResourceOperation * op = operation;
    __block NSError * error = operation.error;
    __block NSData * data = op.response;
    
    if ([operation.callbacks count] > 0) {
        if (self.loggingEnabled) {
            if (error != nil) {
                NSLog(@"Failed to download http resource at: %@ due to: %@", op.url.absoluteString, error);
            } else if (data.length == 0) {
                NSLog(@"Http resource at %@ has empty data!", op.url.absoluteString);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            for (HttpResourceDownloadDidFinish callback in operation.callbacks) {
                callback(error, NO, data);
            }
        });
    }
    
    operation.response = nil;
    CFDictionaryRemoveValue(_tasks, (__bridge const void *)(url));
}

- (void)doLog {
    NSUInteger count = [_queue operationCount];

    if (count == 0) {
        [_logTimer invalidate];
        _logTimer = nil;
        NSLog(@"All download tasks completed!");
    } else {
        NSLog(@"Downloading %lu http resources.", (unsigned long)count);
    }
}

- (void)logDownloadingTasks {
    if (_logTimer == nil && self.loggingEnabled) {
        _logTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                     target:self
                                                   selector:@selector(doLog)
                                                   userInfo:nil
                                                    repeats:YES];
        [_logTimer fire];
    }
}

- (BOOL)isResourceExpired:(NSString *)localPath {
    NSURL * url = [NSURL fileURLWithPath:localPath];
    NSError * error = nil;
    NSDictionary * attributes = [url resourceValuesForKeys:@[NSURLCreationDateKey] error:&error];
    if (error == nil) {
        NSDate * creationDate = attributes[NSURLCreationDateKey];
        NSDate * expiry = [creationDate dateByAddingTimeInterval:self.cacheExpiry];
        NSDate * now = [NSDate date];
        BOOL expired = ([expiry earlierDate:now] == expiry);
        if (expired) {
            //remove cache
            [[NSFileManager defaultManager] removeItemAtPath:localPath error:nil];
        }
        return expired;
    }
    return NO;
}

#pragma mark - Public

+ (HKDownloadCenter *)defaultCenter {
    static HKDownloadCenter * center = nil;
    if (center == nil) {
        center = [[HKDownloadCenter alloc] init];
        center.loggingEnabled = YES;
    }
    
    return center;
}

- (void)useDownloader:(id<HKDownloader>)downloader {
    _downloader = downloader;
    if (self.loggingEnabled) {
        NSLog(@"Downloader switched to %@", downloader);
    }
}

- (BOOL)downloadHTTPResourceAt:(NSString *)url
                    whenFinish:(HttpResourceDownloadDidFinish)whenFinish {
    return [self downloadHTTPResourceAt:url groupId:nil whenFinish:whenFinish];
}

- (BOOL)downloadHTTPResourceAt:(NSString *)url
                   cacheToDisk:(BOOL)cacheToDisk
                    whenFinish:(HttpResourceDownloadDidFinish)whenFinish {
    return [self downloadHTTPResourceAt:url groupId:nil cacheToDisk:cacheToDisk whenFinish:whenFinish];
}

- (BOOL)downloadHTTPResourceAt:(NSString *)url
                       groupId:(id)groupId
                    whenFinish:(HttpResourceDownloadDidFinish)whenFinish {
    return [self downloadHTTPResourceAt:url groupId:groupId cacheToDisk:NO whenFinish:whenFinish];
}

- (BOOL)downloadHTTPResourceAt:(NSString *)url
                       groupId:(id)groupId
                   cacheToDisk:(BOOL)cacheToDisk
                    whenFinish:(HttpResourceDownloadDidFinish)whenFinish {
    assert(url != nil);
    if (CFDictionaryContainsKey(_tasks, (__bridge const void *)(url))) {
        //如果该url已经在下载队列中，则追加回调到对应任务
        NDHttpResourceOperation * operation = CFDictionaryGetValue(_tasks, (__bridge const void *)(url));
        [operation.callbacks addObject:whenFinish];
    } else {
        NSString * path = [self generateResourceCachePath:url];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            //cache found.
            if (![self isResourceExpired:path]) {
                if (whenFinish != nil) {
                    NSData * data = [[NSData alloc] initWithContentsOfFile:path];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        whenFinish(nil, YES, data);
                    });
                    return NO;
                }
            }
        }
        
        NSURL * resourceUrl = [NSURL URLWithString:url];
        if (resourceUrl != nil) {
            NDHttpResourceOperation * operation = [[NDHttpResourceOperation alloc] initWithURL:resourceUrl];
            if (groupId != nil) {
                operation.groupId = groupId;
            }
            operation.downloader = _downloader;
            operation.delegate = self;
            operation.didFinishSelector = @selector(httpDownloadFinished:);
            [operation.callbacks addObject:whenFinish];
            operation.cacheEnabled = cacheToDisk;
            
            [_queue addOperation:operation];
            [self logDownloadingTasks];
            CFDictionarySetValue(_tasks, (__bridge const void *)(url), (__bridge const void *)(operation));
            return YES;
        } else {
            if (self.loggingEnabled) {
                NSLog(@"Invalid url %@", url);
            }
        }
    }
    
    return NO;
}

- (void)cancelDownloadProcessWithUrl:(NSString *)url {
    assert(url != nil);
    
    if (CFDictionaryContainsKey(_tasks, (__bridge const void *)(url))) {
        NDHttpResourceOperation * operation = CFDictionaryGetValue(_tasks, (__bridge const void *)(url));
        [operation cancel];
        
        CFDictionaryRemoveValue(_tasks, (__bridge const void *)(url));
    }
}

- (void)cancelDownloadProcessWithGroupId:(id)groupId {
    assert(groupId != nil);
    
    CFIndex size = CFDictionaryGetCount(_tasks);
    CFTypeRef * valuesTypeRef = (CFTypeRef *) malloc( size * sizeof(CFTypeRef) );
    CFDictionaryGetKeysAndValues(_tasks, NULL, (const void **) valuesTypeRef);
    const void **values = (const void **) valuesTypeRef;
    
    NDHttpResourceOperation * op = nil;
    for (int i=0; i<size; i++) {
        op = (__bridge NDHttpResourceOperation *)(values[i]);
        if ([op isKindOfClass:[NDHttpResourceOperation class]]) {
            if (op.groupId == groupId) {
                [self cancelDownloadProcessWithUrl:op.url.absoluteString];
            }
        }
    }
    
    free(values);
}

- (void)cancelAllProcesses {
    CFIndex length = CFDictionaryGetCount(_tasks);
    void * values[length];
    
    CFDictionaryGetKeysAndValues(_tasks, NULL, (const void**)&values);
    for (int i=0; i<length; i++) {
        NSOperation * op = (__bridge NSOperation *)values[i];
        [op cancel];
    }
    
    CFDictionaryRemoveAllValues(_tasks);
}

- (BOOL)isDownloadingAtUrl:(NSString *)url {
    return CFDictionaryContainsKey(_tasks, (__bridge const void *)(url));
}

- (BOOL)isGroupExists:(id)groupId {
    assert(groupId != nil);
    
    BOOL isExists = NO;
    
    CFIndex size = CFDictionaryGetCount(_tasks);
    CFTypeRef * valuesTypeRef = (CFTypeRef *) malloc( size * sizeof(CFTypeRef) );
    CFDictionaryGetKeysAndValues(_tasks, NULL, (const void **) valuesTypeRef);
    const void **values = (const void **) valuesTypeRef;
    
    NDHttpResourceOperation * op = nil;
    for (int i=0; i<size; i++) {
        op = (__bridge NDHttpResourceOperation *)(values[i]);
        if ([op isKindOfClass:[NDHttpResourceOperation class]]) {
            if (op.groupId == groupId) {
                isExists = YES;
                break;
            }
        }
    }
    
    free(values);
    
    return isExists;
}

- (BOOL)cleanCaches {
    BOOL isDir = NO;
    NSString * cacheDir = HKDownloaderCacheDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheDir isDirectory:&isDir] && isDir) {
        NSError * error = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:cacheDir error:&error]) {
            if (self.loggingEnabled) {
                NSLog(@"%@", error);
            }
            return NO;
        }
    }
    
    return YES;
}

- (NSString *)cachePathForUrl:(NSString *)url {
    NSString * path = [self generateResourceCachePath:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return path;
    }
    return nil;
}

- (BOOL)updateCacheForUrl:(NSString *)url withData:(NSData *)data {
    NSString * path = [self cachePathForUrl:url];
    NSError * error = nil;
    if (path != nil) {
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
            if (self.loggingEnabled) {
                NSLog(@"Failed to delete cached http resource at %@ due to %@", url, error);
            }
        }
    }
    if (data != nil) {
        BOOL succeeded = [data writeToFile:path atomically:YES];
        if (!succeeded && self.loggingEnabled) {
            NSLog(@"Failed to update cache for url \"%@\"", url);
        }
        return succeeded;
    }
    return YES;
}

@end
