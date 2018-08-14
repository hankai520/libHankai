//
//  HKMD5Helper.m
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

#import "HKMD5Helper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HKMD5Helper

+ (NSString *)md5OfContentsOfFile:(NSString *)path {
    return nil;
}

+ (NSString *)md5OfNSString:(NSString *)string withEncoding:(NSStringEncoding)encoding {
    NSData * data = [string dataUsingEncoding:encoding];
    return [self md5OfNSData:data];
}

+ (NSString *)md5OfNSData:(NSData *)data {
    if (data.length == 0) {
        return nil;
    } else {
        CC_MD5_CTX md5;
        CC_MD5_Init(&md5);
        CC_MD5_Update(&md5, [data bytes], (CC_LONG)[data length]);
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(result, &md5);
        
        NSString* hash = [NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]];
        return hash;
    }
}

@end
