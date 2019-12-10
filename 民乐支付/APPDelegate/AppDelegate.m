//
//  AppDelegate.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "AppDelegate.h"
#import "MLHomeViewController.h"
#import "BaseNavigationController.h"
#import "MLLandingViewController.h"
#import "AppDelegate+JPush.h"
#import "GuideView.h"
#import "WXApiManager.h"
#import "AppDelegate+VOIP.h"

static NSString *WXApiRegisterID = @"wx917c01cfa9a0c853";

@interface AppDelegate ()
@property (nonatomic, strong) GuideView *guideView;//引导页视图
@end

@implementation AppDelegate

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置启动页显示时间
    [NSThread sleepForTimeInterval:1.5];
    //设置极光推送
    [self setUpJiGuang:launchOptions];
    //初始化全局变量
    self.netWorking = [MCNetWorking sharedInstance];
    self.commenUtil = [[CommenUtil alloc] init];
    //跳转根视图控制器
    [self pushVc];
    //注册微信
    [self registerWeiXin];
    //设置VOIP
    [self voipSetup];
    //添加引导页
    [self isAddGuideView];
    //设置Bugly
    [Bugly startWithAppId:@"af876b6909"];
    //设置默认账户信息
    [self setupDefaultAccount];
    return YES;
}

//设置默认账户
- (void)setupDefaultAccount
{
    self.currentCountry = [VETUserManager sharedInstance].country;
    if (self.currentCountry) {
        NSLog(@"当前账户：国家名字->%@,国家区号->%@",self.currentCountry.countryChineseName,self.currentCountry.code);
    } else {
        self.currentCountry = [[VETCountry alloc] init];
        self.currentCountry.code = @"86";
        self.currentCountry.icon = @"CN";
        self.currentCountry.countryChineseName = @"中国";
        self.currentCountry.countryEnglishName = @"China";
        self.currentCountry.shouzimu = @"ZG";
        self.currentCountry.searchText = @"86China";
        self.currentCountry.pinyin = @"ZHONG GUO";
        [[VETUserManager sharedInstance] settingCountry:self.currentCountry];
        
        [[VETSearchAreaCodeManager sharedInstance] searchAreaCode:@"86" completion:^(VETAreaCode *china) {
            NSLog(@"-----%@",china.code);
        }];
    }
}

//注册微信
- (void)registerWeiXin
{
    //向微信注册
    [WXApi registerApp:WXApiRegisterID enableMTA:YES];
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
}

//跳转跟视图控制器
- (void)pushVc
{
    self.isLandingFailure = NO;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        //第一次进入app
        [self pushRootViewController:[[MLLandingViewController alloc] init]];
    } else {
        if ([self.commenUtil loginIsTimeoutFailure]) {
            //已经登录超时失效
            self.isLandingFailure = YES;
            [self pushRootViewController:[[MLLandingViewController alloc] init]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        } else {
            //未登录失效
            [self pushRootViewController:[[MLHomeViewController alloc] init]];
        }
    }
}

//公用
- (void)pushRootViewController:(UIViewController *)vc
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
}

//设置根视图控制器
- (void)setupRootViewController:(UIViewController *)vc
{
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [[[UIApplication sharedApplication] delegate] window].rootViewController = nav;
}

//判断是否用添加引导页
- (void)isAddGuideView
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:HistoryVersion]) {
        //添加引导页
        [self addGuideView];
    } else {
        NSString *versionStr = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryVersion];
        if (![versionStr isEqualToString:minlePay_Version]) {
            //添加引导页
            [self addGuideView];
        }
    }
}

//添加引导页视图
- (void)addGuideView
{
    NSArray *imageNames = @[@"Guide01",@"Guide02"];
    GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) withImageNames:imageNames];
    self.guideView = guideView;
    [guideView show];
    
    //获取最新版本保存本地
    [[NSUserDefaults standardUserDefaults] setObject:minlePay_Version forKey:HistoryVersion];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

//记录用户没使用app后的初始时间,每次退出重新记录
- (void)recoderHistoryLogoutAppTime
{
    NSString *exitTimeStr = [self.commenUtil getCurrentDateStr];
    [[NSUserDefaults standardUserDefaults] setObject:exitTimeStr forKey:HistoryLoginTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//app进入后台挂起状态
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"进入后台前挂起状态");
    [self recoderHistoryLogoutAppTime];
}

//app完全退出后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"app完全退出后台");
    
    [self recoderHistoryLogoutAppTime];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self.guideView removeFromSuperview];
}

//进入app前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    self.isLandingFailure = NO;
    
    if ([self.commenUtil loginIsTimeoutFailure]) {
        //已经登录超时失效
        [self setupRootViewController:[[MLLandingViewController alloc] init]];
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
            //不做处理
        } else {
            self.isLandingFailure = YES;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[VETVoipManager sharedManager] hangUpAllCalls];
    NSArray *accoutsArr = [[VETVoipManager sharedManager] accounts];
    for (VETVoipAccount *account in accoutsArr) {
        [account setRegistered:NO];
    }
}


@end
