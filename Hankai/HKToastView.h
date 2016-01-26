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

@import UIKit;

/**
 * 仿android的消息提示框（黑色半透明背景，白色文字，圆角矩形区块）。
 *
 */

/*
 控件布局大致如下：
 
   * * * * * * * * * * * * * * * * * * * * * * * * *
  *                     background                  *
 *                                                   *
 *          * * * * * * * * * * * * * * *            *
 *          * text                      *            *
 *          *                           *            *
 *          * * * * * * * * * * * * * * *            *
 *                                                   *
  *                                                 *
   * * * * * * * * * * * * * * * * * * * * * * * * *

 */

@interface HKToastView : UIView

/**
 *  设置多长时间后自动消失
 *
 *  @param seconds 延时秒数
 */
+ (void)setAutoDismissSeconds:(NSInteger)seconds;

/**
 *  设置在显示时出现的屏幕位置
 *
 *  @param frame 在屏幕中的位置和尺寸信息
 */
+ (void)setToastFrame:(CGRect)frame;

/**
 *  设置文本颜色
 *
 *  @param color 文本色
 */
+ (void)setTextColor:(UIColor *)color;

/**
 *  设置文本周边留白大小
 *
 *  @param insets 留白大小
 */
+ (void)setTextEdgeInsets:(UIEdgeInsets)insets;

/**
 *  在窗口中弹出提示
 *
 *  @param text 文本
 */
+ (void)presentInWindowWithText:(NSString *)text;

/**
 *  在父视图中弹出提示
 *
 *  @param container 父视图
 *  @param text      文本
 */
+ (void)presentInView:(UIView *)container withText:(NSString *)text;

/**
 *  隐藏提示消息
 */
+ (void)dismiss;

@end
