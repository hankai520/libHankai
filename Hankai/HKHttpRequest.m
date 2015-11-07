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

@interface HKHttpRequest () <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    __strong HKHttpRequestDidFinished    requestDidFinish;
}

@property (nonatomic, strong) NSURLConnection *         connection;

@property (nonatomic, strong) NSMutableData *           allData;

@property (nonatomic, strong) NSMutableURLRequest *     request;

@property (nonatomic, strong) NSHTTPURLResponse *       response;

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

- (NSData *)responseData {
    if (self.allData != nil && self.allData.length > 0) {
        return [NSData dataWithData:self.allData];
    }
    return nil;
}

- (void)setCompletionBlock:(HKHttpRequestDidFinished)aCompletionBlock {
    if (aCompletionBlock != nil) {
        requestDidFinish = aCompletionBlock;
    }
}

+ (HKHttpRequest *)get:(NSString *)url withParams:(NSDictionary *)params {
    HKHttpRequest * req = [[HKHttpRequest alloc] init];
    NSString * queryString = [self buildQueryString:params urlEncode:YES sortAsc:YES];
    NSURL * reqUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", url, queryString]];
    req.request = [[NSMutableURLRequest alloc] initWithURL:reqUrl
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:15];
    req.request.HTTPMethod = @"GET";
    req.allData = [[NSMutableData alloc] initWithCapacity:64];
    req.connection = [[NSURLConnection alloc] initWithRequest:req.request delegate:req startImmediately:NO];
    return req;
}

+ (HKHttpRequest *)post:(NSString *)url withParams:(NSDictionary *)params {
    NSString * queryString = [self buildQueryString:params urlEncode:YES sortAsc:YES];
    return [self post:url withData:queryString];
}

+ (HKHttpRequest *)post:(NSString *)url withData:(NSString *)dataString {
    HKHttpRequest * req = [[HKHttpRequest alloc] init];
    NSURL * reqUrl = [NSURL URLWithString:url];
    req.request = [[NSMutableURLRequest alloc] initWithURL:reqUrl
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:15];
    req.request.HTTPMethod = @"POST";
    [req.request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    req.request.HTTPBody = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    req.allData = [[NSMutableData alloc] initWithCapacity:64];
    req.connection = [[NSURLConnection alloc] initWithRequest:req.request delegate:req startImmediately:NO];
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

- (void)start {
    [self.connection start];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    requestDidFinish(error, nil, 0, nil);
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return NO;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        self.response = (NSHTTPURLResponse *)response;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.allData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (requestDidFinish != nil) {
        requestDidFinish(nil, [NSData dataWithData:self.allData], self.response.statusCode, self.response.allHeaderFields);
    }
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