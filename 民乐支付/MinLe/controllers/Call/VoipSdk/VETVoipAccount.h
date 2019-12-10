//
//  VETAccount.h
//  MobileVoip
//
//  Created by Liu Yang on 28/04/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VETSIPURI;
@class VETVoipCall;
@class VETVoipAccount;

@protocol VETVoipAccountDelegate <NSObject>

/// Called when account registration changes.
//- (void)voipAccountRegistrationDidChange:(VETVoipAccount *)account;

@optional
/// Called when account is about to be removed.
- (void)voipAccountWillRemove:(VETVoipAccount *)account;

/// Sent when AKSIPAccount receives an incoming call.
- (void)voipAccount:(VETVoipAccount *)account didReceiveCall:(VETVoipCall *)aCall;

@end

/// Account Status enum.
typedef enum {
    VETAccountStatusInitial, ///< Account is initial...
    VETAccountStatusOffline, ///< Account is offline or no registration has been done.
    VETAccountStatusInvalid, ///<  attempted registration but the credentials were invalid.
    VETAccountStatusConnecting, ///< trying to register the account with the SIP server.
    VETAccountStatusConnected, ///< Account has been successfully registered with the SIP server.
    VETAccountStatusDisconnecting, ///< Account is being unregistered from the SIP server.
    VETAccountStatusNetworkError, ///503< Account network error.
    VETAccountStatusForbid, ///403< Account info error.
} VETAccountStatus; ///< Account status enum.
#define VETAccountStatusString(VETAccountStatus) [@[@"initial", @"offline", @"invalid", @"connecting", @"connected", @"disconnecting", @"network error", @"username or password error"] objectAtIndex:VETAccountStatus]

typedef NS_ENUM(NSUInteger, VETAccountEncryptionType) {
    VETAccountEncryptionTypeRC4 = 0,
    VETAccountEncryptionTypeSRTP = 1,
    VETAccountEncryptionTypeNone = 2,
};

typedef NS_ENUM(NSUInteger, VETAccountTransportType) {
    VETAccountTransportTypeTCP = 0,
    VETAccountTransportTypeUDP = 1,
    VETAccountTransportTypeTLS = 2,
};

@interface VETVoipAccount : NSObject

// The receiver's delegate.
@property(nonatomic, weak) id <VETVoipAccountDelegate> delegate;

// The receiver's identifier at the user agent.
@property(nonatomic, readonly) NSInteger accountId;

@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, readonly) NSString *password;// 使用keychain

// 103.234.220.234
@property (nonatomic, readonly) NSString *domain;
@property (nonatomic, readonly) NSString *realm;

// sip:18670930580@103.234.220.234:5070
@property(nonatomic, readonly) NSString *SIPAddress;

@property (nonatomic, readonly) BOOL substitutesPlusCharacter;
@property (nonatomic, readonly) NSString* plusCharacterSubstitution;

// SIP re-registration time.
// Default: 300 (sec).
@property(nonatomic) NSUInteger reregistrationTime;

@property (nonatomic, assign) VETAccountStatus accountStatus;

@property (nonatomic, readonly) NSInteger detailAccountStatus;

@property (nonatomic, assign) VETAccountTransportType transportType;
@property (nonatomic, assign) VETAccountEncryptionType encryptionType;

// A Boolean value indicating whether the receiver is online in terms of SIP
@property(nonatomic, getter=isOnline) BOOL online;

// A Boolean value indicating whether the receiver is registered.
@property(nonatomic, getter=isRegistered) BOOL registered;

@property(nonatomic) NSThread *thread;

- (instancetype)initWithFullName:(NSString *)fullName username:(NSString *)username password:(NSString *)password domain:(NSString *)domain realm:(NSString *)realm encryptionType:(VETAccountEncryptionType)encryptionType transportType:(VETAccountTransportType)transportType encryptionPort:(NSString *)port;

- (void)updateUsername:(NSString *)username;
- (void)updateAccountId:(NSInteger)accountId;

/*  Makes a call to a given destination URI.
 *  @return if vetvoipcall not nil, result is true.
 */
- (void)makeCallTo:(VETSIPURI *)destination completion:(void (^)(VETVoipCall *))completion;

- (VETVoipCall *)addCallWithCallId:(NSInteger)callId;

- (nullable VETVoipCall *)callWithCallId:(NSInteger)callId;

- (void)removeCall:(VETVoipCall *)call;

- (void)removeAllCalls;

@end

NS_ASSUME_NONNULL_END
