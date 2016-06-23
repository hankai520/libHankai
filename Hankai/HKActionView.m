//
//  HKActionView.m
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

#import "HKActionView.h"

NSString * const HKActionViewDidDismiss    = @"HKActionViewDidDismiss";
NSString * const HKActionViewWillAppear    = @"HKActionViewWillAppear";

@interface HKActionView () {
    HKActionViewAnimation   _animation;
}

@property (nonatomic, retain)               UIView*       parentView;

@property (nonatomic, retain)               UIView *      backgroundView;

@property (nonatomic, assign, readwrite)    BOOL          isShown;

@end

@implementation HKActionView

- (void)dealloc {
    self.parentView = nil;
    self.backgroundView = nil;
}

#pragma mark Override



#pragma mark Private

- (void)backgroundTapped {
    [self dismiss];
}

- (void)playShowAnimation:(HKActionViewAnimation)animation {
    // the background color will change from transparent to opaque with animation.
    self.backgroundView.alpha = 0.0f;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (animation == HKActionViewAnimationFade) {
        //在中间显示
        [self setCenter:CGPointMake(self.parentView.frame.size.width/2, self.parentView.frame.size.height/2)];
        self.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundView.alpha = 0.6f;
            self.alpha = 1.0f;
        }];
    } else {
        // set the position of action view to make it invisible.
        self.frame = CGRectMake(self.parentView.frame.origin.x,
                                self.parentView.frame.origin.y + self.parentView.frame.size.height,
                                self.frame.size.width,
                                self.frame.size.height);
        
        [UIView animateWithDuration:0.3f animations:^{
            self.backgroundView.alpha = 0.6f;
            
            self.frame = CGRectMake(self.parentView.frame.origin.x,
                                    self.parentView.frame.size.height - self.frame.size.height + HKActionViewYOffset,
                                    self.frame.size.width,
                                    self.frame.size.height);
        }];
    }
}

- (void)playDismissAnimation:(HKActionViewAnimation)animation {
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = 0.0f;
        
        if (animation == HKActionViewAnimationFade) {
            self.alpha = 0.0f;
        } else {
            self.frame = CGRectMake(self.parentView.frame.origin.x,
                                    self.parentView.frame.origin.y + self.parentView.frame.size.height,
                                    self.frame.size.width,
                                    self.frame.size.height);
        }
    } completion:^(BOOL finished) {
        self.parentView = nil;
        
        [self.backgroundView removeFromSuperview];
        
        [self removeFromSuperview];
        
        self.isShown = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:HKActionViewDidDismiss object:nil];
    }];
}

#pragma mark Public

static CGFloat  HKActionViewYOffset     = 0;

+ (void)setExtraYOffset:(CGFloat)value {
    HKActionViewYOffset = value;
}

- (void)showInView:(UIView *)parentView modal:(BOOL)isModal animation:(HKActionViewAnimation)animation {
    if (self.isShown) {
        return;
    }
    
    _animation = animation;
    
    self.parentView = parentView;
    
    self.isShown = YES; // It is not allowed to show action view when the action view is being displayed.
    
    if (isModal && self.backgroundView == nil) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
        [self.backgroundView addGestureRecognizer:gr];
        self.backgroundView.backgroundColor = [UIColor grayColor];
    }
    
    //adjust size of background view, set full-size according to parent view's size.
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.parentView.frame.size.width, self.frame.size.height);
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        self.backgroundView.frame = CGRectMake(0.0f, 0.0f,
                                               self.parentView.frame.size.height,
                                               self.parentView.frame.size.width);
    } else {
        self.backgroundView.frame = CGRectMake(0.0f, 0.0f,
                                               self.parentView.frame.size.width,
                                               self.parentView.frame.size.height);
    }
    
    [parentView addSubview:self.backgroundView];
    
    [parentView addSubview:self];
    
    [self playShowAnimation:animation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HKActionViewWillAppear object:nil];
}

- (void)showInView:(UIView *)parentView modal:(BOOL)isModal {
    [self showInView:parentView modal:isModal animation:HKActionViewAnimationVerticalMove];
}

- (void)showInView:(UIView *)parentView {
    [self showInView:parentView modal:YES];
}

- (void)dismiss {
    if (!self.isShown) {
        return;
    }
    
    [self playDismissAnimation:_animation];
}

@end
