//
//  AppDelegate+VOIP.m
//  minlePay
//
//  Created by JP on 2017/10/14.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "AppDelegate+VOIP.h"

@implementation AppDelegate (VOIP)

- (void)voipSetup
{
    VETVoipConfig *config = [VETVoipConfig new];
    config.logLevel = 5;
    config.consoleLogLevel = 4;
    config.enableEncrypt = YES;
    config.volumeScale = 3.0;
    [[VETVoipManager sharedManager] setupConfig:config];
    [[VETVoipManager sharedManager] start];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voipManagerDidStart) name:VETVoipManagerDidFinishStartingNotification object:nil];
}

/*
 * 默认开启PCMU，PCMA
 */
- (void)setupCodec
{
    NSArray *gsCodecArray = [[VETVoipManager sharedManager] queryCodec];
    NSMutableArray *codecArray = [NSMutableArray array];
    for (VETVoipCodecInfo *remoteCodec in gsCodecArray) {
        VETCodecInfo *localCodec = [[VETCodecInfo alloc] initWithCodecId:remoteCodec.codecId priority:remoteCodec.priority];
        if ([localCodec.codecId isEqualToString:@"PCMU/8000/1"]) {
            [[VETVoipManager sharedManager] updatePriorityWithCodecId:localCodec.codecId priority:124];
            localCodec.priority = [NSNumber numberWithInt:124];
            [codecArray addObject:localCodec];
        }
        else if ([localCodec.codecId isEqualToString:@"PCMA/8000/1"]) {
            [[VETVoipManager sharedManager] updatePriorityWithCodecId:localCodec.codecId priority:123];
            localCodec.priority = [NSNumber numberWithInt:123];
            [codecArray addObject:localCodec];
        }
        else {
            [[VETVoipManager sharedManager] updatePriorityWithCodecId:localCodec.codecId priority:0];
            localCodec.priority = [NSNumber numberWithInt:0];
            [codecArray addObject:localCodec];
        }
    }
    [[VETUserManager sharedInstance] insertOrUpdateCodecArray:[codecArray copy]];
}

- (void)voipManagerDidStart
{
    if ([[VETUserManager sharedInstance] loginStatus]) {
        // 登录设置为自动登录的帐户
        NSArray *accountArray = [[DBUtil sharedManager] queryAccount];
        for (VETAccount *account in accountArray) {
            if (account.isAutoLogin) {
                //                [[VETVoipManager sharedManager] setTransportPort:[[VETUserManager sharedInstance] transport]];
                VETAccountEncryptionType encryptType = [[VETUserManager sharedInstance] encryptStatus] ? VETAccountEncryptionTypeRC4 : VETAccountEncryptionTypeNone;
                
                VETVoipAccount *voipAccount = [[VETVoipAccount alloc] initWithFullName:account.displayName
                                                                              username:account.username
                                                                              password:account.password
                                                                                domain:SERVER_ADDRESS
                                                                                 realm:@"*" encryptionType:encryptType
                                                     transportType:(VETAccountTransportType)account.transportType
                                                                        encryptionPort:SERVER_ENCRYPTION_PORT];
                if (!voipAccount.isRegistered) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[VETVoipManager sharedManager] addAccount:voipAccount];
                    });
                }
            }
        }
    }
    
    // 第一次登录默认开启PCMU，PCMA
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [self setupCodec];
    }
    // 后面登录读取配置文件设置
    else {
        NSArray *codecArr = [[VETUserManager sharedInstance] queryCodec];
        for (VETCodecInfo *codecInfo in codecArr) {
            BOOL status = [[VETVoipManager sharedManager] updatePriorityWithCodecId:codecInfo.codecId priority:[codecInfo.priority integerValue]];
            if (!status) {
                LYLog(@"设置Codec失败，CodecId:%@, Priority:%@", codecInfo.codecId, codecInfo.priority);
            }
        }
    }
}

@end
