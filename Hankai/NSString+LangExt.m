//
//  NSString+LangExt.m
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

#import "NSString+LangExt.h"
#import <CommonCrypto/CommonCryptor.h>
#import "HKMD5Helper.h"
#import "HKAESHelper.h"
#import "HKBase64.h"
#import "NSData+LangExt.h"

@implementation NSString (LangExt)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *)splitWithRegex:(NSString *)expression {
    NSMutableArray * arr = [NSMutableArray array];
    NSError * err = nil;
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"[^%@]+", expression]
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&err];
    if (err == nil) {
        NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        NSRange rangeOfLastMatch;
        rangeOfLastMatch.location = rangeOfLastMatch.length = 0;
        for (NSTextCheckingResult * match in matches) {
            if (match.range.length > 0) {
                [arr addObject:[self substringWithRange:match.range]];
            }
        }
        
        //if arr has no item, that means no separators found, return the whole string.
        if ([arr count] == 0) {
            [arr addObject:self];
        }
    } else {
        NSLog(@"Failed to build regular expression with pattern %@", expression);
    }
    
    return [NSArray arrayWithArray:arr];
}

- (NSString *)md5EncryptedStringWithEncoding:(NSStringEncoding)encoding {
    return [HKMD5Helper md5OfNSString:self withEncoding:encoding];
}

- (NSString *)aesEncryptWithBase64EncodingByKey:(NSString *)key {
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData * encrypted = [HKAESHelper cryptData:data withKey:key keySize:kCCKeySizeAES128 operation:kCCEncrypt];
    NSString * encoded = [HKBase64 encode:encrypted];
    return encoded;
}

- (NSString *)aesDecryptWithBase64EncodingWithKey:(NSString *)key {
    NSData * decoded = [HKBase64 decode:self];
    NSData * decrypted = [decoded aesCryptWithKey:key keySize:kCCKeySizeAES128 operation:kCCDecrypt];
    NSString * decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    return decryptedString;
}

- (NSString *)urlEncodedUTF8String {
    NSString * encodedString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           NULL,
                                                                                           (CFStringRef)@":/=,!$&'()*+;[]@#?",
                                                                                           kCFStringEncodingUTF8);
	return encodedString;
}

- (NSString *)urlDecodedUtf8String {
    NSString * decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                            (CFStringRef)self,
                                                                                                            CFSTR(""),
                                                                                                            kCFStringEncodingUTF8);
    return decodedString;
}

+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil || [string isKindOfClass:[NSNull class]] || ([string isKindOfClass:[NSString class]] && [string trim].length == 0)) {
		return YES;
	}
	return NO;
}

+ (NSString *)randomUUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
	CFStringRef uuidStrRef = CFUUIDCreateString(NULL, uuidRef);
	NSString * strUUID = (__bridge NSString*)uuidStrRef;
	CFRelease(uuidRef);
	CFRelease(uuidStrRef);
	return strUUID;
}


- (id)jsonObject:(NSError *__autoreleasing *)error {
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

- (BOOL)matchesRegex:(NSString *)regex {
    NSError * error = nil;
    NSRegularExpression * expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
    NSRange range = NSMakeRange(0, self.length);
    NSArray * matches = [expression matchesInString:self options:0 range:range];
    if ([matches count] > 0) {
        NSTextCheckingResult * result = matches[0];
        if (result.range.location == range.location && result.range.length == range.length) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)containsRegex:(NSString *)regex {
    NSError * error = nil;
    NSRegularExpression * expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
    NSRange range = NSMakeRange(0, self.length);
    NSUInteger count = [expression numberOfMatchesInString:self options:0 range:range];
    return count > 0;
}

- (BOOL)isEmail {
    return [self matchesRegex:@"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"];
}

@end


BOOL isEmptyString(NSString * str) {
    return [NSString isEmpty:str];
}

NSString * NSLocalizedStringWithValueFormat(NSString * format, ...) {
    NSString * localized = nil;
    
    va_list args;
    va_start(args, format);
    NSString * key = NSLocalizedString(format, nil);
    if (![key isEqualToString:format]) {
        localized = [[NSString alloc] initWithFormat:key arguments:args];
    }
    va_end(args);
    
    return localized;
}

NSString * NSLocalizedStringWithKeyFormat(NSString * format, ...) {
    NSString * localized = nil;
    
    va_list args;
    va_start(args, format);
    NSString * key = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    localized = NSLocalizedString(key, nil);
    
    return localized;
}
