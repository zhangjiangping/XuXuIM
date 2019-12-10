//
//  VETCallHelper.m
//  MobileVoip
//
//  Created by Liu Yang on 09/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCallHelper.h"
#import "VETVoipManager.h"
#import "LYAlertViewHelper.h"
#import "VETLogoutHelper.h"
#import "VETCountry.h"
#import "VETOutgoingCallingViewController.h"
#import "VETVoip.h"
#import "VETSearchAreaCodeManager.h"

@implementation VETCallHelper

+ (void)outgoingWithPhoneString:(NSString *)phoneString target:(id)target
{
    if (!([[VETVoipManager sharedManager] accounts].count > 0)) {
        [LYAlertViewHelper alertViewStrongWithTagert:target title:@"" content:[CommenUtil LocalizedString:@"Call.AccountDisconnecting"]
                                        confirmEvent:nil];
        return; 
    }
    if (!(phoneString.length > 0)) {
        [LYAlertViewHelper alertViewStrongWithTagert:target title:@"" content:[CommenUtil LocalizedString:@"Call.InvalidPhoneNumber"]
                                        confirmEvent:nil];
        return;
    }
    
    NSString *currentUsername = [[VETUserManager sharedInstance] currentUsername];
    
    VETVoipAccount *account = [[VETVoipManager sharedManager] accountWithUsername:currentUsername];
    if (!account) {
        LYLog(@"获取帐户信息失败.");
        [LYAlertViewHelper alertViewStrongWithTagert:target title:@"" content:[CommenUtil LocalizedString:@"Call.AccountNoLongerValid"] confirmEvent:^(UIAlertAction *action) {
            [VETLogoutHelper logoutAccount];
        }];
        return;
    }
    NSString *callString;
    
    // 去除空格，去除+
    NSString *deletePlusPhoneString = [phoneString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    // 8613112345678
    NSString *newPhoneString = [deletePlusPhoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 只有真实帐号才加00
    BOOL isVirtualAccount = NO;
    if (![[VETSearchAreaCodeManager sharedInstance] isSettedAreaCodeFlag]) {
        isVirtualAccount = YES;
    }
    
    if (isVirtualAccount) {
        NSLog(@"%@ isVirtualAccount", newPhoneString);
        callString = newPhoneString;
    }
    else {
        // 00+8613112345678
        callString = [NSString stringWithFormat:@"%@%@", SERVER_PREFIX, newPhoneString];
        NSLog(@"%@ not isVirtualAccount", newPhoneString);
    }
    LYLog(@"callString:%@", callString);
    // LY_TODO:重新组装一下VETSIPURI
    NSString *newHostCall = [NSString stringWithFormat:@"%@:%@", account.domain, [[VETUserManager sharedInstance] encryptStatus] ? @"5070" : @"5060"];
    VETSIPURI *sip = [[VETSIPURI alloc] initWithUser:callString host:newHostCall displayName:account.username];
    [account makeCallTo:sip completion:^(VETVoipCall *call) {
        // 拨打中显示的手机号
        VETOutgoingCallingViewController *callingVC = [VETOutgoingCallingViewController new];
        //callingVC.callPhone = isVirtualAccount ? callString : [NSString stringWithFormat:@"+%@",newPhoneString];
        callingVC.callPhone = callString;
        callingVC.call = call;
        [target presentViewController:callingVC animated:YES completion:nil];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:VETHistoryViewControllerRefreshHistoryNotification object:nil];
}

@end
