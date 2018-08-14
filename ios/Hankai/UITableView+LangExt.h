//
//  UITableView+LangExt.h
//  Hankai
//
//  Created by 韩凯 on 1/29/16.
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
 *  表格控件语言扩展
 */
@interface UITableView (LangExt)

/**
 *  表格无内容时，显示的占位信息。
 *  切勿在 UITableViewDataSource 相关方法实现中使用，因为在这些方法被执行时，已经进入了表格的重绘事务中，
 *  此时，对界面进行操作并不会触发重绘，可能导致未知的界面错误。因此必须在表格的 reloadData 方法触发前调用此方法。
 *
 *  @param text 文本信息
 */
- (void)showPlaceholderWithText:(NSString *)text;

/**
 *  隐藏表格占位信息
 *  切勿在 UITableViewDataSource 相关方法实现中使用，因为在这些方法被执行时，已经进入了表格的重绘事务中，
 *  此时，对界面进行操作并不会触发重绘，可能导致未知的界面错误。因此必须在表格的 reloadData 方法触发前调用此方法。
 */
- (void)hidePlaceholder;

@end
