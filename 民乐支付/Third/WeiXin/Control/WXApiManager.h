//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

//注册时得到的AppID和AppSecret
#define WXApp_ID @"wx917c01cfa9a0c853"
#define WXApp_Secret @"8ed728bcd46d06c68950f2c7d88abb65"

//请求授权认证用到的参数
#define WX_AuthScope @"snsapi_userinfo"
#define WX_AuthState @"WX_AuthState"

@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidReciveOpenID:(NSString *)openId withIsSuccess:(BOOL)isSuccess;

- (void)managerDidReciveInfo:(NSDictionary *)dic withIsSuccess:(BOOL)isSuccess;

@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

- (void)getOpenID:(SendAuthResp *)temp;

// 获取用户个人信息
- (void)wechatLoginByRequestForUserInfoWithAccessToken:(NSString *)accessToken withOpenID:(NSString *)openID;

@end
