//
//  UITableViewCell+LangExt.h
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

#ifndef __MAC_OS_X_VERSION_MIN_REQUIRED

#import <UIKit/UIKit.h>

/**
 *  UITableViewCell 语言扩展
 */
@interface UITableViewCell (LangExt)

//use tag to identify cell in xib when xib contains multiple cells.
/**
 *  从一个定义了多个 UITableViewCell 的 xib 文件中加载特定 UITableViewCell
 *
 *  @param nibName xib 文件名（必须在主 Bundle 中）
 *  @param tag     UITableViewCell 的 tag 值
 *
 *  @return UITableViewCell 实例
 */
+ (instancetype)cellFromNib:(NSString *)nibName tag:(NSInteger)tag;

@end

#endif