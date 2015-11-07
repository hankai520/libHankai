//
//  HKFileSystem.m
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

#import "HKFileSystem.h"

@implementation HKFileSystem

+ (unsigned long long int)cacheItemSize:(NSString *)path {
    unsigned long long int size = 0;
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL exists = [fm fileExistsAtPath:path isDirectory:&isDir];
    if (exists) {
        if (isDir) {
            NSString * cacheDir = AppCachesDirectory;
            NSArray * treeNodes = [fm subpathsAtPath:cacheDir];
            NSEnumerator * enumerator = [treeNodes objectEnumerator];
            
            NSString * node = nil;
            unsigned long long s = 0;
            while (node = [enumerator nextObject]) {
                NSError * error = nil;
                NSDictionary * attributes = [fm attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:node] error:&error];
                if (error == nil) {
                    s += [attributes fileSize];
                }
            }
            size = s;
        } else {
            NSError * error = nil;
            NSDictionary * attributes = [fm attributesOfItemAtPath:path error:&error];
            unsigned long long s = [attributes fileSize];
            if (error == nil) {
                size = s;
            }
        }
    }
    return size;
}

+ (void)cleanCaches {
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error = nil;
    NSString * dir = AppCachesDirectory;
    NSArray * items = [fm contentsOfDirectoryAtPath:dir error:&error];
    if (error == nil) {
        for (NSString * item in items) {
            error = nil;
            [fm removeItemAtPath:[dir stringByAppendingPathComponent:item] error:&error];
            if (error != nil) {
                NSLog(@"%@", error);
            }
        }
    } else {
        NSLog(@"%@", error);
    }
}

@end
