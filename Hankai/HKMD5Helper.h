//
//  HKMD5Helper.h
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

@import Foundation;

/**
 *  MD5 算法封装类
 */
@interface HKMD5Helper : NSObject

/**
 *  计算文件MD5
 *
 *  @param path 文件路径
 *
 *  @return 32位16进制小写字符串
 */
+ (NSString *)md5OfContentsOfFile:(NSString *)path;

/**
 *  计算字符串MD5
 *
 *  @param string   明文字串
 *  @param encoding 字符串编码
 *
 *  @return 32位16进制小写字符串
 */
+ (NSString *)md5OfNSString:(NSString *)string withEncoding:(NSStringEncoding)encoding;

/**
 *  计算数据的MD5
 *
 *  @param data 明文数据
 *
 *  @return 32位16进制小写字符串
 */
+ (NSString *)md5OfNSData:(NSData *)data;

@end
