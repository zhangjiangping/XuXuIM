//
//  AppDelegate.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETCountry.h"

#ifdef __cplusplus
#undef NO
#undef YES
#import <opencv2/opencv.hpp>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MCNetWorking *netWorking;

@property (strong, nonatomic) CommenUtil *commenUtil;

@property (assign, nonatomic) BOOL isLandingFailure;//是否登录失效

@property (nonatomic, strong) VETCountry *currentCountry;

//公用
- (void)pushRootViewController:(UIViewController *)vc;

//设置根视图控制器
- (void)setupRootViewController:(UIViewController *)vc;

//设置默认账户
- (void)setupDefaultAccount;

@end

