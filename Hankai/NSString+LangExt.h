//
//  NSString+LangExt.h
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
 *  字符串语言扩展累
 */
@interface NSString (LangExt)

/**
 *  去掉空格和换行
 *
 *  @return 修改后的字符串
 */
- (NSString *)trim;

/**
 *  用正则表达式来分割字符串, 例如: @"aa;bb,cc" 用 @";,"(分号或逗号) 分割后得到[aa, bb, cc]
 *
 *  @param expression 正则表达式
 *
 *  @return 子字符串数组
 */
- (NSArray *)splitWithRegex:(NSString *)expression;

/**
 *  求字符串 md5 值（先编码，后加密）
 *
 *  @param encoding 字符串编码
 *
 *  @return md5 值
 */
- (NSString *)md5EncryptedStringWithEncoding:(NSStringEncoding)encoding;

/**
 *  AES加密（先加密，后编码）
 *
 *  @param key 密钥
 *
 *  @return 密文
 */
- (NSString*)aesEncryptWithBase64EncodingByKey:(NSString*)key;

/**
 *  AES解密（先加密，后编码）
 *
 *  @param key 密钥
 *
 *  @return 明文
 */
- (NSString*)aesDecryptWithBase64EncodingWithKey:(NSString*)key;

/**
 *  对字符串进行 Url 编码
 *
 *  @return 编码后的字符串
 */
- (NSString *)urlEncodedUTF8String;

/**
 *  对字符串进行 Url 解码
 *
 *  @return 解码后的字符串
 */
- (NSString *)urlDecodedUtf8String;

/**
 *  判断是否是空字符串（nil或长度为0的字符串）
 *
 *  @param string 字符串
 *
 *  @return 是否是空字符串
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 *  生成随机的 uuid
 *
 *  @return uuid字符串
 */
+ (NSString *)randomUUID;

/**
 *  将字符串转换为 json 对象
 *
 *  @param error 错误（输出参数）
 *
 *  @return json 对象
 */
- (id)jsonObject:(NSError **)error;

/**
 *  判断字符串是否匹配正则表达式
 *
 *  @param regex 正则表达式
 *
 *  @return 是否匹配
 */
- (BOOL)matchesRegex:(NSString *)regex;

/**
 *  字符串是否包含匹配郑则表达式的子串
 *
 *  @param regex 郑则表达式
 *
 *  @return 是否包含
 */
- (BOOL)containsRegex:(NSString *)regex;

/**
 *  字符串是否满足电子邮箱格式
 *
 *  @return 是否匹配
 */
- (BOOL)isEmail;

@end

/**
 *  字符串是否是一个空字符串
 *
 *  @param str 字符串
 *
 *  @return 是否是空字符串
 */
BOOL isEmptyString(NSString * str);

/**
 *  本地化字符串，支持本地化字串值格式化
 *
 *  @param format 格式
 *  @param ...    参数列表
 *
 *  @return 本地化字串
 */
NSString * NSLocalizedStringWithValueFormat(NSString * format, ...);

//支持键格式化，会用格式化后的键去获取本地化字符串
/**
 *  本地化字符串，支持本地化字串键格式化
 *
 *  @param format 格式
 *  @param ...    参数列表
 *
 *  @return 本地化字串
 */
NSString * NSLocalizedStringWithKeyFormat(NSString * format, ...);