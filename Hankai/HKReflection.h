//
//  HKReflection.h
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
#import <objc/runtime.h>

/**
 *  反射（内省）助手类。
 */
@interface HKReflection : NSObject

/**
 *  获取类属性的类型名称。对于对象类型，会返回类名，而对于非对象类型（float, int 等），则会返回兼容的对象类型（NSNumber）
 *
 *  @param property 类属性
 *
 *  @return 类型名称，例如：NSString
 */
+ (NSString *)getTypeOfProperty:(objc_property_t)property isRawType:(BOOL *)isRawType;

/**
 *  获取类属性的类型名称（重载）。
 *
 *  @param propertyName 属性字段名称
 *  @param clazz        字段所属类
 *
 *  @return 类型名称，例如：NSString
 */
+ (NSString *)getTypeOfProperty:(NSString *)propertyName ofClass:(Class)clazz isRawType:(BOOL *)isRawType;

/**
 *  获取类属性的类型名称（重载）。
 *
 *  @param propertyName 属性字段名称
 *  @param object       字段所属类的实例
 *
 *  @return 类型名称，例如：NSString
 */
+ (NSString *)getTypeOfProperty:(NSString *)propertyName ofObject:(id)object isRawType:(BOOL *)isRawType;

@end
