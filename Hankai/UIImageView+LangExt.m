//
//  UIImageView+LangExt.m
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

#import "UIImageView+LangExt.h"
#import "HKDownloadCenter.h"
#import "NSString+LangExt.h"
@import QuartzCore;

@implementation UIImageView (LangExt)

#pragma mark - Public

- (void)setImageWithTransition:(UIImage *)image {
    self.image = image;
    
    CATransition * transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:nil];
}

- (void)setImageWithUrl:(NSString *)url
          showIndicator:(BOOL)showIndicator
         indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
           imageDidLoad:(void (^)(NSError * error))imageDidLoad {
    if (isEmptyString(url)) {
        return;
    }
    UIActivityIndicatorView * iv = [self viewWithTag:8888];
    if (showIndicator) {
        if (iv == nil) {
            iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
            iv.hidesWhenStopped = YES;
            iv.backgroundColor = [UIColor clearColor];
            iv.tag = 8888;
            [self addSubview:iv];
        }
        CGSize size = self.frame.size;
        iv.frame = CGRectMake(ceilf((size.width-iv.frame.size.width)/2),
                              ceilf((size.height-iv.frame.size.height)/2),
                              iv.frame.size.width,
                              iv.frame.size.height);
        [iv startAnimating];
    }
    [[HKDownloadCenter defaultCenter] downloadHTTPResourceAt:url
                                                 cacheToDisk:YES
                                                  whenFinish:^(NSError *error, BOOL fromCache, NSData *data) {
                                                      if (data.length > 0) {
                                                          self.image = [UIImage imageWithData:data];
                                                      }
                                                      if (imageDidLoad != nil) {
                                                          imageDidLoad(error);
                                                      }
                                                      if (showIndicator) {
                                                          [iv stopAnimating];
                                                      }
                                                  }];
}

- (void)setImageWithUrl:(NSString *)url {
    [self setImageWithUrl:url showIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray imageDidLoad:nil];
}

@end
