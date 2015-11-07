//
//  HKActionView.h
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

//通知：ActionView 已隐藏时发送
extern NSString * const HKActionViewDidDismiss;
//通知：ActionView 即将显示时发送
extern NSString * const HKActionViewWillAppear;

//ActionView 动画类型
typedef enum {
    HKActionViewAnimationVerticalMove, //默认值
    HKActionViewAnimationFade
} HKActionViewAnimation;

/**
 *  提供弹出式/滑出式的模态窗口，例如：从底部弹出 Picker 等。
 */
@interface HKActionView : UIView

@property (nonatomic, assign, readonly)    BOOL         isShown; //是否正在显示

/**
 *  用于控制action view的纵向位置，在弹出action view时会加上这个额外的偏移量。主要为了解决不同iOS版本和硬件差异。
 *  由于目前 iOS 设备尺寸差异主要集中在高度，因此只提供了纵向偏移。
 *
 *  @param value 偏移值
 */
+ (void)setExtraYOffset:(CGFloat)value;

/**
 *  弹出窗口
 *
 *  @param parentView 父视图，弹出的窗口将作为子视图被添加进去
 *  @param isModal    是否模态。模态下，窗口以外部分点击无响应，否则点击会隐藏窗口
 *  @param animation  动画类型
 */
- (void)showInView:(UIView *)parentView modal:(BOOL)isModal animation:(HKActionViewAnimation)animation;

/**
 *  弹出窗口（重载版本）
 *
 *  @param parentView 父视图，弹出的窗口将作为子视图被添加进去
 *  @param isModal    是否模态。模态下，窗口以外部分点击无响应，否则点击会隐藏窗口
 */
- (void)showInView:(UIView *)parentView modal:(BOOL)isModal;

/**
 *  弹出窗口（重载版本）
 *
 *  @param parentView 父视图，弹出的窗口将作为子视图被添加进去
 */
- (void)showInView:(UIView *)parentView;

/**
 *  隐藏窗口
 */
- (void)dismiss;

@end
