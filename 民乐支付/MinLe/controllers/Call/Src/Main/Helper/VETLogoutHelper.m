//
//  VETLogoutHelper.m
//  MobileVoip
//
//  Created by Liu Yang on 08/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETLogoutHelper.h"
#import "AppDelegate.h"
#import "DBUtil.h"

@implementation VETLogoutHelper

+ (void)logoutAccount
{
    [[DBUtil sharedManager] deleteAccount:[[VETUserManager sharedInstance] currentUsername]];
    [[VETUserManager sharedInstance] setLoginStatus:NO];
    [[VETUserManager sharedInstance] setCurrentPassword:@""];
    [[VETUserManager sharedInstance] setCurrentUsername:@""];
}

@end
