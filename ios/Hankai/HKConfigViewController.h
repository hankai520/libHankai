//
//  HKConfigViewController.h
//  Hankai
//
//  Created by hankai on 14/03/2017.
//  Copyright © 2017 Hankai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 配置参数信息。
 */
@interface HKConfig : NSObject

/**
 服务器IP或域名。
 */
@property (nonatomic, strong) NSString *    remoteHost;

/**
 服务器端口。
 */
@property (nonatomic, strong) NSString *    remotePort;

/**
 保存配置信息。
 */
- (void)persist;

@end

/**
 应用配置控制器，用于设置需要的参数。
 */
@interface HKConfigViewController : UIViewController

/**
 将当前控制器附着到指定控制器（被指定的控制器响应特定手势，用于弹出配置控制器）。

 @param hostController 宿主控制器
 */
+ (void)attachToViewController:(UIViewController *)hostController;

/**
 获取当前配置的参数。

 @return 配置
 */
+ (HKConfig *)getConfiguration;

@end
