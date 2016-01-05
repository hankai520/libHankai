//
//  HKVars.h
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

/*
    常用的目录
 */

//程序的 Document 目录。该目录默认会被 iCloud 同步至云端。
#define AppDocumentDirectory    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//程序的 Library 目录，一般在 mac 应用下可能用到。
#define AppLibraryDirectory     [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]

//程序的 Caches 目录，常用于存储程序缓存或可以重新生成的资源。
#define AppCachesDirectory      [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

//程序的 Temp 目录。
#define AppTempDirectory        NSTemporaryDirectory()

//用于存储程序的首选项
#define AppPreferenceDirectory  [AppLibraryDirectory stringByAppendingPathComponent:@"Preferences"]

//用于存储cookies
#define AppCookieDirectory      [AppLibraryDirectory stringByAppendingPathComponent:@"Cookies"]


/*
    程序包元数据
 */

//程序主 Bundle 名称
#define MainBundleName          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

//程序的开发语言。该语言作为程序本地化的候补语言，当设备语言不在本地化语言列表中时，会使用该候补语言
#define DevelopmentRegion       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDevelopmentRegion"]

// 程序 Bundle 信息
//原文：
//https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-111349

//参照 CFBundleShortVersionString 一节
//Release version number 程序的发布（迭代）版本号，一般为点分十进制格式，例如：v1.2.2 #6689，则 1.2.2 为 CFBundleShortVersionString
//该字段支持本地化
#define BundleShortVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//Build version number, 即迭代版本号（每次构建程序，该版本号即改变），例如：v1.2.2 #6689，则 6689 为 CFBundleVersion，即构建/迭代版本号
//该字段不可本地化。
#define BundleVersion           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//设备的首选语言
#define SystemLanguage          [[NSLocale preferredLanguages] objectAtIndex:0]

/*
    URL 模板
 */

//程序在 iTunes 中的详细信息页面 URL
#define AppDetailsUrlTemplate(appId)    [NSString stringWithFormat:@"itms://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8", #appId]

//程序在 iTunes 中的评论页面 URL
#define AppReviewsUrlTemplate(appId)    [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", #appId]

/*
    常用设备参数
 */

//操作系统
#define SystemName              ([[UIDevice currentDevice] systemName])
#define SystemVersion           ([[UIDevice currentDevice] systemVersion])

#define SystemEqualTo(v)\
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SystemGreaterThan(v)\
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SystemGreaterThanOrEqualTo(v)\
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SystemLessThan(v)\
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SystemLessThanOrEqualTo(v)\
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//厂商唯一标识符
#define IDFV                    ([[[UIDevice currentDevice] identifierForVendor] UUIDString])


