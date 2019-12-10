//
//  PJSUAOnCallReplaced.m
//  MobileVoip
//
//  Created by Liu Yang on 03/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETVoipCallbacks.h"

#define THIS_FILE "PJSUAOnCallReplaced.m"

void PJSUAOnCallReplaced(pjsua_call_id oldCallID, pjsua_call_id newCallID) {
    pjsua_call_info oldCallInfo, newCallInfo;
    pjsua_call_get_info(oldCallID, &oldCallInfo);
    pjsua_call_get_info(newCallID, &newCallInfo);
    
    PJ_LOG(3, (THIS_FILE, "Call %d with %.*s is being replaced by call %d with %.*s",
               oldCallID,
               (int)oldCallInfo.remote_info.slen, oldCallInfo.remote_info.ptr,
               newCallID,
               (int)newCallInfo.remote_info.slen, newCallInfo.remote_info.ptr));
    
    NSInteger accountIdentifier = newCallInfo.acc_id;
    dispatch_async(dispatch_get_main_queue(), ^{
        PJ_LOG(3, (THIS_FILE, "Creating AKSIPCall for call %d from replaced callback", newCallID));
        
    });
}
