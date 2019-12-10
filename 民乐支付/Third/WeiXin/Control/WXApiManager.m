//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

#define WX_BASE_URL @"https://api.weixin.qq.com/sns"

@implementation WXApiManager

#pragma mark - LifeCycle

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

//通过code获取授权登录回调的openID
- (void)getOpenID:(SendAuthResp *)temp
{
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WXApp_ID, WXApp_Secret, temp.code];
    [SharedApp.netWorking createGetWithUrlString:accessUrlStr withParameter:nil withComplection:^(NSDictionary *responseObject) {
        NSLog(@"请求access的response = %@", responseObject);
        NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *accessToken = [accessDict objectForKey:WX_ACCESS_TOKEN];
        NSString *openID = [accessDict objectForKey:WX_OPEN_ID];
        if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) { [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
            if (_delegate && [_delegate respondsToSelector:@selector(managerDidReciveOpenID:withIsSuccess:)]) {
                [_delegate managerDidReciveOpenID:openID withIsSuccess:YES];
            }
            //[self wechatLoginByRequestForUserInfoWithAccessToken:accessToken withOpenID:openID];
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(managerDidReciveOpenID:withIsSuccess:)]) {
                [_delegate managerDidReciveOpenID:nil withIsSuccess:NO];
            }
        }
    } withFailure:^(NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidReciveOpenID:withIsSuccess:)]) {
            [_delegate managerDidReciveOpenID:nil withIsSuccess:NO];
        }
        NSLog(@"获取access_token时出错 = %@", error);
    }];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate &&
            [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    }
}

- (void)onReq:(BaseReq *)req
{
    //
}

// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfoWithAccessToken:(NSString *)accessToken withOpenID:(NSString *)openID
{
    // 请求用户数据
    if (!accessToken) {
        accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    }
    if (!openID) {
        openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    }
    NSString *userUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, accessToken, openID];
    [SharedApp.netWorking createGetWithUrlString:userUrlStr withParameter:nil withComplection:^(NSDictionary *responseObject) {
        if (responseObject && responseObject.allKeys.count > 0) {
            if (_delegate &&
                [_delegate respondsToSelector:@selector(managerDidReciveInfo:withIsSuccess:)]) {
                [_delegate managerDidReciveInfo:responseObject withIsSuccess:YES];
            }
        }
        NSLog(@"请求用户信息的response = %@", responseObject);
    } withFailure:^(NSError *error) {
        NSLog(@"获取用户信息时出错 = %@", error);
        if (_delegate &&
            [_delegate respondsToSelector:@selector(managerDidReciveInfo:withIsSuccess:)]) {
            [_delegate managerDidReciveInfo:nil withIsSuccess:NO];
        }
    }];
}

@end
