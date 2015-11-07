//
//  UIAlertView+LangExt.h
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
 *  UIAlertView 语言扩展
 */
@interface UIAlertView (LangExt)

/**
*  用错误来构造一个警告弹出框。
*  title = nil;
*  message = NSLocalizedDescriptionKey + NSLocalizedDescriptionKey + NSLocalizedFailureReasonErrorKey;
*  buttons = NSLocalizedRecoveryOptionsErrorKey，如果没有，则默认会添加一个 OK 按钮，需要在主工程中本地化 "OK"键
*
*  @param error 错误
*
*  @return 弹出框
*/
+ (UIAlertView *)alertViewWithError:(NSError *)error;

/**
 *  弹出一个用于显示信息的警告框，只有一个按钮（重载版本）
 *
 *  @param msg   消息文本
 *  @param title 标题
 */
+ (void)presentAlertWithMessage:(NSString *)msg buttonTitle:(NSString *)title;

/**
 *  弹出一个用于显示信息的警告框，只有一个按钮
 *
 *  @param msg      消息文本
 *  @param title    标题
 *  @param delegate 委托
 */
+ (void)presentAlertWithMessage:(NSString *)msg buttonTitle:(NSString *)title delegate:(id)delegate;

@end
