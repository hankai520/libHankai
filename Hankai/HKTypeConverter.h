//
//  HKTypeConverter.h
//  Hankai
//
//  Created by hankai on 18/02/2017.
//  Copyright © 2017 Hankai. All rights reserved.
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

@protocol HKTypeConverter <NSObject>

/**
 可处理的源类型。

 @return 源类型
 */
- (Class)sourceType;

/**
 可转换的目标类型。

 @return 目标类型
 */
- (NSArray *)acceptableTargetTypes;

/**
 是否可以转换。

 @param sourceObj 源对象
 @param targetType 目标类型
 @return 是否可以转换
 */
- (BOOL)canConvertInstance:(id)sourceObj toTargetType:(Class)targetType;

/**
 将源类型实例转换为目标类型实例。

 @param sourceObj 源类型实例
 @param targetType 目标类型
 @return 目标类型实例
 */
- (id)convertSourceInstance:(id)sourceObj toTargetType:(Class)targetType;

@end

/**
 类型转换器。
 */
@interface HKTypeConverterCenter : NSObject

/**
 增加日期格式（用于日期转换）。

 @param format 日期格式
 */
+ (void)addDateFormat:(NSString *)format;

/**
 注册类型转换器。

 @param converter 转换器
 */
+ (void)registerConverter:(id<HKTypeConverter>)converter;

/**
 将实例转换为指定类型的实例。

 @param object 源实例
 @param type 目标欧类型
 @return 目标类型的实例（返回 nil 表示无法转换）
 */
+ (id)convert:(id)object toType:(Class)type;

@end
