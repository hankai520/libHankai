//
//  UIView+LangExt.m
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

#import "UIView+LangExt.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


@implementation UIView (LangExt)

- (void)setRadius:(CGFloat)value {
    self.layer.cornerRadius = value;
    self.layer.masksToBounds = YES;
}

- (CGFloat)radius {
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)value {
    self.layer.borderWidth = value;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)value {
    self.layer.borderColor = value.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

+ (void)fillRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius {
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
    
	CGContextDrawPath(context, kCGPathFill);
}

+ (void) fillGradientInRect:(CGRect)rect withColors:(NSArray*)colors angle:(CGFloat)angle {
	NSMutableArray *ar = [NSMutableArray array];
	for(UIColor *c in colors){
		[ar addObject:(id)c.CGColor];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ar, NULL);
	
	CGContextClipToRect(context, rect);
	
    CGFloat radian = angle * (M_PI / 180.0f);
    CGFloat startX = (CGRectGetWidth(rect)-CGRectGetHeight(rect)/tanf(radian))/2;
    CGFloat endX = CGRectGetWidth(rect) - startX;
    
	CGPoint start = CGPointMake(startX, 0.0);
	CGPoint end = CGPointMake(endX, rect.size.height);
	
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.layer.borderWidth = 0.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)blinkBorderWithColor:(UIColor *)color duration:(CFTimeInterval)duration {
    self.layer.borderWidth = 4.0f;
    
    CABasicAnimation * blink = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    blink.delegate = self;
    blink.fromValue = (__bridge id)([UIColor whiteColor].CGColor);
    blink.toValue = (__bridge id)(color.CGColor);
    
    blink.duration = duration;
    blink.repeatCount = 2;//动画重复次数
    blink.autoreverses = YES;//是否自动重复
    
    [self.layer addAnimation:blink forKey:@"BlinkBorder"];
}

- (void)startSpinWithDuration:(NSTimeInterval)duration rotations:(CGFloat)rotations repeatCount:(float)repeatCount {
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0f * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeatCount;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopSpin {
    [self.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)addFullFillConstraints {
    UIView * someView = self;
    [someView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary * views = NSDictionaryOfVariableBindings(someView);
    
    [someView.superview addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[someView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]];
    
    [someView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[someView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
}

- (void)centerAligned {
    UIView * parent = self.superview;
    CGFloat x = (parent.frame.size.width - self.frame.size.width) / 2;
    CGFloat y = (parent.frame.size.height - self.frame.size.height) / 2;
    self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
}



static NSString * const HKViewTappedActionKey      = @"whenTapped";

- (void)invokeTappedAction {
    HKViewTapped block = objc_getAssociatedObject(self, &HKViewTappedActionKey);
    block();
}

- (void)whenTapped:(HKViewTapped)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGr = nil;
    for (UIGestureRecognizer * gr in self.gestureRecognizers) {
        if ([gr isKindOfClass:[UITapGestureRecognizer class]]) {
            tapGr = (UITapGestureRecognizer *)gr;
            break;
        }
    }
    if (tapGr == nil) {
        tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(invokeTappedAction)];
        [self addGestureRecognizer:tapGr];
    } else {
        [tapGr addTarget:self action:@selector(invokeTappedAction)];
    }
    
    objc_setAssociatedObject(self, &HKViewTappedActionKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
