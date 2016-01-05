//
//  NSData+LangExt.h
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

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

/**
 *  NSData 语言扩展
 */
@interface NSData (LangExt)

/**
*  用AES算法对数据进行加密
*
*  @param key       密钥
*  @param keySize   密钥长度（CommonCryptor.h line 184）
*  @param operation 加密/解密
*
*  @return 密文数据
*/
- (NSData*)aesCryptWithKey:(NSString *)key keySize:(size_t)keySize operation:(CCOperation)operation;

/**
 *  用MD5算法对数据进行加密
 *
 *  @return 32位16进制字符串（小写）
 */
- (NSString *)md5Encrypt;

/**
 *  将数据作为JSON，转换为对象（NSArray, NSDictionary）
 *
 *  @return NSArray, NSDictionary 对象
 */
- (id)jsonObject;

@end
