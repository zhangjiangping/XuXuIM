//
//  MLHomeViewController+Voip.m
//  minlePay
//
//  Created by JP on 2017/10/26.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLHomeViewController+Voip.h"
#import "VETIncomingCallViewController.h"
#import "MLLandingViewController.h"
#import "VETReconnectHelper.h"
#import "LYAlertViewHelper.h"
#import "VETGCDTimerHelper.h"
#import "VETAccount.h"
#import "DBUtil.h"

@implementation MLHomeViewController (Voip)

#pragma mark - account delegate

//接收来电
- (void)voipAccount:(VETVoipAccount *)account didReceiveCall:(VETVoipCall *)aCall
{
    VETIncomingCallViewController *incomingCallVC = [VETIncomingCallViewController new];
    incomingCallVC.call = aCall;
    [SharedApp.window.rootViewController presentViewController:incomingCallVC animated:YES completion:nil];
}

#pragma mark - 接受VOIP注册处理

- (void)voipAccountRegistrationDidChange:(NSNotification *)notification
{
    VETVoipAccount *account = (VETVoipAccount *)notification.object;
    // 未增加的帐户return
    if (account.accountId == kVETVoipManagerInvalidIdentifier) {
        return ;
    }
    self.status = account.accountStatus;
    if (account.accountStatus != VETAccountStatusInitial && account.accountStatus != VETAccountStatusConnected) {
        __weak typeof(self) weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf reconnect];
        });
        // 状态不正常时，1分钟后重连
//        __block NSInteger seconds = 10;
//        if (self.connectTimer) {
//            dispatch_source_cancel(self.connectTimer);
//        }
//        self.connectTimer = [VETGCDTimerHelper createGCDTimerWithInterval:1.0 leeway:1.0 queue:dispatch_get_main_queue() block:^{
//            __strong typeof(self) strongSelf = weakSelf;
//            if (strongSelf) {
//                seconds --;
//                LYLog(@"seconds:%ld", (long)seconds);
//                self.isReconectCancled = NO;
//                if (seconds <= 0) {
//                    seconds = 60.0;
//                    [strongSelf reconnect];
//                }
//            }
//        }];
//        if (self.isReconectCancled) {
//            self.isReconectCancled = NO;
//            dispatch_resume(self.connectTimer);
//        }
    } else if (account.accountStatus == VETAccountStatusConnected) {
        //登录成功
        if (self.isLoginSuccess) return;
        [account setDelegate:self];
        [self loginSuccess];
    } else {
        NSLog(@"--------%d",account.accountStatus);
    }
}

//登录
- (void)loginVoip
{
    VETAccountEncryptionType encryptType = [[VETUserManager sharedInstance] encryptStatus] ? VETAccountEncryptionTypeRC4 : VETAccountEncryptionTypeNone;
    NSString *voipUserName = [[NSUserDefaults standardUserDefaults] objectForKey:VOIP_USERNAME];
    NSString *voipPassword = [[NSUserDefaults standardUserDefaults] objectForKey:VOIP_PASSWORD];
    //NSLog(@"userName(8008623120810):%@, password(ML296636):%@", voipUserName, voipPassword);
    if (!voipUserName || !voipPassword) {
        self.status = VETAccountStatusInvalid;
        [LYAlertViewHelper alertViewStrongWithTagert:self title:[CommenUtil LocalizedString:@"Common.Prompt"] content:[CommenUtil LocalizedString:@"Home.AccountEmptyMsg"] confirmEvent:^(UIAlertAction *action) {
            [SharedApp setupRootViewController:[[MLLandingViewController alloc] init]];
        }];
        return;
    }
    //添加通知
    [self addNotification];
    self.currentVoipAccount = [[VETVoipAccount alloc] initWithFullName:voipUserName
                                                          username:voipUserName
                                                          password:voipPassword
                                                            domain:SERVER_ADDRESS
                                                             realm:@"*"
                                                    encryptionType:encryptType
                                                     transportType:VETAccountTransportTypeUDP
                                                    encryptionPort:SERVER_ENCRYPTION_PORT];
    [[VETUserManager sharedInstance] setCurrentUsername:voipUserName];
    [[VETUserManager sharedInstance] setCurrentPassword:voipPassword];
    if (!self.currentVoipAccount.isRegistered) {
        [[VETVoipManager sharedManager] addAccount:self.currentVoipAccount];
    }
}

//登录成功
- (void)loginSuccess
{
    self.isLoginSuccess = YES;
    VETEncryptionType encryptType = [[VETUserManager sharedInstance] encryptStatus] ? VETEncryptionTypeRC4 : VETEncryptionTypeNone;
    VETAccount *account = [VETAccount new];
    account.username = self.currentVoipAccount.username;
    account.password = self.currentVoipAccount.password;
    account.displayName = self.currentVoipAccount.username;
    account.domain = SERVER_ADDRESS;
    account.encryptionType = encryptType;
    account.transportType = VETAccountTransportTypeUDP;
    account.autoLogin = YES;
    [[DBUtil sharedManager] addAccount:account];
    
    [[VETUserManager sharedInstance] setLoginStatus:YES];
    [[VETUserManager sharedInstance] setCurrentUsername:self.currentVoipAccount.username];
    [[VETUserManager sharedInstance] setCurrentPassword:self.currentVoipAccount.password];
}

- (void)reconnect
{
    [VETReconnectHelper reconnectForce:NO];
    if (self.connectTimer) {
        dispatch_source_cancel(self.connectTimer);
    }
    self.isReconectCancled = YES;
}

- (void)homeDealloc
{
    if (self.connectTimer) {
        dispatch_source_cancel(self.connectTimer);
    }
    if (self.currentVoipAccount) {
        [[VETVoipManager sharedManager] removeAccount:self.currentVoipAccount];
        [[DBUtil sharedManager] deleteAccount:[[VETUserManager sharedInstance] currentUsername]];
        [self.currentVoipAccount setRegistered:NO];
        [[VETUserManager sharedInstance] setCurrentPassword:@""];
        [[VETUserManager sharedInstance] setCurrentUsername:@""];
    }
    [self removeNotification];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voipAccountRegistrationDidChange:) name:VETVoipManagerAccountRegisterStatusNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VETVoipManagerAccountRegisterStatusNotification object:nil];
}

@end
