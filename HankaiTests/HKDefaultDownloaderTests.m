//
//  HKDefaultDownloaderTests.m
//  Hankai
//
//  Created by 韩凯 on 1/4/16.
//  Copyright © 2016 Hankai. All rights reserved.
//

@import XCTest;
@import Hankai;

@interface HKDefaultDownloaderTests : XCTestCase

@end

@implementation HKDefaultDownloaderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDownload {
    HKDefaultDownloader * downloader = [[HKDefaultDownloader alloc] init];
    NSError * error = nil;
    NSData * data = [downloader downloadResourceAt:[NSURL URLWithString:@"http://www.baidu.com"] error:&error];
    XCTAssertTrue(data != nil && data.length > 0);
}

@end
