//
//  VETUserManager.m
//  VETEphone
//
//  Created by young on 17/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETUserManager.h"
#import "VETCodecInfo.h"
#import "VETCountry.h"

#define VET_UM_ISLOGIN @"VET_UM_IsLogin"
#define VET_UM_ISENCRYPT @"VET_UM_ISENCRYPT"
#define VET_UM_USERNAME @"VET_UM_USERNAME"
#define VET_UM_MAINUSERNAME @"VET_UM_MAINUSERNAME"
#define VET_UM_MAINPASSWORD @"VET_UM_MAINPASSWORD"
#define VET_UM_BALANCE @"VET_UM_BALANCE"
#define VET_UM_CODEC @"VET_UM_CODEC"
#define kVET_UM_Country @"kVET_UM_Country"
#define VET_UM_CURRENTUSERNAME @"VET_UM_CURRENTUSERNAME"
#define VET_UM_CURRENTPASSWORD @"VET_UM_CURRENTPASSWORD"
#define kVET_UM_TRANSPORT @"kVET_UM_TRANSPORT"

@implementation VETUserManager

+ (VETUserManager *)sharedInstance
{
    static VETUserManager *userManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[VETUserManager alloc] init];
    });
    return userManager;
}

- (void)setLoginStatus:(BOOL)isLoginStatus
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [NSNumber numberWithBool:isLoginStatus];
    [userDefault setObject:number forKey:VET_UM_ISLOGIN];
    [userDefault synchronize];
}

- (BOOL)loginStatus
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isLoginStatus = [[userDefault objectForKey:VET_UM_ISLOGIN] boolValue];
    return isLoginStatus;
}

- (void)setEncryptStatus:(BOOL)status
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [NSNumber numberWithBool:status];
    [userDefault setObject:number forKey:VET_UM_ISENCRYPT];
    [userDefault synchronize];
}

- (BOOL)encryptStatus
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL status = [[userDefault objectForKey:VET_UM_ISENCRYPT] boolValue];
    return status;
}

- (void)setTransportPort:(NSUInteger)port
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [NSNumber numberWithUnsignedInteger:port];
    [userDefault setObject:number forKey:kVET_UM_TRANSPORT];
    [userDefault synchronize];
}

- (NSUInteger)transport
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSUInteger port = [[userDefault objectForKey:kVET_UM_TRANSPORT] unsignedIntegerValue];
    return port;
}

- (NSString *)currentUsername
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefault objectForKey:VET_UM_CURRENTUSERNAME];
    return result;
}

- (void)setCurrentUsername:(NSString *)currentUsername
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:currentUsername forKey:VET_UM_CURRENTUSERNAME];
    [userDefault synchronize];
}

- (void)removeCurrentUsername
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:VET_UM_CURRENTUSERNAME];
}

- (NSString *)mainUsername
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefault objectForKey:VET_UM_MAINUSERNAME];
    return result;
}

- (void)setMainUsername:(NSString *)mainUsername
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:mainUsername forKey:VET_UM_MAINUSERNAME];
    [userDefault synchronize];
}

- (void)removeMainUsername
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:VET_UM_MAINUSERNAME];
}

- (NSString *)currentPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *result = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefault objectForKey:VET_UM_CURRENTPASSWORD]];
    return result;
}

- (void)setCurrentPassword:(NSString *)currentPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:currentPassword] forKey:VET_UM_CURRENTPASSWORD];
    [userDefault synchronize];
}

- (void)removeCurrentPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:VET_UM_CURRENTPASSWORD];
}

- (NSString *)mainPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefault objectForKey:VET_UM_MAINPASSWORD];
    return result;
}

- (void)setMainPassword:(NSString *)mainPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:mainPassword forKey:VET_UM_MAINPASSWORD];
    [userDefault synchronize];
}

- (void)removeMainPassword
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:VET_UM_MAINPASSWORD];
}

- (NSString *)balance
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *result = [userDefault objectForKey:VET_UM_BALANCE];
    return result;
}

- (void)setBalance:(NSString *)balance
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:balance forKey:VET_UM_BALANCE];
    [userDefault synchronize];
}

- (NSArray *)queryCodec
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id codecDic = [userDefault objectForKey:VET_UM_CODEC];
    NSDictionary *dic;
    if (codecDic) {
        dic = [NSKeyedUnarchiver unarchiveObjectWithData:codecDic];
        NSMutableArray *codecArray = [NSMutableArray array];
        for (NSString *key in dic.allKeys) {
            VETCodecInfo *codeInfo = [dic objectForKey:key];
            [codecArray addObject:codeInfo];
        }
        return [codecArray copy];
    }
    return nil;
}

- (void)insertOrUpdateCodecArray:(NSArray *)array
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id codecDic = [userDefault objectForKey:VET_UM_CODEC];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:codecDic];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    for (VETCodecInfo *codeInfo in array) {
        // 不存在加入缓存
//        if (![dic objectForKey:codeInfo.codecId]) {
        [mutableDic setObject:codeInfo forKey:codeInfo.codecId];
//        }
    }
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:[mutableDic copy]] forKey:VET_UM_CODEC];
    [userDefault synchronize];
}

- (void)setCodecInfo:(VETCodecInfo *)codecInfo priority:(NSUInteger)priority
{   
    codecInfo.priority = [NSNumber numberWithInteger:priority];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id object = [userDefault objectForKey:VET_UM_CODEC];
    NSDictionary *codecDic;
    if (object) {
        codecDic = [NSKeyedUnarchiver unarchiveObjectWithData:object];
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:codecDic];
        [mutableDic setObject:codecInfo forKey:codecInfo.codecId];
        [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:[mutableDic copy]] forKey:VET_UM_CODEC];
        [userDefault synchronize];
    }
}

- (void)settingCountry:(VETCountry *)country
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:country] forKey:kVET_UM_Country];
    [userDefault synchronize];
}

- (VETCountry *)country
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id object = [userDefault objectForKey:kVET_UM_Country];
    VETCountry *coutry;
    if (object) {
        coutry = (VETCountry *)[NSKeyedUnarchiver unarchiveObjectWithData:object];
        return coutry;
    }
    else {
        return nil;
    }
}

- (void)removeCountry
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:kVET_UM_Country];
}

@end
