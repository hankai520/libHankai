//
//  UIImageView+LangExt.h
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
 *  UIImageView 语言扩展
 */
@interface UIImageView (LangExt)

/**
 *  渐进式的更新图片（淡入淡出）
 *
 *  @param image 淡入的图片
 */
- (void)setImageWithTransition:(UIImage *)image;

/**
 *  从网络下载图片并更新到 UIImageView
 *
 *  @param url              图片地址
 *  @param showIndicator    是否显示活动提示
 *  @param indicatorStyle   活动提示的样式
 *  @param imageDidLoad     图片下载完后的回调块
 */
- (void)setImageWithUrl:(NSString *)url
          showIndicator:(BOOL)showIndicator
         indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle
           imageDidLoad:(void (^)(NSError * error))imageDidLoad;

/**
 *  从网络下载图片并更新到 UIImageView （重载版本），显示小尺寸灰色活动提示，下载完成的回调为空
 *
 *  @param url              图片地址
 */
- (void)setImageWithUrl:(NSString *)url;

@end
