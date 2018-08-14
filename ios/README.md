libHankai
=========

 

libHankai是一个封装了一些常用功能、算法的 iOS 静态库。

 

框架结构
--------

| **Target**  | **模块**      | **说明**                                 |
|-------------|---------------|------------------------------------------|
| Hankai      |               |                                          |
|             | Hankai.h      | 框架主要头文件。支持 \@import 模块化引入 |
|             | HKVars.h      | 封装一些系统常量和便利的宏               |
|             | GUI           | 自定义的GUI控件                          |
|             | File System   | 文件系统相关                             |
|             | Audio Process | 音频处理                                 |
|             | Algorithms    | 算法                                     |
|             | Image Process | 图像处理                                 |
|             | Network       | 网络通信                                 |
|             | LangExt       | OC语言扩展                               |
| HankaiTests |               | 单元测试                                 |
| iOSDemo     |               | 关于主要功能的demo                       |
|             |               |                                          |

 

如何接入
--------

-   下载框架源码，放到你工程根目录下的 lib 目录

-   在 Xcode 中 打开你的工程

-   在 Finder 中，将 Hankai.xcodeproj 文件拖拽至你的工程的 Frameworks 组

-   在你的工程中，选中要连接框架的 target，切换到 Build Phases 标签

-   在 Target Dependencies 中添加对框架 Hankai 这个 Target的依赖

-   在 Link Binary With Libraries 中添加对 Hankai.framework 的链接

-   在你工程的 target 的 Build Settings 中，为 Other Linker Flags 添加 -ObjC
    选项

-   在你工程的 target 的 Build Settings 中，确保 Enable Modules (C and
    Objective-C) 选项值是 YES

-   在你工程的 target 的 Build Settings 中，确保 Allow Non-modular Includes In
    Framework Modules 选项值是 YES

-   在你工程的 AppDelegate.m 文件顶部添加 \@import Hankai;

-   在你工程的 AppDelegate.m 文件 **didFinishLaunchingWithOptions
    **函数实现中，添加一行代码

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NSLog(@"%@", isEmptyString(@"") ? @"yes" : @"no”);  
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-   编译并运行你工程的 target

 

主要功能介绍
------------

 

### 常用加/解密，编码算法

因为部分算法使用了iOS提供的加密算法库，而该库是以iOS系统库，而不是模块化的框架提供的，因此一些头文件

并没有使用原始的数据类型，而是使用了兼容的类型，例如AES加密中使用的 keySize
枚举和 CCOperation 枚举。

 

#### MD5

**获取文件MD5:**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * md5 = [HKMD5Helper md5OfContentsOfFile:@"file path here"]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**计算字符串MD5：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * md5 = [HKMD5Helper md5OfNSString:@“some strings” 
                               withEncoding:NSUTF8StringEncoding];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**计算字节数据的MD5：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * md5 = [HKMD5Helper md5OfNSData:dataObjectHere]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

#### AES

**加密：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSData * encryptedData = [HKAESHelper cryptData:rawData 
                                        withKey:@“key string here” 
                                        keySize:kCCKeySizeAES128
                                      operation:kCCEncrypt];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**解密：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSData * rawData = [HKAESHelper cryptData:encryptedData 
                                  withKey:@“key string here” 
                                  keySize:kCCKeySizeAES128
                                operation:kCCEncrypt];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

#### Base64

**编码：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * encodedString = [HKBase64 encode:dataObjHere];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**解码：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * decodedString = [HKBase64 decode:stringObjHere];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### 图像滤镜

图像滤镜类为插件式结构，允许注册或移除滤镜组件。

HKFilterManager 为滤镜组件管理器，通过 registerFilter: 和 removeFilter:
来管理滤镜组件。

HKFilterComponent 为滤镜组件接口。

 

**实现自定义滤镜组件：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@interface CustomImageFilter : NSObject <HKFilterComponent> {

}
@end

@implementation CustomImageFilter

- (UIImage *)filterImage:(UIImage *)srcImage {
    //滤镜实现逻辑
}

- (NSArray *)supportedFilters { 
    //该组件支持的滤镜效果名称，建议通过命名空间方式来避免重名，例如：custom.xxx
}

- (BOOL)canProcessImageWithFilterNamed:(NSString *)name {
    //判断组件是否可以处理特定的滤镜效果
}

@end
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**注册/移除自定义滤镜组件：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CustomImageFilter * filter = [CustomImageFilter new];

//注册
[HKFilterManager registerFilter:filter];

//移除
[HKFilterManager removeFilter:filter];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**使用滤镜：**

滤镜特效往往以列表形式供用户选择，因此可以结合滤镜特效名称进行本地化。

 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//在表格或 collectionView 或任意形式选项列表中将 filterNames 用作数据源
NSArray * filterNames = [HKFilterManager availableFilterNames];

//在用户选择某个滤镜后，应用该滤镜
UIImage * processedImage = [HKFilterManager processImage:rawImage
                                         withFilterNamed:@"filterName"];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### HTTP通信

大多数iOS应用都需要与服务端进行HTTP通信，考虑目前比较流行的 JSON + Web Service
架构，提供了常用的HTTP操作。

核心类为 HKHttpRequest，该类内部使用了NSURLSessionTask 来实现具体操作。

 

**GET：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * url = @"http://www.baidu.com";
NSDictionary * params = @{
    @"keyword" : @"java"
};

httpGet(url, params, ^(NSError *err, HKHttpRequest * originalRequest) {
    if (err == nil) {
        NSData * data = originalRequest.responseData;
        //process response data, maybe convert it to json
    } else {
        //handle error here
    }
});
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**POST Form**：

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * url = @"http://www.baidu.com";
NSDictionary * params = @{
    @"keyword" : @"java"
};

httpPostForm(url, params, ^(NSError *err, HKHttpRequest * originalRequest) {
    if (err == nil) {
        NSData * data = originalRequest.responseData;
        //process response data, maybe convert it to json
    } else {
        //handle error here
    }
});
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**POST Json：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * url = @"http://www.baidu.com";
NSString * json = @“{\”name\”: \”hankai\"}”;
httpPostJson(url, json, ^(NSError *err, HKHttpRequest * originalRequest) {
    if (err == nil) {
        NSData * data = originalRequest.responseData;
        //process response data, maybe convert it to json
    } else {
        //handle error here
    }
});
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**POST Files：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * url = @"http://www.baidu.com";
NSArray * paths = @[ @"/usr/local/test.txt", @"/usr/local/test2.jpg" ];
httpPostFiles(url, paths, ^(NSError *err, HKHttpRequest * originalRequest) {
    if (err == nil) {
        NSData * data = originalRequest.responseData;
        //process response data, maybe convert it to json
    } else {
        //handle error here
    }
});
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**POST Multiparts：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * url = @"http://www.baidu.com";

HKRequestPart * jsonPart = [HKRequestPart new];
jsonPart.name = @"userInfo";
jsonPart.contentType = @"application/json";
jsonPart.data = [@"{\"name\":\"hankai\"}" dataUsingEncoding:NSUTF8StringEncoding];

HKRequestPart * filePart = [HKRequestPart new];
filePart.name = @"avatar";
filePart.contentType = @"image/jpeg";
filePart.data = ...;
filePart.isFile = YES;
filePart.fileName = @"avatar.jpg";

httpPostMultiparts(url, @[jsonPart, filePart], ^(NSError *err, HKHttpRequest * originalRequest) {
    if (err == nil) {
        NSData * data = originalRequest.responseData;
        //process response data, maybe convert it to json
    } else {
        //handle error here
    }
});
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

### HTTP下载

HTTP下载其实是HTTP通信的一部分，但由于其使用场景非常多，因此单独提出来，整合了缓存处理和分组/并发下载。

下载实现的核心组件为
HKDownloadCenter，该类也为插件式架构，下载的具体实现由下载器组件实现，下载器组件可以接入到下载中心组件，但仅能接入一个下载器。

 

注意：当多次调用下载时，下载中心内部会忽略URL重复的下载任务，但回调块仍会追加至回调列表，即：重复添加下载任务，HTTP请求不会执行多次，但下载完成后，每个重复添加的任务的回调块都会被执行。

 

**下载 HTTP 资源：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * url = @"http://d.hiphotos.baidu.com/image/pic/item/622762d0f703918f0bbb74d5563d269759eec443.jpg";

[[HKDownloadCenter defaultCenter] 
    downloadHTTPResourceAt:url
               cacheToDisk:YES
                whenFinish:^(NSError *error, BOOL fromCache, NSData *data) {
                    UIImage * img = [UIImage imageWithData:data];
                    //process the image
}];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**取消下载：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[[HKDownloadCenter defaultCenter] cancelDownloadProcessWithUrl:url];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

很多时候，我们对于下载的任务需要进行分组处理，比如，当前页面的所有下载任务为一组，在离开页面时，停止该组下载任务，而不是停止所有下载。此时，可以用
downloadHTTPResourceAt: 的重载版本进行分组，在需要取消下载时，使用

cancelDownloadProcessWithGroupId: 函数取消整组下载任务。

 

### 日期处理

提供诸如日期格式化，日期拆解，日期解析，日期生成，日期比较等常用功能。

 

**日期比较：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//是否是同一天（忽略时分秒）
BOOL isSame = [[NSDate date] isSameDay:anotherDate];

//只比较日期部分
NSComparisonResult result = [[NSDate date] compare:anotherDate mode:NSDatePart];
//只比较时间部分
NSComparisonResult result = [[NSDate date] compare:anotherDate mode:NSTimePart];
//比较日期和时间部分
NSComparisonResult result = [[NSDate date] compare:anotherDate mode:NSDatePart|NSTimePart];

//检查日期是否在一个范围内
BOOL in = [[NSDate date] betweensDate:startDate
                              andDate:endDate
                                 mode:NSDatePart
                                range:NSDateRangeClosed];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**日期生成：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//3天前
NSDate * date = [[NSDate date] dateByAddingDays:-3];

//5天后
NSDate * date = [[NSDate date] dateByAddingDays:5];

//获取范围内所有日期
NSArray * dates = [NSDate datesBetweenDate:startDate
                                   andDate:endDate
                                     range:NSDateRangeClosed];

//用日期信息块构造日期
NSDateInfo info;
info.year = 2016;
info.month = 1;
info.day = 20;
info.hour = 23;
info.minute = 59;
info.second = 59;
NSDate * date = [NSDate dateFromDateInfo:info];

//从字符串构造
NSDate * date = [NSDate dateFromNSString:@"2016-01-20 23:59:59"
                              withFormat:@"yyyy-MM-dd HH:mm:ss"];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

**日期格式化：**

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NSString * dateString = [[NSDate date] toNSString:@"yyyy-MM-dd HH:mm:ss"];
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 

 

### 语言扩展

该模块主要以类别形式提供OC语言扩展功能。大多数主要功能都依赖于语言扩展功能。具体提供了那些扩展功能，请参阅头文件注释。
