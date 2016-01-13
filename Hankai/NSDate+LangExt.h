//
//  NSDate+LangExt.h
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


@import UIKit;

static NSInteger const SecondsPerMinute    = 60;
static NSInteger const SecondsPerHour      = SecondsPerMinute * 60;
static NSInteger const SecondsPerDay       = SecondsPerHour * 24;

//当前系统时间戳
#define HKTimestamp                       ([[NSDate date] timeIntervalSince1970])

//常用日期格式
#define DEFAULT_DATE_FORMAT             @"yyyy-MM-dd"
#define DATE_FORMAT1                    @"yyyy/MM/dd EE" //... 周二
#define DATE_FORMAT2                    @"yyyy/MM/dd EEEE" //... 星期三
#define DATE_FORMAT3                    @"yyyy/MM/dd"

#define DEFAULT_DATE_TIME_FORMAT        @"yyyy-MM-dd HH:mm:ss"//12小时制

#define DEFAULT_TIME_FORMAT             @"HH:mm:ss"
#define TIME_FORMAT1                    @"hh:mm"
#define TIME_FORMAT2                    @"HH:mm"

#define TIMESTAMP_FORMAT                @"timestamp" //时间戳格式：1970年至今的秒数

//日期对比模式掩码
typedef enum {
    NSDatePart  = 0x01,
    NSTimePart  = 0x10
} NSDateCompareMode;

//判断日期是否在一个区间内时使用的掩码
typedef enum {
    NSDateRangeClosed,      //闭区间           <=> []
    NSDateRangeOpen,        //开区间           <=> ()
    NSDateRangeLeftClosed,  //左闭右开区间      <=> [)
    NSDateRangeRightClosed  //左开右闭区间      <=> (]
} NSDateRangeMode;

//日期结构体
typedef struct {
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
} NSDateInfo;


@interface NSDate (DateParts)

@property (nonatomic, readonly) NSInteger year;

@property (nonatomic, readonly) NSInteger month;

@property (nonatomic, readonly) NSInteger day;

@property (nonatomic, readonly) NSInteger hour;

@property (nonatomic, readonly) NSInteger minute;

@property (nonatomic, readonly) NSInteger second;

@end


@interface NSDate (DateCompare)

/**
 *  判断date和当前实例是否是同一天
 *
 *  @param date 要判断的日期
 *
 *  @return 是否是同一天
 */
- (BOOL)isSameDay:(NSDate *)date;

/**
 *  比较日期的日期部分、时间部分或日期和时间部分
 *
 *  @param other 要对比的日期
 *  @param mode  对比模式
 *
 *  @return 对比结果
 */
- (NSComparisonResult)compare:(NSDate *)other mode:(NSDateCompareMode)mode;

/**
 *  检查日期是否处于某个日期范围内
 *
 *  @param date1 起始日期
 *  @param date2 结束日期
 *  @param mode  对比模式
 *  @param range 日期范围
 *
 *  @return 是否在范围内
 */
- (BOOL)betweensDate:(NSDate *)date1 andDate:(NSDate *)date2 mode:(NSDateCompareMode)mode range:(NSDateRangeMode)range;

@end

/**
 *  日期计算
 */
@interface NSDate (Calculation)

/**
 *  计算当前实例距离指定 日期的天数，正数表示在指定日期之后，负数表示在指定日期之前
 *
 *  @param date 要对比的日期
 *
 *  @return 天数
 */
- (NSInteger)timeIntervalInDaysSinceDate:(NSDate *)date;

/**
 *  计算当前实例距离当前日期的天数，正数表示在当前日期之后，负数表示在当前日期之前
 *
 *  @return 天数
 */
- (NSInteger)timeIntervalInDaysSinceNow;

@end

/**
 *  日期生成
 */
@interface NSDate (Generation)

/**
 *  获取若干天后/前的日期
 *
 *  @param days 天数，正数表示求未来的日期，负数表示求过去的日期
 *
 *  @return 生成的日期
 */
- (NSDate *)dateByAddingDays:(NSInteger)days;

/**
 *  获取一个日期范围内的所有日期
 *
 *  @param date1 起始日期
 *  @param date2 结束日期
 *  @param range 日期范围匹配掩码
 *
 *  @return 日期数组
 */
+ (NSArray *)datesBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 range:(NSDateRangeMode)range;

/**
 *  用日期信息结构体构造一个日期
 *
 *  @param dateInfo 日期信息结构体
 *
 *  @return 日期
 */
+ (NSDate *)dateFromDateInfo:(NSDateInfo)dateInfo;

/**
 *  获取一个日期的日期信息
 *
 *  @return 日期信息结构体
 */
- (NSDateInfo)dateInfo;

/**
 *  根据字符串和日期格式来构造日期对象（重载版本，使用当前系统时区）
 *
 *  @param string 日期字符串
 *  @param format 日期格式
 *
 *  @return 日期对象
 */
+ (NSDate *)dateFromNSString:(NSString *)string withFormat:(NSString *)format;

/**
 *  根据字符串和日期格式来构造日期对象
 *
 *  @param string   日期字符串
 *  @param format   日期格式
 *  @param timeZone 时区
 *
 *  @return 日期对象
 */
+ (NSDate *)dateFromNSString:(NSString *)string withFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;

@end

/**
 *  日期格式化
 */
@interface NSDate (Format)

/**
*  将日期转换为字符串
*
*  @param format 日期格式
*  @param locale 区域
*  @param zone   时区
*
*  @return 日期字符串
*/
- (NSString *)toNSString:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)zone;

/**
 *  将日期转换为字符串
 *
 *  @param format 日期格式
 *
 *  @return 日期字符串
 */
- (NSString *)toNSString:(NSString *)format;

@end
