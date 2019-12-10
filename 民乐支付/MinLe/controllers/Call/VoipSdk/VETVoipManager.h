//
//  VETVoipSdkPrc.h
//  MobileVoip
//
//  Created by Liu Yang on 26/04/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pjsua-lib/pjsua.h>

NS_ASSUME_NONNULL_BEGIN

@class VETVoipConfig;
@class VETVoipAccount;
@class VETVoipCall;

// Posted when the user agent finishes starting. However, it may not be started if an error occurred during user agent
// start-up. You can check user agent state via the |state| property.
extern NSString * const VETVoipManagerDidFinishStartingNotification;

// Posted when the user agent finishes stopping.
extern NSString * const VETVoipManagerDidFinishStoppingNotification;

// Posted when the account status change. Object is @VETVoipAccount;
extern NSString * const VETVoipManagerAccountRegisterStatusNotification;

// An invalid identifier for all sorts of identifiers.
extern const NSInteger kVETVoipManagerInvalidIdentifier;

// User agent states.
typedef NS_ENUM(NSInteger, VETVoipAgentState) {
    VETVoipAgentStateStopped,
    VETVoipAgentStateStarting,
    VETVoipAgentStateStarted,
    VETVoipAgentStateStopping
};

typedef struct _VETVoipManagerCallData {
    pj_timer_entry timer;
    pj_bool_t ringbackOn;
    pj_bool_t ringbackOff;
} VETVoipManagerCallData;

@interface VETVoipManager : NSObject

/// A Boolean value indicating if only G.711 codec is used.
@property (nonatomic, assign) BOOL usesG711Only;

// A Boolean value indicating whether the receiver has been started.
@property (nonatomic, readonly, assign, getter=isStarted) BOOL started;

// PJSUA state
@property (nonatomic, readonly) VETVoipAgentState state;

@property (nonatomic, copy) void (^ callStateBlock)(void);

@property (nonatomic, retain, readonly) NSMutableArray *accounts;

// Receiver's call data.
@property (nonatomic, readonly, assign) VETVoipManagerCallData *callData;

@property (nonatomic, copy, readonly) VETVoipConfig *config;

@property(nonatomic) pj_pool_t *pool;

// Network port to use for SIP transport. Set 0 for any available port.
// Default: 0.
@property(nonatomic, assign) NSUInteger transportPort;

+ (instancetype)sharedManager;

- (void)setupConfig:(VETVoipConfig *)config;

// Starts user agent.
- (void)start;

// Stops user agent.
- (void)stop;
- (void)stopAndWait;

/*
 *  根据AccountId查询已注册的帐户
 */
- (VETVoipAccount *)accountWithAccountId:(NSInteger)accountId;

/*
 *  根据Username查询已注册的帐户
 */
- (VETVoipAccount *)accountWithUsername:(NSString *)username;

/*
 *  Returns a SIP call with a given identifier.
 */
- (nullable VETVoipCall *)callWithCallId:(NSInteger)accountId;

// Hangs up all calls controlled by the receiver.
- (void)hangUpAllCalls;

/*
 *  启动本地ringback
 */
- (void)startRingbackForCall:(VETVoipCall *)call;

/*
 *  停止本地ringback
 */
- (void)stopRingbackForCall:(VETVoipCall *)call;

/*
 *  设置为主帐户
 */
- (void)setMainAccount:(VETVoipAccount *)account;

- (void)quitAccountWith:(VETVoipAccount *)account completion:(void)block; // 退出帐号

- (void)anwserCall;

- (void)setCodec;

// Adds an account to the user agent.
- (BOOL)addAccount:(VETVoipAccount *)anAccount;

// Removes an account from the user agent.
- (BOOL)removeAccount:(VETVoipAccount *)account;

- (BOOL)updatePriorityWithCodecId:(NSString *)codecId priority:(NSUInteger)priority;

- (NSArray *)queryCodec;

- (void)queryBalanceBalanceCompletion:(void (^) (NSString *balance))completion;

@end

NS_ASSUME_NONNULL_END
