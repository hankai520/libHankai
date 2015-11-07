//
//  HKJsonUtils.h
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

/**
 *  json 字段和对象属性的映射关系
 */
@protocol HKJsonPropertyMappings <NSObject>

/**
 * 为属性设置别名，键为别名，值为属性名
 */
- (NSDictionary *)jsonPropertyMappings;

/**
 * 遇到日期类型时，将使用指定日期格式来解析
 */
- (NSString *)dateFormat;

@end

/**
 *  JSON 工具类
 */
@interface HKJsonUtils : NSObject

/**
*  将 JSON 字段的值设置到对象对应的属性上。可以注入的对象属性为: NSString, NSNumber ( NSUInteger, float, double, int, bool ), NSDate
*  对于非对象类型的属性，会解析为 NSNumber 类型，然后通过kvc 设置到属性上（中间经过kvc的隐式拆箱操作）
*
*  @param data JSON 对象
*  @param object 要注入属性值的对象
*/
+ (void)updatePropertiesWithData:(NSDictionary *)data forObject:(NSObject<HKJsonPropertyMappings> *)object;

@end
