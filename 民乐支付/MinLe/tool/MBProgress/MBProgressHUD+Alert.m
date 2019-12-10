//
//  MBProgressHUD+Alert.m
//  SunMall
//
//  Created by yunxuan on 15/11/10.
//  Copyright © 2015年 huangshupeng. All rights reserved.
//

#import "MBProgressHUD+Alert.h"
#import "AppDelegate.h"
static MBProgressHUD *theMBProgress = nil;
@implementation MBProgressHUD (Alert)


+ (MBProgressHUD *)shareInstance
{
    @synchronized(self){
        if(theMBProgress == nil){
            theMBProgress = [[self alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, 0, 200, 100)];
        }
    }
    return theMBProgress;
}

+ (MBProgressHUD *)shareManager
{
    @synchronized(self){
        if(theMBProgress == nil){
            theMBProgress = [[self alloc] initWithFrame:CGRectMake(50, 0, screenWidth-100, 30)];
        }
    }
    return theMBProgress;
}

- (void)ShowMessage :(NSString *)msg showView:(UIView *)view
{
    if (!view) {
        UIWindow *widow = [[UIApplication sharedApplication].delegate window];
        view = widow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];

}

- (MBProgressHUD *) showLoding :(NSString *)msg showView:(UIView *)view
{
    if (!view) {
        UIWindow *widow = [[UIApplication sharedApplication].delegate window];
        view = widow;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = msg;
    [view addSubview: hud];
    
    [hud show:YES];
    return hud;
}
@end
