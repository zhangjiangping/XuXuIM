//
//  AppDelegate+JPush.m
//  民乐支付
//
//  Created by JP on 2017/6/6.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "AppDelegate+JPush.h"

@implementation AppDelegate (JPush)

//设置极光推送
- (void)setUpJiGuang:(NSDictionary *)launchOptions
{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (IOS_VERSION >= 10.0) {
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        NSSet <UNNotificationCategory *> *categories;
        entity.categories = categories;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        if (IOS_VERSION >= 8.0) {
            NSSet <UIUserNotificationCategory *> *categories;
            entity.categories = categories;
        } else {
            entity.categories = nil;
        }
    }
    //注册
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //配置
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    //获取用户唯一ID
    [self getRegisterIDWithIDBlock:^(NSString *registerID) {
        if (registerID) {
            NSLog(@"registrationID获取成功：%@",registerID);
            //保存registerID
            [[NSUserDefaults standardUserDefaults] setObject:registerID forKey:JPushRegisterID];
        } else {
            NSLog(@"registrationID获取失败");
        }
    }];
}

//获取注册ID
- (void)getRegisterIDWithIDBlock:(JRegisterIDBlock)registerIDBlock
{
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (resCode == 0) {
            if (registerIDBlock) {
                registerIDBlock(registrationID);
            }
        } else {
            if (registerIDBlock) {
                registerIDBlock(nil);
            }
        }
    }];
}

#pragma mark - 极光部分

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}
#endif

#pragma mark 接收推送的消息

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if (IOS_VERSION < 10.0 || application.applicationState> 0) {
        
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    // 系统要求执行这个方法
    completionHandler();
}
#endif


//获取服务器推送过来的消息格式转化
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic
{
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

//添加接受服务器自定义推送的通知
- (void)addJPushNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:)name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    /**
     *参数描述：
     content：获取推送的内容
     extras：获取用户自定义参数
     customizeField1：根据自定义key获取自定义的value
     */
    
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"];
//    NSInteger badge = [[[userInfo valueForKey:@"aps"] valueForKey:@"badge"]integerValue];
//    NSLog(@"%jiaobao--ld",(long)badge);
//    NSLog(@"custuserInfo:%@",userInfo);
//    NSLog(@"custcontent:%@",content);
//    NSLog(@"custextras:%@",extras);
//    NSLog(@"customizeField1:%@",customizeField1);
//    NSLog(@"cust获取注册ID:%@",    [JPUSHService registrationID]);
    
    //app收到服务器过来的推送，发送一个通知到app内部具体哪个接受此通知的控制器
    //NSDictionary *userInfo = [notification userInfo];
    //    ///服务端传递的Extras附加字段，key是自己定义的
    //    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    //[[NSNotificationCenter defaultCenter] postNotificationName:JPushDidReceiveMessage object:nil userInfo:userInfo];
}

@end
