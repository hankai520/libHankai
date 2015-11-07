//
//  UIImage+LangExt.h
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
 *  UIImage 语言扩展
 */
@interface UIImage (LangExt)

/**
 *  图片裁剪（重载）
 *
 *  @param rect                 要裁减的区域
 *  @param newSize              裁减出来的图片的新尺寸（等比缩放至新尺寸）
 *  @param orientationSensitive 是否对设备旋转敏感
 *
 *  @return 裁减出来的新图片
 */
- (UIImage *)clipImageInRect:(CGRect)rect
                     newSize:(CGSize)newSize
        orientationSensitive:(BOOL)orientationSensitive;

/**
 *  图片裁剪
 *
 *  @param rect                 要裁减的区域
 *  @param newSize              裁减出来的图片的新尺寸（等比缩放至新尺寸）
 *  @param orientationSensitive 是否对设备旋转敏感
 *  @param scaleToFill          是否将裁剪出来的图片等笔缩放至完全填充新尺寸
 *
 *  @return 裁剪出来的新尺寸
 */
- (UIImage *)clipImageInRect:(CGRect)rect
                     newSize:(CGSize)newSize
        orientationSensitive:(BOOL)orientationSensitive
                scaleToFill:(BOOL)scaleToFill;//新图是否需要按原图宽高比进行等比缩放来完全满足新尺寸

/**
 *  将图片裁成圆形
 *
 *  @return 裁剪出来的新图片
 */
- (UIImage *)round;

/**
 *  图片缩放
 *
 *  @param newSize 缩放后的新尺寸
 *
 *  @return 缩放后的图片
 */
- (UIImage *)scaleToSize:(CGSize)newSize;

/**
 *  对图片应用滤镜效果（参照 HKFilterManager）
 *
 *  @param filterName 滤镜效果名称
 *
 *  @return 滤镜后的新图片
 */
- (UIImage *)filteredImage:(NSString *)filterName;

/**
 *  将 UIImage 实例转换为 CIImage 实例
 *
 *  @return CIImage 实例
 */
- (CIImage *)toCIImage;

/**
 *  旋转图片
 *
 *  @param angle 要旋转的角度（正值顺时针旋转，负值逆时针）
 *
 *  @return 旋转后的图片
 */
- (UIImage *)rotateWithAngle:(CGFloat)angle;

/**
 *  将图片还原为旋转/镜像处理之前的图片，例如：横置手机拍照后的图片在实际保存后方向是横向的
 *
 *  @return 处理后的图片
 */
- (UIImage *)fixOrientation;

@end
