//
//  AppDelegate+VOIP.h
//  minlePay
//
//  Created by JP on 2017/10/14.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
#import "VETVoip.h"
#import <CallKit/CallKit.h>
#import "DBUtil.h"
#import "VETAccount.h"
#import "VETSearchAreaCodeManager.h"
#import <UserNotifications/UserNotifications.h>
#import <PushKit/PushKit.h>
#import "VETProviderDelegate.h"
#import "VETCallKitManager.h"
#import "NSNotificationCenter+LYXExtension.h"
#import "VETCodecInfo.h"
#import <Bugly/Bugly.h>
#import "LYCFunctionTool.h"

@interface AppDelegate (VOIP)

- (void)voipSetup;

@end
