//
//  HKReflection.m
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

#import "HKReflection.h"

@implementation HKReflection

+ (NSString *)getTypeOfProperty:(objc_property_t)property isRawType:(BOOL *)isRawType {
    const char * type = property_getAttributes(property);
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
        if (isRawType != NULL) {
            *isRawType = NO;
        }
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
        return typeClassName;
    } else {
        if (isRawType != NULL) {
            *isRawType = YES;
        }
    }
    return nil;
}

+ (NSString *)getTypeOfProperty:(NSString *)propertyName ofClass:(Class)clazz isRawType:(BOOL *)isRawType {
    unsigned int numberOfProperties = 0;
    objc_property_t * properties = nil;
    
    Class currentClass = clazz;
    
    //遍历当前类的继承链及各类的属性，找到目标属性
    while (YES) {
        //得到当前类的属性列表
        properties = class_copyPropertyList(currentClass, &numberOfProperties);
        
        //遍历当前类的属性列表
        for (int i=0; i<numberOfProperties; i++) {
            objc_property_t property = properties[i];
            NSString * name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            if ([name isEqualToString:propertyName]) {
                return [self getTypeOfProperty:property isRawType:isRawType];
            }
        }
        free(properties);
        currentClass = [currentClass superclass];
        if (currentClass == [NSObject class]) {
            break;
        }
    }
    return nil;
}

+ (NSString *)getTypeOfProperty:(NSString *)propertyName ofObject:(id)object isRawType:(BOOL *)isRawType {
    Class clazz = [object class];
    return [self getTypeOfProperty:propertyName ofClass:clazz isRawType:isRawType];
}

@end
