//
//  PJSUAOnCallMediaState.m
//  MobileVoip
//
//  Created by Liu Yang on 03/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETVoipCallbacks.h"
#import "VETVoip.h"

#define THIS_FILE "PJSUAOnCallState.m"

static void LogCallMedia(const pjsua_call_info *callInfo);
static void CallMediaStateChanged(pjsua_call_info callInfo);
static const char *MediaStatusTextWithStatus(pjsua_call_media_status status);
static void ConnectCallToSoundDevice(VETVoipCall *call, const pjsua_call_info *callInfo);
static void PostMediaStateChangeNotification(VETVoipCall *call, pjsua_call_media_status status);

void PJSUAOnCallMediaState(pjsua_call_id callID) {
    pjsua_call_info callInfo;
    pjsua_call_get_info(callID, &callInfo);
    LogCallMedia(&callInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        CallMediaStateChanged(callInfo);
    });
}

static void LogCallMedia(const pjsua_call_info *callInfo) {
    for (NSUInteger i = 0; i < callInfo->media_cnt; i++) {
        NSLog(@"-----Call %d media %d [type = %s], status is %s",
                   callInfo->id, i, pjmedia_type_name(callInfo->media[i].type),
                   MediaStatusTextWithStatus(callInfo->media[i].status));
    }
}

static void CallMediaStateChanged(pjsua_call_info callInfo) {
        VETVoipManager *voipManager = [VETVoipManager sharedManager];
        VETVoipCall *call = [voipManager callWithCallId:callInfo.id];
        if (call == nil) {
            PJ_LOG(3, (THIS_FILE, "Could not find AKSIPCall for call %d during media state change", callInfo.id));
            return;
        }
        ConnectCallToSoundDevice(call, &callInfo);
//        if (callInfo.media_status != PJSUA_CALL_MEDIA_ACTIVE) {
        [voipManager stopRingbackForCall:call];
//        }
        PostMediaStateChangeNotification(call, callInfo.media_status);
        [[NSNotificationCenter defaultCenter] postNotificationName:VETVoipSettingDefaulVolumeNotification object:nil];
}

static const char *MediaStatusTextWithStatus(pjsua_call_media_status status) {
    const char *texts[] = { "None", "Active", "Local hold", "Remote hold", "Error" };
    return texts[status];
}

static void ConnectCallToSoundDevice(VETVoipCall *call, const pjsua_call_info *callInfo) {
    if (callInfo->media_status == PJSUA_CALL_MEDIA_ACTIVE ||
        callInfo->media_status == PJSUA_CALL_MEDIA_REMOTE_HOLD) {
        pjsua_conf_connect(callInfo->conf_slot, 0);
        if (!call.isMicrophoneMuted) {
            pjsua_conf_connect(0, callInfo->conf_slot);
        }
    }
}

static void PostMediaStateChangeNotification(VETVoipCall *call, pjsua_call_media_status status) {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSString *notificationName = nil;
    switch (status) {
        case PJSUA_CALL_MEDIA_ACTIVE:
            notificationName = VETVoipCallMediaDidBecomeActiveNotification;
            break;
        case PJSUA_CALL_MEDIA_LOCAL_HOLD:
            notificationName = VETVoipCallDidLocalHoldNotification;
            break;
        case PJSUA_CALL_MEDIA_REMOTE_HOLD:
            notificationName = VETVoipCallDidRemoteHoldNotification;
            break;
        default:
            break;
            
    }
    if (notificationName != nil) {
        [nc postNotificationName:notificationName object:call];
    }
}
