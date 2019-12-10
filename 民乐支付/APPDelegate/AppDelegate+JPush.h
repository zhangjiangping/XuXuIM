//
//  AppDelegate+JPush.h
//  民乐支付
//
//  Created by JP on 2017/6/6.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "AppDelegate.h"

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//极光配置部分
static NSString *appKey = @"8c2aa35c6aab16f8adbce2fc";
static NSString *channel = @"";//Publish channel
static BOOL isProduction = FALSE;

//获取registerID回调
typedef void(^JRegisterIDBlock)(NSString *registerID);

@interface AppDelegate (JPush) <JPUSHRegisterDelegate>

/*
 获取注册ID
 */
- (void)getRegisterIDWithIDBlock:(JRegisterIDBlock)registerIDBlock;

/*
 配置极光推送
 */
- (void)setUpJiGuang:(NSDictionary *)launchOptions;

- (void)removeNotification;

- (void)addJPushNotification;

@end
