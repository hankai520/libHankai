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

@property (nonatomic, strong) NSString * prop1;

@property (nonatomic, assign) NSUInteger prop2;

@property (nonatomic, assign) BOOL prop3;

@property (nonatomic, strong) NSDate * prop4;

@property (nonatomic, strong) NSString * prop5;

@end

@implementation HKTestObj

#pragma mark - HKJsonPropertyMappings

- (NSDictionary *)jsonPropertyMappings {
    return @{
             @"p1": @"prop1",
             @"p2": @"prop2",
             @"p3": @"prop3",
             @"p4": @"prop4",
             @"p5": @"prop5"
             };
}

- (NSString *)dateFormat {
    return @"yyyy-MM-dd HH:mm:ss";
}

@end



@interface HKJsonUtilsTests : XCTestCase

@end

@implementation HKJsonUtilsTests

- (void)testUpdatePropertiesWithData {
    NSString * json = @"{\"p1\" : \"prop111\",\"p2\" : 222,\"p3\" : true,\"p4\" : \"2015-11-06 11:55:55\",\"p5\":null}";
    NSError * error = nil;
    NSDictionary * data = [json jsonObject:&error];
    XCTAssertNil(error);
    HKTestObj * obj = [HKTestObj new];
    [HKJsonUtils updatePropertiesWithData:data forObject:obj];
    XCTAssertTrue([obj.prop1 isKindOfClass:[NSString class]] && [obj.prop1 isEqualToString:@"prop111"]);
    XCTAssertTrue(obj.prop2 == 222);
    XCTAssertTrue(obj.prop3);
    NSComparisonResult cr = [obj.prop4 compare:[NSDate dateFromNSString:@"2015-11-06 11:55:55" withFormat:[obj dateFormat]] mode:NSDatePart | NSTimePart];
    XCTAssertTrue([obj.prop4 isKindOfClass:[NSDate class]] && cr == NSOrderedSame);
    XCTAssertTrue(obj.prop5 == nil);
}

@end
