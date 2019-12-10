//
//  PJSUAOnCallState.m
//  MobileVoip
//
//  Created by Liu Yang on 03/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETVoipCallbacks.h"
#import "VETVoip.h"
#import "VETVoipConstants.h"
#import "NSString+VETVoipExtension.h"

#define THIS_FILE "PJSUAOnCallState.m"
static void LogCallDump(int call_id);

void PJSUAOnCallState(pjsua_call_id callID, pjsip_event *event) {
    pjsua_call_info callInfo;
    pjsua_call_get_info(callID, &callInfo);
    
    NSString *status = [NSString stringWithPJString:callInfo.state_text];
    LYLog(@"===通话状态:%@",status);
    
    BOOL mustStartRingback = NO;
    NSNumber *SIPEventCode = nil;
    NSString *SIPEventReason = nil;
    
    if (callInfo.state == PJSIP_INV_STATE_DISCONNECTED) {
        PJ_LOG(3, (THIS_FILE, "Call %d is DISCONNECTED [reason = %d (%s)]",
                   callID,
                   callInfo.last_status,
                   callInfo.last_status_text.ptr));
        PJ_LOG(5, (THIS_FILE, "Dumping media stats for call %d", callID));
        LogCallDump(callID);
    }
    else if (callInfo.state == PJSIP_INV_STATE_EARLY) {
        pj_str_t reason;
        pjsip_msg *msg;
        int code;
        
        pj_assert(event->type == PJSIP_EVENT_TSX_STATE);
        
        // 接收到的msg
        if (event->body.tsx_state.type == PJSIP_EVENT_RX_MSG) {
            msg = event->body.tsx_state.src.rdata->msg_info.msg;
        }
        else {
            msg = event->body.tsx_state.src.tdata->msg;
        }
        
        code = msg->line.status.code;
        reason = msg->line.status.reason;
        
        SIPEventCode = @(code);
        SIPEventReason = [NSString stringWithPJString:reason];
        
        LYLog(@"---Code:%d", code);
        LYLog(@"---msg->body is Null:%@", msg->body == NULL ? @"yes" : @"NO");
        if (callInfo.role == PJSIP_ROLE_UAC && (code == 180 || code == 183) && callInfo.media_status == PJSUA_CALL_MEDIA_NONE) {
            mustStartRingback = YES;
        }
        PJ_LOG(3, (THIS_FILE, "Call %d state changed to %s (%d %.*s)",
                   callID, callInfo.state_text.ptr,
                   code, (int)reason.slen, reason.ptr));
    }else {
        PJ_LOG(3, (THIS_FILE, "Call %d state changed to %s", callID, callInfo.state_text.ptr));
    }
    
    VETVoipCallState state = (VETVoipCallState)callInfo.state;
    NSLog(@"callInfo.state:%d", callInfo.state);
    NSInteger accountId = callInfo.acc_id;
    NSString *stateText = [NSString stringWithPJString:callInfo.state_text];
    NSInteger lastStatus = callInfo.last_status;
    NSString *lastStatusText = [NSString stringWithPJString:callInfo.last_status_text];
    NSInteger duration = callInfo.connect_duration.sec;
    dispatch_async(dispatch_get_main_queue(), ^{
        VETVoipManager *voipManager = [VETVoipManager sharedManager];
        VETVoipCall *call = [voipManager callWithCallId:callID];
        if (call == nil) {
            if (state == kVETVoipCallCallingState) {
                VETVoipAccount *account = [voipManager accountWithAccountId:accountId];
                if (account != nil) {
                    call = [account addCallWithCallId:call.callId];
                }
                else {
                    PJ_LOG(3, (THIS_FILE,
                               "Did not create AKSIPCall for call %d during call state change. Could not find account",
                               callID));
                    return;  // From block.
                }
            }
            else {
                PJ_LOG(3, (THIS_FILE, "Could not find AKSIPCall for call %d during call state change", callID));
                return;  // From block.
            }
        }
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        call.state = state;
        call.stateText = stateText;
        call.lastStatus = lastStatus;
        call.lastStatusText = lastStatusText;
        call.duration = duration;
        if (state == kVETVoipCallDisconnectedState) {
            [voipManager stopRingbackForCall:call];
            [call.account removeCall:call];
            [notification postNotificationName:VETVoipCallDidDisconnectNotification object:call];
            
            // 480时，重新register一次。
            if (callInfo.last_status == 480) {
                [notification postNotificationName:VETVoipCallingDisconnected480Notification object:call];
            }
        }
        else if (state == kVETVoipCallEarlyState) {
            if (mustStartRingback) {
                [voipManager startRingbackForCall:call];
            }
            NSDictionary *userinfo = nil;
            if (SIPEventCode != nil && SIPEventReason != nil) {
                userinfo = @{@"VETVoipEventCode": SIPEventCode, @"VETVoipEventReason": SIPEventReason};
            }
            [notification postNotificationName:VETVoipCallEarlyNotification object:call userInfo:userinfo];
        }
        else {
            // Incoming call notification is posted from AKIncomingCallReceived().
            NSString *notificationName = nil;
            switch ((VETVoipCallState)state) {
                case (kVETVoipCallCallingState):
                    notificationName = VETVoipCallCallingNotification;
                    break;
                case kVETVoipCallConnectingState:
                    notificationName = VETVoipCallConnectingNotification;
                    break;
                case kVETVoipCallConfirmedState:
                    notificationName = VETVoipCallDidConfirmNotification;
                    break;
                default:
                    assert(NO);
                    break;
            }
            if (notificationName != nil) {
                [notification postNotificationName:notificationName object:call];
            }
        }
    });
}

/*
 * Print log of call states. Since call states may be too long for logger,
 * printing it is a bit tricky, it should be printed part by part as long
 * as the logger can accept.
 */
static void LogCallDump(int call_id) {
    size_t call_dump_len;
    size_t part_len;
    unsigned part_idx;
    unsigned log_decor;
    static char some_buf[1024 * 3];
    
    pjsua_call_dump(call_id, PJ_TRUE, some_buf,
                    sizeof(some_buf), "  ");
    call_dump_len = strlen(some_buf);
    
    log_decor = pj_log_get_decor();
    pj_log_set_decor(log_decor & ~(PJ_LOG_HAS_NEWLINE | PJ_LOG_HAS_CR));
    PJ_LOG(4,(THIS_FILE, "\n"));
    pj_log_set_decor(0);
    
    part_idx = 0;
    part_len = PJ_LOG_MAX_SIZE-80;
    while (part_idx < call_dump_len) {
        char p_orig, *p;
        
        p = &some_buf[part_idx];
        if (part_idx + part_len > call_dump_len)
            part_len = call_dump_len - part_idx;
        p_orig = p[part_len];
        p[part_len] = '\0';
        PJ_LOG(4,(THIS_FILE, "%s", p));
        p[part_len] = p_orig;
        part_idx += part_len;
    }
    pj_log_set_decor(log_decor);
}
