//  NSDate+LangExt.m
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

#import "NSDate+LangExt.h"


#define EarlierThan(result) ({__typeof__(result) __r = (result); (__r == NSOrderedAscending);})
#define EarlierThanOrEqualTo(result) ({__typeof__(result) __r = (result); (__r == NSOrderedAscending) || (__r == NSOrderedSame);})
#define LaterThan(result) ({__typeof__(result) __r = (result); (__r == NSOrderedDescending);})
#define LaterThanOrEqualTo(result) ({__typeof__(result) __r = (result); (__r == NSOrderedDescending) || (__r == NSOrderedSame);})
#define Equal(result) (#result == NSOrderedSame)


@interface NSDate (Private)

+ (NSDateFormatter *)sharedFormatter;

- (NSDateComponents *)dateParts:(NSUInteger)flags;

- (NSTimeInterval)timeIntervalSince1970WithoutTimeParts;

@end

@implementation NSDate (Private)

+ (NSDateFormatter *)sharedFormatter {
    //为避免性能问题，共享一个实例
    static NSDateFormatter * dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
    }
    
    return dateFormatter;
}

- (NSDateComponents *)dateParts:(NSUInteger)flags {
	NSDateComponents * comp = [[NSCalendar currentCalendar] components:flags fromDate:self];
    return comp;
}

- (NSTimeInterval)timeIntervalSince1970WithoutTimeParts {
    return [self timeIntervalSince1970] - self.hour*SecondsPerHour - self.minute*SecondsPerMinute - self.second;
}

@end



#pragma mark - Date Parts

@implementation NSDate (DateParts)

- (NSInteger)year {
    return [self dateParts:NSYearCalendarUnit].year;
}

- (NSInteger)month {
    return [self dateParts:NSMonthCalendarUnit].month;
}

- (NSInteger)day {
    return [self dateParts:NSDayCalendarUnit].day;
}

- (NSInteger)hour {
    return [self dateParts:NSHourCalendarUnit].hour;
}

- (NSInteger)minute {
    return [self dateParts:NSMinuteCalendarUnit].minute;
}

- (NSInteger)second {
    return [self dateParts:NSSecondCalendarUnit].second;
}

@end


#pragma mark - Date Compare

@implementation NSDate (DateCompare)

- (BOOL)isSameDay:(NSDate *)date {
    if (date.year == self.year && date.month == self.month && date.day == self.day) {
        return YES;
    }
    
    return NO;
}

- (NSComparisonResult)compare:(NSDate *)other mode:(NSDateCompareMode)mode {
    if ((mode & NSDatePart) && (mode & NSTimePart)) {
        return [self compare:other];
    } else if (mode & NSDatePart) {
        NSTimeInterval selfInterval = [self timeIntervalSince1970];
        NSTimeInterval otherInterval = [other timeIntervalSince1970];
        
        NSInteger s = SecondsPerDay;
        NSInteger selfDays = selfInterval / s;
        NSInteger otherDays = otherInterval / s;
        
        if (selfDays > otherDays) {
            return NSOrderedDescending;
        } else if (selfDays == otherDays) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    } else if (mode & NSTimePart) {
        NSInteger selfSeconds = self.hour*SecondsPerHour + self.minute*SecondsPerMinute + self.second;
        NSInteger otherSeconds = other.hour*SecondsPerHour + other.minute*SecondsPerMinute + other.second;
        
        if (selfSeconds > otherSeconds) {
            return NSOrderedDescending;
        } else if (selfSeconds == otherSeconds) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }
    
    @throw [NSException
            exceptionWithName:@"InvalidDateCompareMode"
            reason:[NSString stringWithFormat:@"No such date compare mode %d", mode]
            userInfo:nil];
}

- (BOOL)betweensDate:(NSDate *)date1 andDate:(NSDate *)date2 mode:(NSDateCompareMode)mode range:(NSDateRangeMode)range {
    NSComparisonResult result1 = [self compare:date1 mode:mode];
    NSComparisonResult result2 = [self compare:date2 mode:mode];
    
    if (range == NSDateRangeClosed) {
        if (LaterThanOrEqualTo(result1) && EarlierThanOrEqualTo(result2)) {
            return YES;
        }
        return NO;
    } else if (range == NSDateRangeOpen) {
        if (LaterThan(result1) && EarlierThan(result2)) {
            return YES;
        }

        return NO;
    } else if (range == NSDateRangeLeftClosed) {
        if (LaterThanOrEqualTo(result1) && EarlierThan(result2)) {
            return YES;
        }
        
        return NO;
    } else if (range == NSDateRangeRightClosed) {
        if (LaterThan(result1) && EarlierThanOrEqualTo(result2)) {
            return YES;
        }
        
        return NO;
    }
    
    @throw [NSException
            exceptionWithName:@"InvalidDateRangeMode"
            reason:[NSString stringWithFormat:@"No such date range mode %d", range]
            userInfo:nil];
}

@end


#pragma mark - Date Calculation

@implementation NSDate (Calculation)

- (NSInteger)timeIntervalInDaysSinceDate:(NSDate *)date {
    NSTimeInterval interval1 = [self timeIntervalSince1970WithoutTimeParts];
    NSTimeInterval interval2 = [date timeIntervalSince1970WithoutTimeParts];
    
    NSTimeInterval interval = floor(interval1) - floor(interval2);
    return interval/60/60/24;
}

- (NSInteger)timeIntervalInDaysSinceNow {
    return [self timeIntervalInDaysSinceDate:[NSDate date]];
}

@end



#pragma mark - Date Generation

@implementation NSDate (Generation)

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSTimeInterval interval = SecondsPerDay * days;
    return [self dateByAddingTimeInterval:interval];
}

+ (NSArray *)datesBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 range:(NSDateRangeMode)range {
    //如果传入的日期大小不正确，调整大小
    NSDate * startDate = nil;
    NSDate * endDate = nil;
    
    if ([date1 earlierDate:date2] == date1) {
        startDate = date1;
        endDate = date2;
    } else {
        startDate = date2;
        endDate = date1;
    }
    
    NSMutableArray * dates = [NSMutableArray array];
    
    if (range == NSDateRangeClosed || range == NSDateRangeLeftClosed) {
        [dates addObject:startDate];
    }
    
    NSDate * nextDay = [startDate dateByAddingDays:1];
    NSDate * d = [endDate dateByAddingDays:-1];
    while (![nextDay isSameDay:d]) {
        [dates addObject:nextDay];
        nextDay = [nextDay dateByAddingDays:1];
    }
    
    if (range == NSDateRangeClosed || range == NSDateRangeRightClosed) {
        [dates addObject:endDate];
    }
    
    return [NSArray arrayWithArray:dates];
}

+ (NSDate *)dateFromDateInfo:(NSDateInfo)dateInfo {
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    comps.year = dateInfo.year;
    comps.month = dateInfo.month;
    comps.day = dateInfo.day;
    comps.hour = dateInfo.hour;
    comps.minute = dateInfo.minute;
    comps.second = dateInfo.second;
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSDateInfo)dateInfo {
    NSUInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:flag fromDate:self];
    NSDateInfo  dateInfo;
    dateInfo.year = comps.year;
    dateInfo.month = comps.month;
    dateInfo.day = comps.day;
    dateInfo.hour = comps.hour;
    dateInfo.minute = comps.minute;
    dateInfo.second = comps.second;
    
    return dateInfo;
}

+ (NSDate *)dateFromNSString:(NSString *)string withFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone {
    NSDateFormatter * fmt = [NSDate sharedFormatter];
    [fmt setDateFormat:format];
    if (timeZone != nil) {
        fmt.timeZone = timeZone;
    }
    NSDate * date = [fmt dateFromString:string];
    return date;
}

+ (NSDate *)dateFromNSString:(NSString *)string withFormat:(NSString *)format {
    return [self dateFromNSString:string withFormat:format timeZone:[NSTimeZone systemTimeZone]];
}

@end



#pragma mark - Date Formatting

@implementation NSDate (Format)

- (NSString *)toNSString:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)zone {
    NSDateFormatter * fmt = [NSDate sharedFormatter];
    
    if (locale != nil) {
        fmt.locale = locale;
    }
    
    if (zone != nil) {
        fmt.timeZone = zone;
    }
    
    [fmt setDateFormat:format];
    NSString* strDate = [fmt stringFromDate:self];
    return strDate;
}

- (NSString *)toNSString:(NSString *)format {
    return [self toNSString:format locale:[NSLocale currentLocale] timeZone:[NSTimeZone systemTimeZone]];
}

@end
