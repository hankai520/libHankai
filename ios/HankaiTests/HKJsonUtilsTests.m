//
//  HKJsonUtilsTests.m
//  Hankai
//
//  Created by 韩凯 on 4/13/14.
//  Copyright (c) 2014 Hankai. All rights reserved.
//

@import XCTest;
@import Hankai;


@interface HKTestObj : NSObject <HKJsonPropertyMappings>

@property (nonatomic, assign) NSUInteger        rawIntVal;

@property (nonatomic, assign) BOOL              rawBoolVal;

@property (nonatomic, strong) NSDate *          dateVal;

@property (nonatomic, strong) NSString *        strVal;

@property (nonatomic, strong) NSNumber *        boolVal;

@property (nonatomic, strong) NSNumber *        numVal;

@end

@implementation HKTestObj

#pragma mark - HKJsonPropertyMappings

- (NSDictionary *)jsonPropertyMappings {
    return nil;
}

- (NSString *)dateFormat {
    return @"yyyy-MM-dd HH:mm:ss";
}

@end


@interface HKJsonUtilsTests : XCTestCase

@end

@implementation HKJsonUtilsTests

- (void)testUpdatePropertiesWithData {
    //字符串 => 日期；字符串 => 布尔；字符串 => 数字
    NSString * json = @"{\"rawIntVal\" : 1,\"rawBoolVal\" : true,\"dateVal\" : \"2015-11-06 11:55:55\",\"strVal\" : \"hello\",\"boolVal\":true, \"numVal\":\"6\"}";
    NSError * error = nil;
    NSDictionary * data = [json jsonObject:&error];
    XCTAssertNil(error);
    HKTestObj * obj = [HKTestObj new];
    [HKJsonUtils updatePropertiesWithData:data forObject:obj];
    XCTAssertTrue(1 == obj.rawIntVal);
    XCTAssertTrue(obj.rawBoolVal);
    NSDate * expect = [NSDate dateFromNSString:@"2015-11-06 11:55:55" withFormat:[obj dateFormat]];
    NSComparisonResult cr = [obj.dateVal compare:expect mode:NSDatePart | NSTimePart];
    XCTAssertTrue([obj.dateVal isKindOfClass:[NSDate class]] && cr == NSOrderedSame);
    XCTAssertEqualObjects(@"hello", obj.strVal);
    XCTAssertTrue([obj.boolVal isKindOfClass:[NSNumber class]] && obj.boolVal.boolValue);
    XCTAssertTrue(6 == obj.numVal.integerValue);
}

@end
