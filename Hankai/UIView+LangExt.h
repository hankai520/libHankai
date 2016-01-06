//
//  UIView+LangExt.h
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

typedef void (^HKViewTapped)(void);

/**
 *  UIView 语言扩展
 */
@interface UIView (LangExt)

@property (nonatomic, assign) CGFloat   radius; //设置视图的圆角半径

@property (nonatomic, assign) CGFloat   borderWidth; //设置视图的边线宽度

@property (nonatomic, assign) UIColor * borderColor; //设置视图边线颜色

/**
 *  绘制并填充一个圆角矩形
 *
 *  @param rect   矩形区域
 *  @param radius 圆角半径
 */
+ (void)fillRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius;

/**
 *  绘制病渐变填充一个圆角矩形
 *
 *  @param rect   矩形区域
 *  @param colors 填充色数组
 *  @param angle  填充色的渐变方向（90度为垂直渐变）
 */
+ (void) fillGradientInRect:(CGRect)rect withColors:(NSArray*)colors angle:(CGFloat)angle;

/**
 *  让视图的边框闪烁
 *
 *  @param color    高亮色
 *  @param duration 闪烁持续时间
 */
- (void)blinkBorderWithColor:(UIColor *)color duration:(CFTimeInterval)duration;

/*
    duration: 单次旋转动画播放时间
    rotations: 单次旋转角度
    repeatCount 设为 HUGE_VALF，无限播放
 */
/**
 *  持续旋转视图
 *
 *  @param duration    持续时间
 *  @param rotations   旋转的圈数
 *  @param repeatCount 重复次数
 */
- (void)startSpinWithDuration:(NSTimeInterval)duration rotations:(CGFloat)rotations repeatCount:(float)repeatCount;

/**
 *  停止旋转
 */
- (void)stopSpin;

/**
 *  为视图天假自动布局的约束，使其占满整个父视图
 */
- (void)addFullFillConstraints;

/**
 *  使视图在父视图中居中显示
 */
- (void)centerAligned;

/**
 *  为视图绑定一个轻触事件回调
 *
 *  @param action 发生轻触的时候要执行的代码块
 */
- (void)whenTapped:(HKViewTapped)action;


@end
