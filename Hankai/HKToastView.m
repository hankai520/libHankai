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

@interface HKToastView () {
    NSInteger       autoDismissSeconds;//自动消失延迟时长
    
    CGRect          toastFrame;
    
    UIImageView *   backgroundImageView;
    UIImageView *   iconImageView;
    UILabel *       textLabel;
    
    UIEdgeInsets    iconEdgeInsets;
    UIEdgeInsets    textEdgeInsets;
}

@end

@implementation HKToastView

- (void)updateAllConstraints {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //设置背景图片的布局规则
    [backgroundImageView addFullFillConstraints];
    
    //设置图标和文本布局规则
    NSDictionary * views =  NSDictionaryOfVariableBindings(iconImageView, textLabel);
    
    if (iconImageView.image != nil) {
        NSString * vfl = [NSString stringWithFormat:@"H:|-%f-[iconImageView]-%f-[textLabel]",
                          iconEdgeInsets.left, iconEdgeInsets.right + textEdgeInsets.left];
        [iconImageView.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:views]];
        
        vfl = [NSString stringWithFormat:@"V:|-%f-[iconImageView]-%f-|", iconEdgeInsets.top, iconEdgeInsets.bottom];
        [iconImageView.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:views]];
        
        vfl = [NSString stringWithFormat:@"H:[textLabel]-%f-|", textEdgeInsets.right];
        [textLabel.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:views]];
        
        vfl = [NSString stringWithFormat:@"V:|-%f-[textLabel]-%f-|", textEdgeInsets.top, textEdgeInsets.bottom];
        [textLabel.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:views]];
    } else {
        [iconImageView removeConstraints:iconImageView.constraints];
        
        NSString * vfl = [NSString stringWithFormat:@"H:|-%f-[textLabel]-%f-|", textEdgeInsets.left, textEdgeInsets.right];
        [textLabel.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:views]];
        
        vfl = [NSString stringWithFormat:@"V:|-%f-[textLabel]-%f-|", textEdgeInsets.top, textEdgeInsets.bottom];
        [textLabel.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:views]];
    }
}


+ (instancetype)sharedInstance {
    static HKToastView * toast = nil;
    
    if (toast == nil) {
        toast = [[HKToastView alloc] initWithFrame:CGRectZero];
        toast.backgroundColor = [UIColor clearColor];
        toast->autoDismissSeconds = 2;
        
        toast->iconEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        toast->textEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        
        toast->backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        toast->backgroundImageView.backgroundColor = [UIColor clearColor];
        
        toast->iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        toast->iconImageView.backgroundColor = [UIColor clearColor];
        toast->iconImageView.contentMode = UIViewContentModeCenter;
        
        toast->textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        toast->textLabel.backgroundColor = [UIColor clearColor];
        toast->textLabel.font = [UIFont systemFontOfSize:14];
        toast->textLabel.textColor = [UIColor blackColor];
        toast->textLabel.textAlignment = NSTextAlignmentCenter;
        
        [toast addSubview:toast->backgroundImageView];
        [toast addSubview:toast->iconImageView];
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

+ (void)setIconEdgeInsets:(UIEdgeInsets)insets {
    HKToastView * tst = [self sharedInstance];
    tst->iconEdgeInsets = insets;
}

+ (void)setTextEdgeInsets:(UIEdgeInsets)insets {
    HKToastView * tst = [self sharedInstance];
    tst->textEdgeInsets = insets;
}

+ (void)setTextColor:(UIColor *)color {
    HKToastView * tst = [self sharedInstance];
    tst->textLabel.textColor = color;
}

+ (void)setIcon:(UIImage *)icon andBackgroundImage:(UIImage *)background {
    HKToastView * tst = [self sharedInstance];
    tst->backgroundImageView.image = background;
    tst->iconImageView.image = icon;
}

+ (void)presentInWindowWithText:(NSString *)text {
    UIWindow * win = [[UIApplication sharedApplication] keyWindow];
    [self presentInView:win withText:text];
}

+ (void)presentInWindowWithError:(NSError *)error {
    UIWindow * win = [[UIApplication sharedApplication] keyWindow];
    [self presentInView:win withError:error];
}

+ (void)presentInView:(UIView *)container withText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        HKToastView * tst = [self sharedInstance];
        [container addSubview:tst];
        tst.frame = tst->toastFrame;
        tst->textLabel.text = text;
        [tst updateAllConstraints];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:[HKToastView class] selector:@selector(dismiss) object:nil];
        [[HKToastView class] performSelector:@selector(dismiss) withObject:nil afterDelay:tst->autoDismissSeconds];
    });
}

+ (void)presentInView:(UIView *)container withError:(NSError *)error {
    NSMutableString * msg = [NSMutableString string];
    
    NSString * desc = error.userInfo[NSLocalizedDescriptionKey];
    NSString * reason = error.userInfo[NSLocalizedFailureReasonErrorKey];
    NSString * suggestion = error.userInfo[NSLocalizedRecoverySuggestionErrorKey];
    
    if (desc != nil) {
        [msg appendFormat:@"%@", desc];
    }
    
    if (reason != nil) {
        if (desc != nil) {
            [msg appendFormat:@", %@", reason];
        } else {
            [msg appendFormat:@"%@", reason];
        }
    }
    
    if (suggestion != nil) {
        if (desc != nil || reason != nil) {
            [msg appendFormat:@", %@", suggestion];
        } else {
            [msg appendFormat:@"%@", suggestion];
        }
    }
    
    [self presentInView:container withText:[NSString stringWithString:msg]];
}

+ (void)dismiss {
    [NSObject cancelPreviousPerformRequestsWithTarget:[HKToastView class] selector:@selector(dismiss) object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        HKToastView * tst = [self sharedInstance];
        [tst removeFromSuperview];
    });
}

@end
