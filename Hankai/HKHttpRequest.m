//
//  HKHttpRequest.m
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

#import "HKHttpRequest.h"
#import <NSString+LangExt.h>

#define multipartBoundary       @"175a5274fa537f856d116be2f6542033"

@implementation HKRequestPart

@end

/**
 *  NSURLSessionDataTask 完成回调块
 *
 *  @param data     响应数据
 *  @param response 响应对象
 *  @param error    错误
 */
typedef void (^NSURLSessionTaskCompletionHandler)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error);

@interface HKHttpRequest () {
    __strong HKHttpRequestDidFinished               requestDidFinish;
    __strong NSURLSessionTaskCompletionHandler      taskCompletionHandler;
}

@property (nonatomic, strong) NSURLSessionTask *        sessionTask;

@property (nonatomic, strong) NSMutableURLRequest *     request;

@property (nonatomic, strong) NSHTTPURLResponse *       response;

@property (nonatomic, strong, readwrite) NSData *        responseData;

@end

@implementation HKHttpRequest

- (NSString *)url {
    return self.request.URL.absoluteString;
}

- (NSString *)method {
    return self.request.HTTPMethod;
}

- (NSString *)queryString {
    return self.request.URL.query;
}

- (NSInteger)responseStatusCode {
    if (self.sessionTask.state == NSURLSessionTaskStateCompleted) {
        return self.response.statusCode;
    }
    return -1;
}

- (NSDictionary *)responseHeaders {
    if (self.sessionTask.state == NSURLSessionTaskStateCompleted) {
        return self.response.allHeaderFields;
    }
    return nil;
}

- (void)setCompletionBlock:(HKHttpRequestDidFinished)aCompletionBlock {
    if (aCompletionBlock != nil) {
        requestDidFinish = aCompletionBlock;
    }
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        __block HKHttpRequest * req = self;
        self->taskCompletionHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            req.response = (NSHTTPURLResponse *)response;
            if (error == nil) {
                req.responseData = data;
                req->requestDidFinish(nil, req);
            } else {
                req->requestDidFinish(error, req);
            }
        };
    }
    return self;
}

+ (instancetype)get:(NSString *)url withParams:(NSDictionary *)params {
    HKHttpRequest * req = [[HKHttpRequest alloc] init];
    NSMutableString * urlString = [NSMutableString stringWithString:url];
    if (params != nil && params.count > 0) {
        NSString * queryString = [self buildQueryString:params urlEncode:YES sortAsc:YES];
        [urlString appendFormat:@"?%@", queryString];
    }
    NSURL * reqUrl = [NSURL URLWithString:urlString];
    req.request = [[NSMutableURLRequest alloc] initWithURL:reqUrl
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:15];
    req.request.HTTPMethod = @"GET";
    req.sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:req.request completionHandler:req->taskCompletionHandler];
    return req;
}

+ (instancetype)post:(NSString *)url withParams:(NSDictionary *)params {
    NSString * queryString = [self buildQueryString:params urlEncode:YES sortAsc:YES];
    return [self post:url withData:queryString];
}

+ (instancetype)post:(NSString *)url withData:(NSString *)dataString {
    HKHttpRequest * req = [[HKHttpRequest alloc] init];
    NSURL * reqUrl = [NSURL URLWithString:url];
    req.request = [[NSMutableURLRequest alloc] initWithURL:reqUrl
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:15];
    req.request.HTTPMethod = @"POST";
    [req.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    req.request.HTTPBody = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    req.sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:req.request completionHandler:req->taskCompletionHandler];
    return req;
}

+ (instancetype)post:(NSString *)url withParts:(NSArray *)parts {
    HKHttpRequest * req = [[HKHttpRequest alloc] init];
    NSURL * reqUrl = [NSURL URLWithString:url];
    req.request = [[NSMutableURLRequest alloc] initWithURL:reqUrl
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:15];
    req.request.HTTPMethod = @"POST";
    NSString * boundary = multipartBoundary;
    [req.request addValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    req.request.HTTPBody = [self buildMultipart:parts boundary:boundary];
    
    req.sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:req.request completionHandler:req->taskCompletionHandler];
    return req;
}

+ (NSString *)buildQueryString:(NSDictionary *)params urlEncode:(BOOL)urlEncode sortAsc:(BOOL)sortAsc {
    if (params == nil || params.count == 0) {
        return @"";
    }
    NSArray * keys = params.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2 options:NSCaseInsensitiveSearch | NSAnchoredSearch];
        if (result == NSOrderedAscending) {
            return sortAsc ? NSOrderedAscending : NSOrderedDescending;
        } else if (result == NSOrderedDescending) {
            return sortAsc ? NSOrderedDescending : NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];

    NSMutableArray * pairs = [[NSMutableArray alloc] initWithCapacity:[params count]];
    NSString * value = nil;
    for (NSString * key  in keys) {
        value = params[key];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncode ? [value urlEncodedUTF8String] : value]];
    }
    NSString * query = [pairs componentsJoinedByString:@"&"];
    return query;
}

+ (NSData *)buildMultipart:(NSArray *)parts boundary:(NSString *)boundary {
    NSMutableData * data = [[NSMutableData alloc] init];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    for (HKRequestPart * part in parts) {
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:encoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;name=\"%@\"\r\n\r\n", part.name]
                          dataUsingEncoding:encoding]];
        [data appendData:part.data];
        [data appendData:[@"\r\n" dataUsingEncoding:encoding]];
    }
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", multipartBoundary] dataUsingEncoding:encoding]];
    
    return [NSData dataWithData:data];
}

- (void)start {
    [self.sessionTask resume];
}

@end


void httpGet(NSString * url, NSDictionary * params, HKHttpRequestDidFinished callback) {
    HKHttpRequest * request = [HKHttpRequest get:url withParams:params];
    [request setCompletionBlock:callback];
    [request start];
}

void httpPostForm(NSString * url, NSDictionary * params, HKHttpRequestDidFinished callback) {
    HKHttpRequest * request = [HKHttpRequest post:url withParams:params];
    [request setCompletionBlock:callback];
    [request start];
}

void httpPostJson(NSString * url, NSString * json, HKHttpRequestDidFinished callback) {
    HKHttpRequest * request = [HKHttpRequest post:url withData:json];
    [request setCompletionBlock:callback];
    [request start];
}

void httpPostFiles(NSString * url, NSArray * localPaths, HKHttpRequestDidFinished callback) {
    NSMutableArray * parts = [NSMutableArray array];
    for (NSString * path in localPaths) {
        HKRequestPart * p = [HKRequestPart new];
        p.name = [path lastPathComponent];
        p.data = [NSData dataWithContentsOfFile:path];
    }
    HKHttpRequest * request = [HKHttpRequest post:url withParts:[NSArray arrayWithArray:parts]];
    [request setCompletionBlock:callback];
    [request start];
}