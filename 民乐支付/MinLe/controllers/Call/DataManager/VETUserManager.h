//
//  VETUserManager.h
//  VETEphone
//
//  Created by young on 17/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VETCodecInfo;
@class VETCountry;

@interface VETUserManager : NSObject

+ (VETUserManager *)sharedInstance;

- (void)setLoginStatus:(BOOL)isLoginStatus;
- (BOOL)loginStatus;

- (void)setEncryptStatus:(BOOL)status;
- (BOOL)encryptStatus;

- (void)setTransportPort:(NSUInteger)port;
- (NSUInteger)transport;

- (NSString *)mainUsername;
- (void)setMainUsername:(NSString *)mainUsername;
- (void)removeMainUsername;

- (NSString *)currentUsername;
- (void)setCurrentUsername:(NSString *)current;
- (void)removeCurrentUsername;

- (NSString *)currentPassword;
- (void)setCurrentPassword:(NSString *)currentPassword;
- (void)removeCurrentPassword;

- (NSString *)mainPassword;
- (void)setMainPassword:(NSString *)mainPassword;
- (void)removeMainPassword;

- (NSString *)balance;
- (void)setBalance:(NSString *)balance;

- (NSArray *)queryCodec;
- (void)insertOrUpdateCodecArray:(NSArray *)array;
- (void)setCodecInfo:(VETCodecInfo *)codecInfo priority:(NSUInteger)priority;

- (void)settingCountry:(VETCountry *)country;
- (VETCountry *)country;
- (void)removeCountry;

@end

