//
//  HKFilterManager.h
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

/**
 *  图像滤镜组件，可以实现后，向管理器注册新的滤镜组件
 */
@protocol HKFilterComponent <NSObject>

/**
 *  对图片应用滤镜
 *
 *  @param srcImage 原始图片
 *
 *  @return 滤镜后的图片
 */
- (UIImage *)filterImage:(UIImage *)srcImage;

/**
 *  返回组件支持的滤镜名称
 *
 *  @return 字符串数组
 */
- (NSArray *)supportedFilters;

/**
 *  判断当前组件是否可以处理特定的滤镜效果
 *
 *  @param name 滤镜效果名称
 *
 *  @return 是否可以滤镜
 */
- (BOOL)canProcessImageWithFilterNamed:(NSString *)name;

@optional

/**
 *  仅在一个滤镜组件支持多种滤镜的时候需要使用到，用以确定当前需要用何种滤镜效果（可选的）
 */
@property (nonatomic, strong) NSString *    filterName;

@end

/**
 *  图片滤镜管理器，在管理器初始化时，会自动注册内建的滤镜组件
 */
@interface HKFilterManager : NSObject {
    NSMutableArray *    _filters; //内置的滤镜组件集合
}

/**
 *  可用的滤镜效果名称
 *
 *  @return 字符串数组
 */
+ (NSArray *)availableFilterNames;

/**
 *  检查某个滤镜效果是否可用
 *
 *  @param name 滤镜效果名称
 *
 *  @return 是否可用
 */
+ (BOOL)isFilterAvailable:(NSString *)name;

/**
 *  注册新的滤镜组件
 *
 *  @param filter 滤镜组件
 */
+ (void)registerFilter:(id<HKFilterComponent>)filter;

/**
 *  移除已注册的滤镜组件
 *
 *  @param filter 滤镜组件
 */
+ (void)removeFilter:(id<HKFilterComponent>)filter;

/**
 *  对图片应用一种滤镜效果
 *
 *  @param srcImage   原始图片
 *  @param filterName 滤镜效果名称
 *
 *  @return 滤镜后的图片
 */
+ (UIImage *)processImage:(UIImage *)srcImage withFilterNamed:(NSString *)filterName;

@end
