//
//  HKTextViewViewController.h
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

@class HKTextViewViewController;

@protocol HKTextViewViewControllerDelegate <NSObject>

- (void)textViewController:(HKTextViewViewController *)controller didFinishEditingWithText:(NSString *)text;

@end

/**
 *  文本编辑界面控制器。提供文本编辑控制包括文本长度限制，文本框事件处理。
 *  该控制器用于控制多行文本的编辑界面。
 */
@interface HKTextViewViewController : UITableViewController <UITextViewDelegate> {
    IBOutlet UITextView *   textView;
    IBOutlet UILabel *      lenthLabel;
}

@property (nonatomic, assign) NSInteger     maxLength; //文本长度限制

@property (nonatomic, strong) NSString *    initialText; //初始文本

@property (nonatomic, assign) IBOutlet id<HKTextViewViewControllerDelegate> delegate; //委托对象

/**
 *  响应编辑完成事件，用于处理“完成”按钮事件，调用后会向委托对象发起编辑完成的回调。
 *
 *  @param sender 事件源
 */
- (IBAction)finishEditing:(id)sender;


@end
