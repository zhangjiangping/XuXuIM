//
//  VETVoipCallbacks.h
//  MobileVoip
//
//  Created by Liu Yang on 02/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <pjsua-lib/pjsua.h>

void PJSUAOnIncomingCall(pjsua_acc_id accountID, pjsua_call_id callID, pjsip_rx_data *invite);
void PJSUAOnCallState(pjsua_call_id callID, pjsip_event *event);
void PJSUAOnCallMediaState(pjsua_call_id callID);
void PJSUAOnCallTransferStatus(pjsua_call_id callID,
                               int statusCode,
                               const pj_str_t *statusText,
                               pj_bool_t isFinal,
                               pj_bool_t *wantsFurtherNotifications);
void PJSUAOnCallReplaced(pjsua_call_id oldCallID, pjsua_call_id newCallID);
void PJSUAOnAccountRegistrationState(pjsua_acc_id accountID);
