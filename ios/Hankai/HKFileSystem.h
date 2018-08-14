//
//  HKFileSystem.h
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

@import Foundation;

typedef enum {
    HKFileSizeUnitByte          = 1, //byte
    HKFileSizeUnitKiloByte      = 2, //KB
    HKFileSizeUnitMegaByte      = 3, //MB
    HKFileSizeUnitGigaByte      = 4, //GB
    HKFileSizeUnitTeraByte      = 5  //TB
} HKFileSizeUnit;

/**
 *  文件系统工具类
 */
@interface HKFileSystem : NSObject

/**
 *  递归的计算目录大小
 *
 *  @param directoryUrl 目录路径
 *
 *  @return 目录大小（字节）
 */
+ (NSUInteger)getDirectoryFileSize:(NSURL *)directoryUrl;

/**
 *  递归的计算程序沙盒中缓存目录大小
 *
 *  @param unit 返回的文件大小单位（保留最多1位小数）
 *
 *  @return 目录大小
 */
+ (float)cacheSizeInUnit:(HKFileSizeUnit)unit;

/**
 *  递归的计算程序沙盒中缓存子目录大小
 *
 *  @param subDir 沙盒缓存目录下的子目录
 *  @param unit 返回的文件大小单位（保留最多1位小数）
 *
 *  @return 目录大小
 */
+ (float)cacheSizeForSubDir:(NSString *)subDir inUnit:(HKFileSizeUnit)unit;

/**
 *  将缓存目录大小转化为更有效的文字，例如：5.1 MB
 *
 *  @return 目录大小文本
 */
+ (NSString *)humanReadableCacheSize;

/**
 *  将文件大小转换为可读性更高的文本
 *
 *  @param size 文件大小
 *
 *  @return 文本
 */
+ (NSString *)humanReadableCacheSize:(float)size;

/**
 *  清空程序沙盒中的缓存目录
 */
+ (void)cleanCaches;

@end


#define HKCacheSize         ([HKFileSystem cacheItemSize:AppCachesDirectory])