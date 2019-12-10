//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

@implementation WXApiRequestHandler

//登录
+ (void)wechatLoginInViewController:(UIViewController *)viewController
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = WX_AuthScope;
    req.state = WX_AuthState;
    [WXApi sendReq:req];
//    if ([WXApi isWXAppInstalled]) {
//        SendAuthReq *req = [[SendAuthReq alloc] init];
//        req.scope = WX_AuthScope;
//        req.state = WX_AuthState;
//        [WXApi sendReq:req];
//    } else {
//        //设置弹出提示语
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Ture"] style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:actionConfirm];
//        [viewController presentViewController:alert animated:YES completion:nil];
//    }
}


+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; 
    req.state = state;
    req.openID = openID;
    
    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:[WXApiManager sharedManager]];
}


@end
