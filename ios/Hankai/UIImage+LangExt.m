//
//  UIImage+LangExt.m
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

#import "UIImage+LangExt.h"
#import "HKFilterManager.h"

CGRect TransformCGRectForUIImageOrientation(CGRect source, UIImageOrientation orientation, CGSize imageSize) {
    switch (orientation) {
        case UIImageOrientationLeft: { // EXIF #8
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI_2);
            return CGRectApplyAffineTransform(source, txCompound);
        }
        case UIImageOrientationDown: { // EXIF #6
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI);
            return CGRectApplyAffineTransform(source, txCompound);
        }
        case UIImageOrientationRight: { // EXIF #3
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI + M_PI_2);
            return CGRectApplyAffineTransform(source, txCompound);
        }
        case UIImageOrientationUp: // EXIF #1 - do nothing
        default: // EXIF 2,4,5,7 - ignore
            return source;
    }
}

@implementation UIImage (LangExt)

- (UIImage *)clipImageInRect:(CGRect)rect
                     newSize:(CGSize)newSize
        orientationSensitive:(BOOL)orientationSensitive
                 scaleToFill:(BOOL)scaleToFill {
    CGRect actualRect = rect;
    
    if (orientationSensitive) {
        actualRect = TransformCGRectForUIImageOrientation(rect, self.imageOrientation, self.size);
    }
    
    CGImageRef clippedImageRef = CGImageCreateWithImageInRect(self.CGImage, actualRect);
    
    UIImage * scaledImage = nil;
    
    if (CGSizeEqualToSize(newSize, rect.size) || !scaleToFill) {
        scaledImage = [UIImage imageWithCGImage:clippedImageRef scale:1.0f orientation:self.imageOrientation];
    } else {
        //根据原图比例计算出实际绘图区域
        CGRect drawingRect;
        
        CGFloat selfWidth = self.size.width, selfHeight = self.size.height;
        
        CGFloat ratio = selfWidth / selfHeight;
        
        CGFloat wRatio = newSize.width / selfWidth;
        CGFloat hRatio = newSize.height / selfHeight;
        
        if (wRatio != 1 || hRatio != 1) {
            if (wRatio < hRatio) {
                drawingRect.size.width = newSize.width;
                drawingRect.size.height = drawingRect.size.width / ratio;
            } else {
                drawingRect.size.height = newSize.height;
                drawingRect.size.width = drawingRect.size.height * ratio;
            }
            
            drawingRect.origin.x = fabs(newSize.width - drawingRect.size.width) / 2;
            drawingRect.origin.y = fabs(newSize.height - drawingRect.size.height) / 2;
        } else {
            drawingRect = CGRectMake(0, 0, selfWidth, selfHeight);
        }
        
        UIGraphicsBeginImageContext(newSize);
        
        UIImage * clippedImage = [UIImage imageWithCGImage:clippedImageRef scale:1.0f orientation:self.imageOrientation];
        
        [clippedImage drawInRect:drawingRect];
        
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    CGImageRelease(clippedImageRef);
    
    return scaledImage;
}

- (UIImage *)clipImageInRect:(CGRect)rect
                     newSize:(CGSize)newSize
        orientationSensitive:(BOOL)orientationSensitive {
    return [self clipImageInRect:rect newSize:newSize orientationSensitive:orientationSensitive scaleToFill:YES];
}

- (UIImage *)round {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    CGContextClosePath(context);
    CGContextClip(context);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    UIImage * clippedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return clippedImage;
}

- (UIImage *)scaleToSize:(CGSize)newSize {
    if (CGSizeEqualToSize(newSize, self.size)) {
        return self;
    }

    UIGraphicsBeginImageContext(newSize);
    
    //根据原图比例计算出实际绘图区域
    CGRect drawingRect;

    CGFloat ratio = self.size.width / self.size.height;
    
    CGFloat wRatio = newSize.width / self.size.width;
    CGFloat hRatio = newSize.height / self.size.height;
    
    if (wRatio != 1 || hRatio != 1) {
        if (wRatio < hRatio) {
            drawingRect.size.width = newSize.width;
            drawingRect.size.height = drawingRect.size.width / ratio;
        } else {
            drawingRect.size.height = newSize.height;
            drawingRect.size.width = drawingRect.size.height * ratio;
        }
        
        drawingRect.origin.x = fabs(newSize.width - drawingRect.size.width) / 2;
        drawingRect.origin.y = fabs(newSize.height - drawingRect.size.height) / 2;
    } else {
        drawingRect = CGRectMake(0, 0, self.size.width, self.size.height);
    }
    
    [self drawInRect:drawingRect];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)filteredImage:(NSString *)filterName {
    if ([HKFilterManager isFilterAvailable:filterName]) {
        return [HKFilterManager processImage:self withFilterNamed:filterName];
    }
    return nil;
}

- (CIImage *)toCIImage {
    if (self.CIImage != nil) {
        return self.CIImage;
    } else if (self.CGImage != nil) {
        //CGImage based
        return [[CIImage alloc] initWithCGImage:self.CGImage];
    } else {
        NSData * data = UIImagePNGRepresentation(self);
        return [[CIImage alloc] initWithData:data];
    }
}

- (UIImage *)rotateWithAngle:(CGFloat)angle {
    UIView * rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.size.width, self.size.height)];
    float angleRadians = angle * ((float)M_PI / 180.0f);
    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, angleRadians);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGRect rect = CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height);
    CGContextDrawImage(bitmap, rect, [self CGImage]);
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    //如果朝向不正确，则先旋转
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (self.imageOrientation == UIImageOrientationDown ||
        self.imageOrientation == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
    } else if (self.imageOrientation == UIImageOrientationLeft ||
               self.imageOrientation == UIImageOrientationLeftMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    } else if (self.imageOrientation == UIImageOrientationRight ||
               self.imageOrientation == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, 0, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
    }
    
    //如果是镜像图片，则需要翻转
    if (self.imageOrientation == UIImageOrientationUpMirrored ||
        self.imageOrientation == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    } else if (self.imageOrientation == UIImageOrientationLeftMirrored ||
               self.imageOrientation == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, self.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             self.size.width,
                                             self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage),
                                             0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    if (self.imageOrientation == UIImageOrientationLeft ||
        self.imageOrientation == UIImageOrientationLeftMirrored ||
        self.imageOrientation == UIImageOrientationRight ||
        self.imageOrientation == UIImageOrientationRightMirrored) {
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
    } else {
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage * img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end



