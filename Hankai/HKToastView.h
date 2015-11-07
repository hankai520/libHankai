//
//  HKToastView.h
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

#import <UIKit/UIKit.h>

/**
 * 仿android的消息提示框。允许自定义背景图片，提示图标。
 *
 */

/*
 控件布局大致如下：
 
   * * * * * * * * * * * * * * * * * * * * * * * * *
  *                     background                  *
 *                                                   *
 *   * * * * *    * * * * * * * * * * * * * * *      *
 *   *  icon *    * text                      *      *
 *   *       *    *                           *      *
 *   * * * * *    * * * * * * * * * * * * * * *      *
 *                                                   *
  *                                                 *
   * * * * * * * * * * * * * * * * * * * * * * * * *

 */

@interface HKToastView : UIView

+ (void)setAutoDismissSeconds:(NSInteger)seconds;

+ (void)setToastFrame:(CGRect)frame;

+ (void)setIconEdgeInsets:(UIEdgeInsets)insets;

+ (void)setTextEdgeInsets:(UIEdgeInsets)insets;

+ (void)setTextColor:(UIColor *)color;

+ (void)setIcon:(UIImage *)icon andBackgroundImage:(UIImage *)background;

+ (void)presentInWindowWithText:(NSString *)text;

+ (void)presentInWindowWithError:(NSError *)error;

+ (void)presentInView:(UIView *)container withText:(NSString *)text;

+ (void)presentInView:(UIView *)container withError:(NSError *)error;

+ (void)dismiss;

@end
