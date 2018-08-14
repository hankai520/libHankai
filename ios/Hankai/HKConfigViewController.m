//
//  HKConfigViewController.m
//  Hankai
//
//  Created by hankai on 14/03/2017.
//  Copyright © 2017 Hankai. All rights reserved.
//

#import "HKConfigViewController.h"

@implementation HKConfig

- (void)persist {
    
}

@end

@interface HKConfigViewController ()

@end

@implementation HKConfigViewController

static HKConfigViewController * instance = nil;

+ (HKConfigViewController *)getInstance {
    if (instance == nil) {
        instance = [HKConfigViewController new];
    }
    return instance;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Public

+ (void)attachToViewController:(UIViewController *)hostController {

}

+ (HKConfig *)getConfiguration {
    return nil;
}

@end
