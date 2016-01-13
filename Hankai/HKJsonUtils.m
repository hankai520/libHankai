//
//  HKJsonUtils.m
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

#import "HKJsonUtils.h"
#import "HKReflection.h"
#import "NSDate+LangExt.h"

@implementation HKJsonUtils

+ (void)updatePropertiesWithData:(NSDictionary *)data forObject:(NSObject<HKJsonPropertyMappings> *)object {
    //得到属性映射表
    if ([object respondsToSelector:@selector(jsonPropertyMappings)]) {
        NSDictionary * mappings = [object jsonPropertyMappings];
        
        //遍历数据字典
        for (NSString * alias in data) {
            NSString * propertyName = mappings[alias];
            if (propertyName == nil) {
                propertyName = alias;//如果没有设置别名，则默认别名和属性名相同
            }
            id value = data[alias];
            BOOL isNil = [value isKindOfClass:[NSNull class]];
            if ([value isKindOfClass:[NSNumber class]] ||
                [value isKindOfClass:[NSString class]] ||
                isNil) {//true, false, number
                //如果是JSON基本数据类型，且类型兼容，则直接赋值
                BOOL isRawType = NO;
                NSString * type = [HKReflection getTypeOfProperty:propertyName ofObject:object isRawType:&isRawType];
                if (isRawType) {
                    @try {
                        [object setValue:value forKey:propertyName];
                    } @catch (NSException *exception) {}
                } else {
                    if (type != nil) {
                        Class clazz = NSClassFromString(type);
                        if (![value isKindOfClass:clazz]) {
                            if (clazz == [NSDate class]) {
                                if ([object respondsToSelector:@selector(dateFormat)]) {
                                    NSString * fmt = [object dateFormat];
                                    if ([fmt isEqualToString:TIMESTAMP_FORMAT]) {
                                        value = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
                                    } else {
                                        value = [NSDate dateFromNSString:value withFormat:fmt];
                                    }
                                }
                            }
                        }
                        if (isNil) {
                            value = nil;
                        }
                        @try {
                            [object setValue:value forKey:propertyName];
                        } @catch (NSException *exception) {}
                    }
                }
            }
        }
    }
}

@end
