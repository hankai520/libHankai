//
//  NSObject+LangExt.m
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

#import "NSObject+LangExt.h"

@implementation NSObject (LangExt)

- (NSData *)jsonData {
    BOOL serializable = NO;
    if ([self isKindOfClass:[NSArray class]]) {
        serializable = YES;
    } else if ([self isKindOfClass:[NSDictionary class]]) {
        serializable = YES;
    }
    if (serializable) {
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (data != nil && error == nil) {
            return data;
        }
    }
    return nil;
}

- (NSString *)jsonString {
    NSData * data = [self jsonData];
    if (data != nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end


BOOL isNull(id obj) {
    if (obj == nil || obj == [NSNull null]) {
        return YES;
    }
    return NO;
}

NSInteger randomInteger(NSInteger min, NSInteger max) {
    return (NSInteger)(arc4random() % (max - min) + min);
}