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

#import <Foundation/Foundation.h>

typedef enum {
    HKFileSizeUnitByte,     //byte
    HKFileSizeUnitKiloByte, //KB
    HKFileSizeUnitMegaByte, //MB
    HKFileSizeUnitGigaByte, //GB
    HKFileSizeUnitTeraByte  //TB
} HKFileSizeUnit;

/**
 *  文件系统工具类
 */
@interface HKFileSystem : NSObject

/**
 *  计算缓存文件的大小。如果path对应的是 AppCachesDirectory 下的一个子目录，则会计算该目录下所有缓存文件的大小之和。
 *  该函数不会递归的计算素有子目录中的文件大小
 *
 *  @param path 相对于 AppCachesDirectory 的文件路径
 *
 *  @return 文件大小
 */
+ (unsigned long long int)cacheItemSize:(NSString *)path;

/**
 *  清空所有缓存文件
 */
+ (void)cleanCaches;

@end


#define HKCacheSize         ([HKFileSystem cacheItemSize:AppCachesDirectory])