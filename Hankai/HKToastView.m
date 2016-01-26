//
//  HKToastView.m
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

#import "HKToastView.h"
#import "UIView+LangExt.h"

@interface HKToastView () {
    NSInteger       autoDismissSeconds;//自动消失延迟时长
    CGRect          toastFrame;
    UILabel *       textLabel;
    UIEdgeInsets    textEdgeInsets;
}

@end

@implementation HKToastView

- (void)updateFrames {
    self.frame = toastFrame;
    CGFloat w = toastFrame.size.width - textEdgeInsets.left - textEdgeInsets.right;
    CGFloat h = toastFrame.size.height - textEdgeInsets.top - textEdgeInsets.bottom;
    textLabel.frame = CGRectMake(textEdgeInsets.left, textEdgeInsets.top, w, h);
}

+ (instancetype)sharedInstance {
    static HKToastView * toast = nil;
    
    if (toast == nil) {
        toast = [[HKToastView alloc] initWithFrame:CGRectZero];
        toast.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        toast.radius = 2.0f;
        toast->autoDismissSeconds = 2;
        toast->textEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        
        toast->textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        toast->textLabel.backgroundColor = [UIColor clearColor];
        toast->textLabel.font = [UIFont systemFontOfSize:14];
        toast->textLabel.textColor = [UIColor whiteColor];
        toast->textLabel.textAlignment = NSTextAlignmentCenter;
        
        [toast addSubview:toast->textLabel];
    }
    
    return toast;
}

+ (void)setAutoDismissSeconds:(NSInteger)seconds {
    HKToastView * tst = [self sharedInstance];
    tst->autoDismissSeconds = seconds;
}

+ (void)setToastFrame:(CGRect)frame {
    HKToastView * tst = [self sharedInstance];
    tst->toastFrame = frame;
}

+ (void)setTextColor:(UIColor *)color {
    HKToastView * tst = [self sharedInstance];
    tst->textLabel.textColor = color;
}

+ (void)setTextEdgeInsets:(UIEdgeInsets)insets {
    HKToastView * tst = [self sharedInstance];
    tst->textEdgeInsets = insets;
}

+ (void)presentInWindowWithText:(NSString *)text {
    UIWindow * win = [[UIApplication sharedApplication] keyWindow];
    [self presentInView:win withText:text];
}

+ (void)presentInView:(UIView *)container withText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        HKToastView * tst = [self sharedInstance];
        [container addSubview:tst];
        tst->textLabel.text = text;
        [tst updateFrames];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:[HKToastView class] selector:@selector(dismiss) object:nil];
        [[HKToastView class] performSelector:@selector(dismiss) withObject:nil afterDelay:tst->autoDismissSeconds];
    });
}

+ (void)dismiss {
    [NSObject cancelPreviousPerformRequestsWithTarget:[HKToastView class] selector:@selector(dismiss) object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        HKToastView * tst = [self sharedInstance];
        [tst removeFromSuperview];
    });
}

@end
