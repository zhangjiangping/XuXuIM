//
//  PJSUAOnCallTransferStatus.m
//  MobileVoip
//
//  Created by Liu Yang on 03/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETVoipCallbacks.h"
#import "NSString+VETVoipExtension.h"

#define THIS_FILE "PJSUAOnCallMediaState.m"


#define THIS_FILE "PJSUAOnCallTransferStatus.m"

void PJSUAOnCallTransferStatus(pjsua_call_id callID,
                               int statusCode,
                               const pj_str_t *statusText,
                               pj_bool_t isFinal,
                               pj_bool_t *wantsFurtherNotifications) {
    PJ_LOG(3, (THIS_FILE, "Call %d: transfer status=%d (%.*s) %s",
               callID, statusCode,
               (int)statusText->slen, statusText->ptr,
               (isFinal ? "[final]" : "")));
    if (statusCode / 100 == 2) {
        PJ_LOG(3, (THIS_FILE, "Call %d: call transfered successfully, disconnecting call", callID));
        pjsua_call_hangup(callID, PJSIP_SC_GONE, NULL, NULL);
        *wantsFurtherNotifications = PJ_FALSE;
    }
    NSString *statusTextString = [NSString stringWithPJString:*statusText];
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}
