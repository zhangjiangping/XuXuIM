
//
//  MBProgressHUD+Alert.h
//  SunMall
//
//  Created by yunxuan on 15/11/10.
//  Copyright © 2015年 huangshupeng. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Alert)

+ (MBProgressHUD *)shareInstance;//正方形
+ (MBProgressHUD *)shareManager;//长方形
- (void) ShowMessage :(NSString *)msg showView:(UIView *)view;
- (MBProgressHUD *) showLoding :(NSString *)msg showView:(UIView *)view;

@end
