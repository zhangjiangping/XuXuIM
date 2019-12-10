//
//  VETVoipCall.m
//  MobileVoip
//
//  Created by Liu Yang on 28/04/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETVoipCall.h"
#import "VETVoipAccount.h"
#import "VETVoipManager.h"
#import "NSString+VETVoipExtension.h"
#import "VETSIPURI.h"
#import "VETVoipConstants.h"
#import "VETVoipConfig.h"

// 最大可登录的帐户
const NSInteger kAKSIPCallsMax = 8;

@interface VETVoipCall () {
    BOOL _incoming;
    BOOL _missed;
}

@property (nonatomic, getter=isMicrophoneMuted) BOOL microphoneMuted;

@property (nonatomic, assign) CGFloat nowVolume;
@property (nonatomic, assign) CGFloat nowMicVolume;

@property (nonatomic, assign) CGFloat volumeScale;
//@property (nonatomic, assign) pjsua_call_id callId;

@end

@implementation VETVoipCall

- (void)dealloc
{
    if (_callId != PJSUA_INVALID_ID && pjsua_call_is_active(_callId)) {
        pjsua_call_hangup(_callId, 0, NULL, NULL);
    }
    
    _account = nil;
    _callId = PJSUA_INVALID_ID;
    
    [self setDelegate:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VETVoipSettingDefaulVolumeNotification object:nil];
}

- (instancetype)initWithSIPAccount:(VETVoipAccount *)account callId:(NSInteger)callId
{
    if (self = [super init]) {
        _account = account;
        _callId = callId;
        
        pjsua_call_info call;
        pj_status_t status = pjsua_call_get_info((pjsua_call_id)callId, &call);
//        assert(status == PJ_SUCCESS);
        _incoming = call.role == PJSIP_ROLE_UAS;
        _missed = _incoming;
        _state = (VETVoipCallState)call.state;
        _stateText = [NSString stringWithPJString:call.state_text];
        _lastStatus = call.last_status;
        _lastStatusText = [NSString stringWithPJString:call.last_status_text];
        
        /* Ringback config */
        VETVoipConfig *config = [VETVoipManager sharedManager].config;
        
        self.volumeScale = config.volumeScale;
        self.nowVolume = 1.0 / _volumeScale;
        self.nowMicVolume = 0.15;
        
        _localURI = [VETSIPURI SIPURIWithString:[NSString stringWithPJString:call.local_info]];
        // remote_info:"8001006" <sip:8001006@103.234.220.234>
        _remoteURI = [VETSIPURI SIPURIWithString:[NSString stringWithPJString:call.remote_info]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDefaultVolume) name:VETVoipSettingDefaulVolumeNotification object:nil];
    }
    return self;
}

- (void)setDelegate:(id<VETCallDelegate>)aDelegate
{
    if (_delegate == aDelegate) {
        return;
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    if (_delegate != nil) {
        [notificationCenter removeObserver:_delegate name:nil object:self];
    }
    
    if (aDelegate != nil) {
        if ([aDelegate respondsToSelector:@selector(VETCallCalling:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallCalling:)
                                       name:VETVoipCallCallingNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallIncoming:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallIncoming:)
                                       name:VETVoipCallIncomingNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallEarly:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallEarly:)
                                       name:VETVoipCallEarlyNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallConnecting:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallConnecting:)
                                       name:VETVoipCallConnectingNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallDidConfirm:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallDidConfirm:)
                                       name:VETVoipCallDidConfirmNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallDidDisconnect:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallDidDisconnect:)
                                       name:VETVoipCallDidDisconnectNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallMediaDidBecomeActive:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallMediaDidBecomeActive:)
                                       name:VETVoipCallMediaDidBecomeActiveNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallDidLocalHold:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallDidLocalHold:)
                                       name:VETVoipCallDidLocalHoldNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallDidRemoteHold:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallDidRemoteHold:)
                                       name:VETVoipCallDidRemoteHoldNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallTransferStatusDidChange:)]) {
            [notificationCenter addObserver:aDelegate
                                   selector:@selector(VETCallTransferStatusDidChange:)
                                       name:VETVoipCallTransferStatusDidChangeNotification
                                     object:self];
        }
        if ([aDelegate respondsToSelector:@selector(VETCallDidDisconnectWhen480:)]) {
            [notificationCenter addObserver:aDelegate selector:@selector(VETCallDidDisconnectWhen480:) name:VETVoipCallingDisconnected480Notification object:self];
        }
    }
    _delegate = aDelegate;
}

- (BOOL)isIncoming {
    return _incoming;
}

- (BOOL)isMissed {
    return _missed;
}

- (void)setMissed:(BOOL)flag {
    _missed = flag;
}

- (BOOL)isActive {
    if ([self callId] == kVETVoipManagerInvalidIdentifier) {
        return NO;
    }
    
    return (pjsua_call_is_active((pjsua_call_id)[self callId])) ? YES : NO;
}

- (BOOL)isOnLocalHold {
    if ([self callId] == kVETVoipManagerInvalidIdentifier) {
        return NO;
    }
    
    pjsua_call_info callInfo;
    pjsua_call_get_info((pjsua_call_id)[self callId], &callInfo);
    
    return (callInfo.media_status == PJSUA_CALL_MEDIA_LOCAL_HOLD) ? YES : NO;
}

- (BOOL)isOnRemoteHold {
    if ([self callId] == kVETVoipManagerInvalidIdentifier) {
        return NO;
    }
    
    pjsua_call_info callInfo;
    pjsua_call_get_info((pjsua_call_id)[self callId], &callInfo);
    
    return (callInfo.media_status == PJSUA_CALL_MEDIA_REMOTE_HOLD) ? YES : NO;
}

- (void)answer
{
    pj_status_t status = pjsua_call_answer((pjsua_call_id)self.callId, PJSIP_SC_OK, NULL, NULL);
    if (status == PJ_SUCCESS) {
        self.missed = NO;
    } else {
        NSLog(@"Error answering call %@", self);
    }
}

- (void)hangUp
{
    if (self.callId == kVETVoipManagerInvalidIdentifier || self.state == kVETVoipCallDisconnectedState) {
        return;
    }
    pj_status_t status = pjsua_call_hangup((pjsua_call_id)self.callId, 0, NULL, NULL);
    if (status == PJ_SUCCESS) {
        self.missed = NO;
    }
    else {
        NSLog(@"Error hanging up call %@", self);
    }
}

- (void)settingDefaultVolume
{
    [self adjustVolume:_nowVolume mic:_nowMicVolume];
}

- (void)attendedTransferToCall:(VETVoipCall *)destinationCall
{
    [self setTransferStatus:kVETVoipManagerInvalidIdentifier];
    [self setTransferStatusText:@""];
    pj_status_t status = pjsua_call_xfer_replaces((pjsua_call_id)self.callId,
                                                  (pjsua_call_id)destinationCall.callId,
                                                  PJSUA_XFER_NO_REQUIRE_REPLACES,
                                                  NULL);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error transfering call %@", self);
    }
}

- (void)sendRingingNotification
{
    NSLog(@"callId:%d", (pjsua_call_id)self.callId);
    pj_status_t status = pjsua_call_answer((pjsua_call_id)self.callId, PJSIP_SC_RINGING, NULL, NULL);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error sending ringing notification in call %@", self);
    }
}

- (void)replyWithTemporarilyUnavailable
{
    pj_status_t status = pjsua_call_answer((pjsua_call_id)self.callId, PJSIP_SC_TEMPORARILY_UNAVAILABLE, NULL, NULL);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error replying with 480 Temporarily Unavailable");
    }
}

- (void)replyWithBusyHere
{
    pj_status_t status = pjsua_call_answer((pjsua_call_id)self.callId, PJSIP_SC_BUSY_HERE, NULL, NULL);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error replying with 486 Busy Here");
    }
}

- (void)sendDTMFDigits:(NSString *)digits
{
    pj_status_t status;
    pj_str_t pjDigits = [digits pjString];
    
    // Try to send RFC2833 DTMF first.
    status = pjsua_call_dial_dtmf((pjsua_call_id)self.callId, &pjDigits);
    
    if (status != PJ_SUCCESS) {  // Okay, that didn't work. Send INFO DTMF.
        const pj_str_t kSIPINFO = pj_str("INFO");
        
        for (NSUInteger i = 0; i < [digits length]; ++i) {
            pjsua_msg_data messageData;
            pjsua_msg_data_init(&messageData);
            messageData.content_type = pj_str("application/dtmf-relay");
            
            NSString *messageBody = [NSString stringWithFormat:@"Signal=%C\r\nDuration=300",
                                     [digits characterAtIndex:i]];
            messageData.msg_body = [messageBody pjString];
            
            status = pjsua_call_send_request((pjsua_call_id)self.callId, &kSIPINFO, &messageData);
            if (status != PJ_SUCCESS) {
                NSLog(@"Error sending DTMF");
            }
        }
    }
}

- (void)toggleMicrophoneMute
{
    if ([self isMicrophoneMuted]) {
        [self unmuteMicrophone];
    } else {
        [self muteMicrophone];
    }
}

/// 静音
- (void)muteMicrophone {
    if ([self isMicrophoneMuted] || [self state] != kVETVoipCallConfirmedState) {
        return;
    }
    
    pjsua_call_info callInfo;
    pjsua_call_get_info((pjsua_call_id)self.callId, &callInfo);
    
    pj_status_t status = pjsua_conf_disconnect(0, callInfo.conf_slot);
    if (status == PJ_SUCCESS) {
        [self setMicrophoneMuted:YES];
    } else {
        NSLog(@"Error muting microphone in call %@", self);
    }
}

// 取消静音
- (void)unmuteMicrophone {
    if (![self isMicrophoneMuted] || [self state] != kVETVoipCallConfirmedState) {
        return;
    }
    
    pjsua_call_info callInfo;
    pjsua_call_get_info((pjsua_call_id)self.callId, &callInfo);
    
    pj_status_t status = pjsua_conf_connect(0, callInfo.conf_slot);
    if (status == PJ_SUCCESS) {
        [self setMicrophoneMuted:NO];
    } else {
        NSLog(@"Error unmuting microphone in call %@", self);
    }
}

- (void)toggleHold
{
    if ([self isOnLocalHold]) {
        [self unhold];
    } else {
        [self hold];
    }
}

- (void)hold {
    if ([self state] == kVETVoipCallConfirmedState && ![self isOnRemoteHold]) {
        pjsua_call_set_hold((pjsua_call_id)self.callId, NULL);
    }
}

- (void)unhold {
    if ([self state] == kVETVoipCallConfirmedState) {
        pjsua_call_reinvite((pjsua_call_id)self.callId, PJ_TRUE, NULL);
    }
}

- (BOOL)adjustVolume:(CGFloat)volume mic:(CGFloat)micVolume {
    NSAssert(0.0 <= volume && volume <= 1.0, @"Volume value must be between 0.0 and 1.0");
    NSAssert(0.0 <= micVolume && micVolume <= 1.0, @"Mic Volume must be between 0.0 and 1.0");
    
    _nowVolume = volume;
    _nowMicVolume = micVolume;
    if (_callId == PJSUA_INVALID_ID)
        return YES;
    
    pjsua_call_info callInfo;
    pjsua_call_get_info(_callId, &callInfo);
    if (callInfo.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        // scale volume as per configured volume scale
        volume *= _volumeScale;
        micVolume *= _volumeScale;
        pjsua_conf_port_id callPort = pjsua_call_get_conf_port(_callId);
        pj_status_t volumeStatus = (pjsua_conf_adjust_rx_level(callPort, volume));
        if (volumeStatus != PJ_SUCCESS) {
            NSLog(@"adjust Volume is error : %@", self);
        }
        pj_status_t micStatus = (pjsua_conf_adjust_tx_level(callPort, micVolume));
        if (micStatus != PJ_SUCCESS) {
            NSLog(@"adjust mic is error : %@", self);
        }
    }
    return YES;
}

#pragma mark - query

- (void)queryCurrentQuality
{
    //    PJ_DECL(pj_status_t) pjsua_call_dump(pjsua_call_id call_id,
    //                                         pj_bool_t with_media,
    //                                         char *buffer,
    //                                         unsigned maxlen,
    //                                         const char *indent);
    static char some_buf[1024];
    pjsua_call_dump(_account.accountId, PJ_TRUE, some_buf, sizeof(some_buf), " ");
    NSLog(@"quality:%s", some_buf);
    
}

@end
