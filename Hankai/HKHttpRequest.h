//
//  HKHttpRequest.h
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

/**
 *  HTTP 请求完成后的回调块
 *
 *  @param error        错误信息（不保证本地化）
 *  @param responseData 响应数据
 *  @param statusCode   响应的状态码
 */
typedef void (^HKHttpRequestDidFinished)(NSError * error, NSData * responseData, NSInteger statusCode, NSDictionary * responseHeaders);

/**
 *  Http 请求封装类
 */
@interface HKHttpRequest : NSObject

@property (nonatomic, strong, readonly) NSString *     url;

@property (nonatomic, strong, readonly) NSString *     method;

@property (nonatomic, strong, readonly) NSString *     queryString;//GET 和 POST 通用

@property (nonatomic, strong, readonly) NSData *       responseData;

/**
 *  设置请求完成后的回调代码块
 *
 *  @param aCompletionBlock 参照定义
 */
- (void)setCompletionBlock:(HKHttpRequestDidFinished)aCompletionBlock;

/**
 *  发起 GET 请求
 *
 *  @param url    请求地址
 *  @param params 参数字典
 *
 *  @return 生成的请求实例
 */
+ (HKHttpRequest *)get:(NSString *)url withParams:(NSDictionary *)params;

/**
 *  发起 POST 表单请求
 *
 *  @param url    请求地址
 *  @param params 参数字典
 *
 *  @return 生成的请求实例
 */
+ (HKHttpRequest *)post:(NSString *)url withParams:(NSDictionary *)params;

/**
 *  发起 POST 请求（重载版本）
 *
 *  @param url        请求地址
 *  @param dataString body内容
 *
 *  @return 生成的请求实例
 */
+ (HKHttpRequest *)post:(NSString *)url withData:(NSString *)dataString;

/**
 *  构建一个 HTTP 标准的查询字符串
 *
 *  @param params    参数字典
 *  @param urlEncode 是否对参数值进行 url 编码
 *  @param sortAsc   是否对参数列表按参数键名排序，YES 为升序，NO 为降序
 *
 *  @return 生成的请求实例
 */
+ (NSString *)buildQueryString:(NSDictionary *)params urlEncode:(BOOL)urlEncode sortAsc:(BOOL)sortAsc;

/**
 *  发送请求
 */
- (void)start;

@end

/**
 *  发送 HTTP GET 请求的便利方法
 *
 *  @param url      地址
 *  @param params   参数
 *  @param callback 回调代码块
 */
void httpGet(NSString * url, NSDictionary * params, HKHttpRequestDidFinished callback);

/**
 *  发送 HTTP POST 表单请求的便利方法
 *
 *  @param url      地址
 *  @param params   参数
 *  @param callback 回调代码块
 */
void httpPostForm(NSString * url, NSDictionary * params, HKHttpRequestDidFinished callback);

/**
 *  用 HTTP POST 方式发送 JSON 的便利方法
 *
 *  @param url      地址
 *  @param json     JSON 字串
 *  @param callback 回调代码块
 */
void httpPostJson(NSString * url, NSString * json, HKHttpRequestDidFinished callback);
