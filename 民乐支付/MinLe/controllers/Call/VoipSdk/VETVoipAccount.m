//
//  VETAccount.m
//  MobileVoip
//
//  Created by Liu Yang on 28/04/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETVoipAccount.h"
#import "VETSIPURI.h"
#import "VETVoipCall.h"
#import "VETVoipManager.h"
#import <pjsua-lib/pjsua.h>
#import "NSString+VETVoipExtension.h"
#import "VETVoipCallbacks.h"

@interface VETVoipCallParameters : NSObject

@property (nonatomic, readonly) VETSIPURI *destination;
@property (nonatomic, readonly) pjsua_acc_id accountId;
@property (nonatomic, readonly) void (^ _Nonnull completion)(BOOL, pjsua_acc_id);

- (instancetype)initWithDestination:(VETSIPURI *)destination
                            accountId:(pjsua_acc_id)account
                         completion:(void (^ _Nonnull)(BOOL, pjsua_call_id))completion;

@end

@implementation VETVoipCallParameters

- (instancetype)initWithDestination:(VETSIPURI *)destination accountId:(pjsua_acc_id)accountId completion:(void (^)(BOOL, pjsua_call_id))completion
{
    if (self = [super init]) {
        _destination = destination;
        _accountId = accountId;
        _completion = completion;
    }
    return self;
}

@end

const NSInteger kVETVoipAccountDefaultReregistrationTime = 1800; //3600

@interface VETVoipAccount ()

@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *username;
// TODO: 使用KeyChain
@property (nonatomic, retain) NSString *password;// 使用keychain
@property (nonatomic, retain) NSString *realm;

@property (nonatomic, copy) NSString *SIPAddress;

@property (nonatomic, copy) NSString *domain;

@property (nonatomic, assign) BOOL substitutesPlusCharacter;
@property (nonatomic, retain) NSString* plusCharacterSubstitution;

@property (nonatomic, assign) NSInteger accountId;

@property (nonatomic, retain) NSMutableArray *calls;

@end

@implementation VETVoipAccount

- (instancetype)initWithFullName:(NSString *)fullName username:(NSString *)username password:(NSString *)password domain:(NSString *)domain realm:(NSString *)realm encryptionType:(VETAccountEncryptionType)encryptionType transportType:(VETAccountTransportType)transportType encryptionPort:(NSString *)port
{
    self = [super init];
    if (self) {
        _calls = [NSMutableArray array];
        self.fullName = fullName;
        self.username = username;
        self.password = password;
        self.realm = realm;
        self.accountId = kVETVoipManagerInvalidIdentifier;
        self.reregistrationTime = kVETVoipAccountDefaultReregistrationTime;
        self.transportType = transportType;
        self.encryptionType = encryptionType;
        self.domain = domain;
        NSString *finalSIPAddress;
        if (self.encryptionType == VETAccountEncryptionTypeRC4) {
            finalSIPAddress = [NSString stringWithFormat:@"%@@%@:%@", username, domain, port];
        } else {
            finalSIPAddress = [NSString stringWithFormat:@"%@@%@", username, domain];
        }
        self.SIPAddress = finalSIPAddress;
    }
    return self;
//    VETVoipAccount *account = [[VETVoipAccount alloc] init];
//    account.fullName = fullName;
//    account.username = username;
//    account.password = password;
//    account.realm = realm;
//    account.accountId = kVETVoipManagerInvalidIdentifier;
//    account.reregistrationTime = kVETVoipAccountDefaultReregistrationTime;
//    account.transportType = transportType;
//    account.encryptionType = encryptionType;
//    account.domain = domain;
//    NSString *finalSIPAddress;
//    if (account.encryptionType == VETAccountEncryptionTypeRC4) {
//        finalSIPAddress = [NSString stringWithFormat:@"%@@%@:%@", username, domain, port];
//    }
//    else {
//        finalSIPAddress = [NSString stringWithFormat:@"%@@%@", username, domain];
//    }
//    account.SIPAddress = finalSIPAddress;
//    return account;
}

- (void)setDelegate:(id<VETVoipAccountDelegate>)delegate
{
    _delegate = delegate;
}

- (instancetype)init
{
    if (self = [super init]) {
        _calls = [NSMutableArray array];
    }
    return self;
}

- (void)updateUsername:(NSString *)username {
    _username = username;
}

- (void)updateAccountId:(NSInteger)accountId {
    _accountId = accountId;
}

- (void)setReregistrationTime:(NSUInteger)seconds {
    const NSInteger reregistrationTimeMin = 60;
    const NSInteger reregistrationTimeMax = 3600;
    if (seconds == 0) {
        _reregistrationTime = kVETVoipAccountDefaultReregistrationTime;
    } else if (seconds < reregistrationTimeMin) {
        _reregistrationTime = reregistrationTimeMin;
    } else if (seconds > reregistrationTimeMax) {
        _reregistrationTime = reregistrationTimeMax;
    } else {
        _reregistrationTime = seconds;
    }
}

- (BOOL)isRegistered {
    return ([self registrationStatus] / 100 == 2) && ([self registrationExpireTime] > 0);
}

- (NSInteger)registrationStatus {
    if ([self accountId] == kVETVoipManagerInvalidIdentifier) {
        return 0;
    }
    pjsua_acc_info accountInfo;
    pj_status_t status;
    
    status = pjsua_acc_get_info((pjsua_acc_id)[self accountId], &accountInfo);
    if (status != PJ_SUCCESS) {
        return 0;
    }
    return accountInfo.status;
}

- (void)setRegistered:(BOOL)value {
    if (self.accountId == kVETVoipManagerInvalidIdentifier) {
        return;
    }
    if (value) {
        pjsua_acc_set_registration((pjsua_acc_id)[self accountId], PJ_TRUE);
        [self setOnline:YES];
    } else {
        [self setOnline:NO];
        pjsua_acc_set_registration((pjsua_acc_id)[self accountId], PJ_FALSE);
    }
}

- (VETAccountStatus)accountStatus
{
    if (self.accountId == kVETVoipManagerInvalidIdentifier) {
        return VETAccountStatusDisconnecting;
    }
    pjsua_acc_info accountInfo;
    pj_status_t status;
    status = pjsua_acc_get_info((pjsua_acc_id)self.accountId, &accountInfo);
    if (status != PJ_SUCCESS) {
        return VETAccountStatusDisconnecting;
    }
    else {
        pjsip_status_code statusCode = accountInfo.status;
        if (statusCode == 0 || (accountInfo.online_status == PJ_FALSE)) {
            return VETAccountStatusOffline;
        }
        else if (PJSIP_IS_STATUS_IN_CLASS(statusCode, 100) || PJSIP_IS_STATUS_IN_CLASS(statusCode, 300)) {
            return VETAccountStatusConnecting;
        }
        else if (PJSIP_IS_STATUS_IN_CLASS(statusCode, 200)) {
            return VETAccountStatusConnected;
        }
        else if (statusCode == 403 || statusCode == 401) {
            return VETAccountStatusForbid;
        }
        else if (statusCode == 503) {
            return VETAccountStatusNetworkError;
        }
        else {
            return VETAccountStatusInvalid;
        }
    }
}

- (NSInteger)detailAccountStatus
{
    if (_accountId == kVETVoipManagerInvalidIdentifier) {
        return 0;
    }
    
    pjsua_acc_info accountInfo;
    pj_status_t status;
    
    status = pjsua_acc_get_info((pjsua_acc_id)_accountId, &accountInfo);
    if (status != PJ_SUCCESS) {
        return 0;
    }
    
    return accountInfo.status;
}

- (NSInteger)registrationExpireTime {
    if ([self accountId] == kVETVoipManagerInvalidIdentifier) {
        return -1;
    }
    
    pjsua_acc_info accountInfo;
    pj_status_t status;
    
    status = pjsua_acc_get_info((pjsua_acc_id)[self accountId], &accountInfo);
    if (status != PJ_SUCCESS) {
        return -1;
    }
    
    return accountInfo.expires;
}

- (NSInteger)registrationErrorCode {
    if ([self accountId] == kVETVoipManagerInvalidIdentifier) {
        return 0;
    }
    
    pjsua_acc_info accountInfo;
    pj_status_t status;
    
    status = pjsua_acc_get_info((pjsua_acc_id)[self accountId], &accountInfo);
    if (status != PJ_SUCCESS) {
        return 0;
    }
    
    return accountInfo.reg_last_err;
}

- (NSString *)registrationStatusText {
    if ([self accountId] == kVETVoipManagerInvalidIdentifier) {
        return @"";
    }
    
    pjsua_acc_info accountInfo;
    pj_status_t status;
    
    status = pjsua_acc_get_info((pjsua_acc_id)[self accountId], &accountInfo);
    if (status != PJ_SUCCESS) {
        return @"";
    }
    
    return [NSString stringWithPJString:accountInfo.status_text];
}

- (BOOL)isOnline {
    if ([self accountId] == kVETVoipManagerInvalidIdentifier) {
        return NO;
    }
    
    pjsua_acc_info accountInfo;
    pj_status_t status;
    
    status = pjsua_acc_get_info((pjsua_acc_id)[self accountId], &accountInfo);
    if (status != PJ_SUCCESS) {
        return NO;
    }
    
    return (accountInfo.online_status == PJ_TRUE) ? YES : NO;
}

- (void)setOnline:(BOOL)value {
    if ([self accountId] == kVETVoipManagerInvalidIdentifier) {
        return;
    }
    
    if (value) {
        pjsua_acc_set_online_status((pjsua_acc_id)[self accountId], PJ_TRUE);
    } else {
        pjsua_acc_set_online_status((pjsua_acc_id)[self accountId], PJ_FALSE);
    }
}

- (NSString *)onlineStatusText {
    if ([self accountId] == kVETVoipManagerInvalidIdentifier) {
        return @"";
    }
    
    pjsua_acc_info accountInfo;
    pj_status_t status;
    
    status = pjsua_acc_get_info((pjsua_acc_id)[self accountId], &accountInfo);
    if (status != PJ_SUCCESS) {
        return @"";
    }
    
    return [NSString stringWithPJString:accountInfo.online_status_text];
}

- (NSString *)description {
    return [self SIPAddress];
}

- (void)makeCallTo:(VETSIPURI *)destination completion:(void (^)(VETVoipCall *))completion
{
    void (^onCallMakeCompletion)(BOOL, pjsua_call_id) = ^(BOOL success, pjsua_call_id callID) {
        if (success) {
            completion([self addCallWithCallId:callID]);
        } else {
            NSLog(@"Error making call to %@ via account %@", destination, self);
            completion(nil);
        }
    };
    VETVoipCallParameters *parameters = [[VETVoipCallParameters alloc] initWithDestination:destination
                                                                               accountId:(pjsua_acc_id)self.accountId
                                                                            completion:onCallMakeCompletion];
    assert(self.thread);
    [self performSelector:@selector(thread_makeCallWithParameters:) onThread:self.thread withObject:parameters waitUntilDone:NO];
}

- (void)thread_makeCallWithParameters:(VETVoipCallParameters *)parameters {
    pj_str_t uri = parameters.destination.description.pjString;
    pjsua_call_id callID = PJSUA_INVALID_ID;
    
    pjsua_call_setting callSetting;
    pjsua_call_setting_default(&callSetting);
    callSetting.aud_cnt = 1;
    callSetting.vid_cnt = 0;
    BOOL success = pjsua_call_make_call(parameters.accountId, &uri, &callSetting, NULL, NULL, &callID) == PJ_SUCCESS;
    NSLog(@"=== finish pjsua_call_make_call");
    dispatch_async(dispatch_get_main_queue(), ^{ parameters.completion(success, callID); });
}

- (VETVoipCall *)addCallWithCallId:(NSInteger)callId
{
    VETVoipCall *call = [self callWithCallId:callId];
    if (!call) {
        call = [[VETVoipCall alloc] initWithSIPAccount:self callId:callId];
        [self.calls addObject:call];
    }
    return call;
}

- (nullable VETVoipCall *)callWithCallId:(NSInteger)callId
{
    for (VETVoipCall *call in self.calls) {
        if (call.callId == callId) {
            return call;
        }
    }
    return nil;
}

- (void)removeCall:(VETVoipCall *)call
{
    [self.calls removeObject:call];
}

- (void)removeAllCalls
{
    [self.calls removeAllObjects];
}

@end
