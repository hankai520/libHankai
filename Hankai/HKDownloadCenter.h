//
//  HKDownloadCenter.h
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

/*
    默认下载器实现，可根据需要进行继承扩展。
 */

@protocol HKDownloader <NSObject>

- (NSData *)downloadResourceAt:(NSURL *)url error:(NSError **)error;

@end


/**
 * 默认下载器，用iOS的API实现
 */
@interface HKDefaultDownloader : NSObject <HKDownloader>

@end


//下载完毕的回调原型
typedef void (^HttpResourceDownloadDidFinish)(NSError * error, BOOL fromCache, NSData * data);


/**
 *  下载任务处理中心
 */
@interface HKDownloadCenter : NSObject

@property (nonatomic, assign) BOOL              loggingEnabled; //是否启用日志

@property (nonatomic, assign) NSTimeInterval    cacheExpiry;//缓存的图片多久后过期（单位为秒），默认为3天

+ (HKDownloadCenter *)defaultCenter;

/**
 *  切换下载器
 *
 *  @param downloader 下载器组件
 */
- (void)useDownloader:(id<HKDownloader>)downloader;

/**
 *  下载位于指定url的网络资源
 *
 *  @param url        资源地址
 *  @param whenFinish 下载完毕后的回调
 *
 *  @return 新的下载任务是否正常开始了（已经在下载中的任务，将会返回NO，避免重复下载）
 */
- (BOOL)downloadHTTPResourceAt:(NSString *)url
                    whenFinish:(HttpResourceDownloadDidFinish)whenFinish;

/**
 *  下载位于指定url的网络资源
 *
 *  @param url         资源地址
 *  @param cacheToDisk 是否缓存到硬盘，如果启用缓存，则下次请求下载时如果发现已有缓存，则直接返回缓存
 *  @param whenFinish  下载完毕后的回调
 *
 *  @return 新的下载任务是否正常开始了（已经在下载中的任务，将会返回NO，避免重复下载）
 */
- (BOOL)downloadHTTPResourceAt:(NSString *)url
                   cacheToDisk:(BOOL)cacheToDisk
                    whenFinish:(HttpResourceDownloadDidFinish)whenFinish;

/**
 *  下载位于指定url的网络资源（重载），允许将下载任务分组
 *
 *  @param url         资源地址
 *  @param groupId     分组标识
 *  @param whenFinish  下载完毕后的回调
 *
 *  @return 新的下载任务是否正常开始了（已经在下载中的任务，将会返回NO，避免重复下载）
 */
- (BOOL)downloadHTTPResourceAt:(NSString *)url
                       groupId:(id)groupId
                    whenFinish:(HttpResourceDownloadDidFinish)whenFinish;

/**
 *  下载位于指定url的网络资源
 *
 *  @param url         资源地址
 *  @param groupId     分组标识
 *  @param cacheToDisk 是否缓存到硬盘，如果启用缓存，则下次请求下载时如果发现已有缓存，则直接返回缓存
 *  @param whenFinish  下载完毕后的回调
 *
 *  @return 新的下载任务是否正常开始了（已经在下载中的任务，将会返回NO，避免重复下载）
 */
- (BOOL)downloadHTTPResourceAt:(NSString *)url
                       groupId:(id)groupId
                   cacheToDisk:(BOOL)cacheToDisk
                    whenFinish:(HttpResourceDownloadDidFinish)whenFinish;

/**
 *  根据一个url来取消下载
 *
 *  @param url 资源地址
 */
- (void)cancelDownloadProcessWithUrl:(NSString *)url;

/**
 *  取消一个下载分组中得所有下载
 *
 *  @param groupID 分组标识
 */
- (void)cancelDownloadProcessWithGroupId:(id)groupId;

/**
 *  取消所有下载任务
 */
- (void)cancelAllProcesses;

/**
 *  判断某个资源是否正在下载
 *
 *  @param url 资源地址
 *
 *  @return 是否正在下载
 */
- (BOOL)isDownloadingAtUrl:(NSString *)url;

//判断下载分组是否存在
- (BOOL)isGroupExists:(id)groupID;

//清空所有缓存的下载资源
- (BOOL)cleanCaches;

//根据一个url去寻找本地缓存，如果缓存存在，则返回缓存文件本地路径
- (NSString *)cachePathForUrl:(NSString *)url;

//更新某个资源对应的本地缓存
- (BOOL)updateCacheForUrl:(NSString *)url withData:(NSData *)data;

@end





