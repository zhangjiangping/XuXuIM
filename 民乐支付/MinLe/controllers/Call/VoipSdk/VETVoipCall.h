//
//  VETVoipCall.h
//  MobileVoip
//
//  Created by Liu Yang on 28/04/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pjsua-lib/pjsua.h>

@class VETSIPURI;

extern const NSInteger kAKSIPCallsMax;

typedef NS_ENUM(NSUInteger, VETVoipCallState) {
    // Before INVITE is sent or received.
    kVETVoipCallNullState =         PJSIP_INV_STATE_NULL,
    
    // After INVITE is sent.
    kVETVoipCallCallingState =      PJSIP_INV_STATE_CALLING,
    
    // After INVITE is received.
    kVETVoipCallIncomingState =     PJSIP_INV_STATE_INCOMING,
    
    // After response with To tag.
    kVETVoipCallEarlyState =        PJSIP_INV_STATE_EARLY,
    
    // After 2xx is sent/received.
    kVETVoipCallConnectingState =   PJSIP_INV_STATE_CONNECTING,
    
    // After ACK is sent/received.
    kVETVoipCallConfirmedState =    PJSIP_INV_STATE_CONFIRMED,
    
    // Session is terminated.
    kVETVoipCallDisconnectedState = PJSIP_INV_STATE_DISCONNECTED
};
#define VETVoipCallStateString(VETVoipCallState) [@[@"kVETVoipCallNullState", @"kVETVoipCallCallingState", @"kVETVoipCallIncomingState", @"kVETVoipCallEarlyState", @"kVETVoipCallConnectingState", @"kVETVoipCallConfirmedState", @"kVETVoipCallDisconnectedState"] objectAtIndex:VETAccountStatus]

/// Protocol that must be adopted by objects that want to act as delegates of AKSIPCall objects.
@protocol VETCallDelegate <NSObject>

@optional

// Methods to handle AKSIPCall notifications to which the delegate is automatically subscribed.
- (void)VETCallDidDisconnectWhen480:(NSNotification *)notification;
- (void)VETCallCalling:(NSNotification *)notification;
- (void)VETCallIncoming:(NSNotification *)notification;
- (void)VETCallEarly:(NSNotification *)notification;
- (void)VETCallConnecting:(NSNotification *)notification;
- (void)VETCallDidConfirm:(NSNotification *)notification;
- (void)VETCallDidDisconnect:(NSNotification *)notification;
- (void)VETCallMediaDidBecomeActive:(NSNotification *)notification;
- (void)VETCallDidLocalHold:(NSNotification *)notification;
- (void)VETCallDidRemoteHold:(NSNotification *)notification;
- (void)VETCallTransferStatusDidChange:(NSNotification *)notification;

@end

@class VETVoipAccount, VETSIPURI, VETRingback;

@interface VETVoipCall : NSObject

@property(nonatomic, readonly) VETVoipAccount *account;
@property(nonatomic, assign, readonly) NSInteger callId;

@property(nonatomic, weak) id<VETCallDelegate> delegate;

// call state
@property(nonatomic) VETVoipCallState state;
@property(nonatomic, copy) NSString *stateText;

@property(nonatomic) NSInteger lastStatus;
@property(nonatomic, copy) NSString *lastStatusText;

@property(nonatomic) NSInteger transferStatus;
@property(nonatomic, copy) NSString *transferStatusText;

@property(nonatomic) NSInteger duration;

@property(nonatomic, readonly, copy) NSDate *date;
@property(nonatomic, readonly) VETSIPURI *localURI;
@property(nonatomic, readonly) VETSIPURI *remoteURI;
@property(nonatomic, readonly, getter=isActive) BOOL active;
@property(nonatomic, readonly, getter=isMicrophoneMuted) BOOL microphoneMuted;
@property(nonatomic, readonly, getter=isOnLocalHold) BOOL onLocalHold;
@property(nonatomic, readonly, getter=isOnRemoteHold) BOOL onRemoteHold;

- (instancetype)initWithSIPAccount:(VETVoipAccount *)account callId:(NSInteger)callId;

- (void)answer;
- (void)hangUp;

- (void)attendedTransferToCall:(VETVoipCall *)destinationCall;

- (void)sendRingingNotification;
- (void)replyWithTemporarilyUnavailable;
- (void)replyWithBusyHere;

- (void)sendDTMFDigits:(NSString *)digits;

/*
 *  麦克风静音切换
 */
- (void)toggleMicrophoneMute;

/*
 *  Hold切换
 */
- (void)toggleHold;

@end
