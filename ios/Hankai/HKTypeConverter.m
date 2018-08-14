//
//  HKTypeConverter.m
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

#import "HKTypeConverter.h"
#import "NSString+LangExt.h"
#import "NSDate+LangExt.h"

/**
 数字转换器，将数字转换为支持的其他类型。
 */
@interface HKNumberConverter : NSObject <HKTypeConverter>

@end

@implementation HKNumberConverter

- (Class)sourceType {
    return [NSNumber class];
}

- (NSArray *)acceptableTargetTypes {
    return @[[NSString class]];
}

- (BOOL)canConvertInstance:(id)sourceObj toTargetType:(Class)targetType {
    if ([sourceObj isKindOfClass:[self sourceType]]) {
        NSArray * acceptTypes = [self acceptableTargetTypes];
        for (Class clazz in acceptTypes) {
            if ([targetType isSubclassOfClass:clazz]) {
                return YES;
            }
        }
    }
    return NO;
}

- (id)convertSourceInstance:(id)sourceObj toTargetType:(Class)targetType {
    if ([sourceObj isKindOfClass:[self sourceType]]) {
        if (targetType == [NSString class]) {
            return [(NSNumber *)sourceObj stringValue];
        }
    }
    return sourceObj;
}

@end

/**
 字符串转换器。
 */
@interface HKStringConverter : NSObject <HKTypeConverter>

@property (nonatomic, strong) NSMutableSet *     dateFormats;

@end

@implementation HKStringConverter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormats = [NSMutableSet setWithObjects:DEFAULT_DATE_FORMAT, DATE_FORMAT1,
                            DATE_FORMAT2, DATE_FORMAT3, DEFAULT_DATE_TIME_FORMAT, DEFAULT_TIME_FORMAT,
                            TIME_FORMAT1, TIME_FORMAT2, nil];
    }
    return self;
}

- (Class)sourceType {
    return [NSString class];
}

- (NSArray *)acceptableTargetTypes {
    return @[[NSDate class], [NSNumber class]];
}

- (BOOL)canConvertInstance:(id)sourceObj toTargetType:(Class)targetType {
    if ([sourceObj isKindOfClass:[self sourceType]]) {
        NSArray * acceptTypes = [self acceptableTargetTypes];
        for (Class clazz in acceptTypes) {
            if ([targetType isSubclassOfClass:clazz]) {
                return YES;
            }
        }
    }
    return NO;
}

- (id)convertSourceInstance:(id)sourceObj toTargetType:(Class)targetType {
    if ([sourceObj isKindOfClass:[self sourceType]]) {
        NSString * string = (NSString *)sourceObj;
        if (targetType == [NSDate class]) {
            NSDate * date = nil;
            for (NSString * fmt in self.dateFormats) {
                if ([fmt isEqualToString:TIMESTAMP_FORMAT]) {
                    double timestamp = [string doubleValue];
                    if (timestamp > 0) {
                        date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    }
                } else {
                    date = [NSDate dateFromNSString:string withFormat:fmt];
                }
                if (date != nil) {
                    break;
                }
            }
            return date;
        } else if (targetType == [NSNumber class]) {
            if ([[string lowercaseString] isEqualToString:@"y"] ||
                [[string lowercaseString] isEqualToString:@"yes"] ||
                [[string lowercaseString] isEqualToString:@"true"] ||
                [[string lowercaseString] isEqualToString:@"1"]) {
                return [NSNumber numberWithBool:YES];
            } else if ([[string lowercaseString] isEqualToString:@"n"] ||
                       [[string lowercaseString] isEqualToString:@"no"] ||
                       [[string lowercaseString] isEqualToString:@"false"] ||
                       [[string lowercaseString] isEqualToString:@"0"]) {
                return [NSNumber numberWithBool:NO];
            } else if ([string matchesRegex:@"\\d*"]) {
                return [string toNSNumber];
            }
        }
    }
    return nil;
}

@end

@interface HKTypeConverterCenter()

@property (nonatomic, strong) NSMutableArray *              converters;//键：源类型+目标类型；值：转换器

@property (nonatomic, strong) HKStringConverter *           stringConverter;

@end

@implementation HKTypeConverterCenter

static HKTypeConverterCenter *  center;

/**
 获取转换中心的实例。

 @return 实例
 */
+ (HKTypeConverterCenter *)getInstance {
    if (center == nil) {
        center = [HKTypeConverterCenter new];
        center.converters = [NSMutableArray array];
        //注册內建的转换器。
        [self registerConverter:[HKNumberConverter new]];
        HKStringConverter * sc = [HKStringConverter new];
        [self registerConverter:sc];
        center.stringConverter = sc;
    }
    return center;
}

+ (void)addDateFormat:(NSString *)format {
    NSMutableSet * formats = [self getInstance].stringConverter.dateFormats;
    [formats addObject:format];
}

+ (void)registerConverter:(id<HKTypeConverter>)converter {
    if ([converter conformsToProtocol:@protocol(HKTypeConverter)]) {
        NSMutableArray * converters = [self getInstance].converters;
        [converters addObject:converter];
    }
}

+ (id)convert:(id)object toType:(Class)type {
    NSString * srcType = [[object class] description];
    NSString * tarType = [type description];
    if (!isEmptyString(srcType) && !isEmptyString(tarType)) {
        NSMutableArray * converters = [self getInstance].converters;
        for (id<HKTypeConverter> cvt in converters) {
            if ([cvt canConvertInstance:object toTargetType:type]) {
                return [cvt convertSourceInstance:object toTargetType:type];
            }
        }
    }
    return nil;
}

@end
