//
//  NSObject+LangExt.h
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
 *  NSObject 语言扩展
 */
@interface NSObject (LangExt)

/**
 *  尝试将当前对象转换为JSON格式的二进制数据
 *
 *  @return 二进制数据
 */
- (NSData *)jsonData;

/**
 *  尝试将当前对象转换为JSON格式的字符串
 *
 *  @return JSON字符串
 */
- (NSString *)jsonString;

@end

BOOL isNull(id obj);

/**
 *  获取一个范围内的随机数
 *
 *  @param min 最小值
 *  @param max 最大值
 *
 *  @return 随机数
 */
NSInteger randomInteger(NSInteger min, NSInteger max);

#define HKRDM(min, max)     (randomInteger(min, max))