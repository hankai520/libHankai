//
//  HKLoadingView.m
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

#import "HKLoadingView.h"
#import "UIView+LangExt.h"

@interface HKLoadingView () {
    UIActivityIndicatorView *   indicator;
    UIView *                    backgroundView;//黑色圆角半透明背景
    UILabel *                   textLabel;
    UIView *                    maskView;//透明遮罩，防止用户点击
}

@end

@implementation HKLoadingView

- (void)updateLayout {
    backgroundView.frame = CGRectMake((self.frame.size.width-200)/2,
                                      (self.frame.size.height-100)/2,
                                      200, 100);
    indicator.frame = CGRectMake((backgroundView.frame.size.width-37)/2,
                                 (backgroundView.frame.size.height-37)/2,
                                 37, 37);
    CGFloat y = backgroundView.frame.size.height - 20 - 8;
    CGFloat w = backgroundView.frame.size.width - 8*2;
    textLabel.frame = CGRectMake(8, y, w, 20);
    
    maskView.frame = self.bounds;
}

+ (instancetype)sharedInstance {
    static HKLoadingView * lv = nil;
    
    if (lv == nil) {
        lv = [[HKLoadingView alloc] initWithFrame:CGRectZero];
        
        lv.backgroundColor = [UIColor clearColor];
        lv->indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        lv->textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        lv->textLabel.backgroundColor = [UIColor clearColor];
        lv->textLabel.font = [UIFont systemFontOfSize:14];
        lv->textLabel.textColor = [UIColor whiteColor];
        lv->textLabel.textAlignment = NSTextAlignmentCenter;
        
        lv->backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        lv->backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        lv->backgroundView.radius = 8.0f;
        [lv->backgroundView addSubview:lv->indicator];
        [lv->backgroundView addSubview:lv->textLabel];
        
        lv->maskView = [[UIView alloc] initWithFrame:CGRectZero];
        lv->maskView.userInteractionEnabled = YES;
        
        [lv addSubview:lv->maskView];
        [lv addSubview:lv->backgroundView];
    }
    
    return lv;
}

#pragma mark - Public

+ (void)presentInWindowWithText:(NSString *)text {
    UIWindow * win = [[UIApplication sharedApplication] keyWindow];
    [self presentInView:win withText:text];
}

+ (void)presentInView:(UIView *)container withText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        HKLoadingView * lv = [self sharedInstance];
        [container addSubview:lv];
        lv.frame = container.bounds;
        lv->textLabel.text = text;
        [lv updateLayout];
        [lv->indicator startAnimating];
    });
}

+ (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        HKLoadingView * lv = [self sharedInstance];
        [lv->indicator stopAnimating];
        [lv removeFromSuperview];
    });
}

@end
