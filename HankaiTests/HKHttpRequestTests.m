//
//  HKHttpRequestTests.m
//  Hankai
//
//  Created by 韩凯 on 11/6/15.
//  Copyright © 2015 Hankai. All rights reserved.
//

@import XCTest;
@import Hankai;

@interface HKHttpRequestTests : XCTestCase {
    BOOL done;
}

@end

@implementation HKHttpRequestTests

- (void)setUp {
    [super setUp];
    done = NO;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGet {
    httpGet(@"http://www.baidu.com", nil, ^(NSError *error, HKHttpRequest * originalRequest) {
        NSString * str = [[NSString alloc] initWithData:originalRequest.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        XCTAssertTrue(originalRequest.responseStatusCode == 200);
        done = YES;
    });
    NSDate * timeoutDate = [NSDate dateWithTimeIntervalSinceNow:10];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    } while (!done);
}

- (void)testPost {
    httpPostForm(@"http://www.baidu.com", @{@"kw":@"java"}, ^(NSError *error, HKHttpRequest * originalRequest) {
        NSString * str = [[NSString alloc] initWithData:originalRequest.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        XCTAssertTrue(originalRequest.responseStatusCode == 200);
        done = YES;
    });
    NSDate * timeoutDate = [NSDate dateWithTimeIntervalSinceNow:10];
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    } while (!done);
}

@end
