//
//  VETReconnectHelper.m
//  MobileVoip
//
//  Created by Liu Yang on 19/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETReconnectHelper.h"
#import "VETVoip.h"

@implementation VETReconnectHelper

+ (void)reconnectForce:(BOOL)forceConnect
{
    VETVoipAccount *voipAccount = [[VETVoipManager sharedManager] accountWithUsername:[[VETUserManager sharedInstance] currentUsername]];
    if (!voipAccount.registered) {
        NSLog(@"register no");
        [voipAccount setRegistered:YES];
    }
    else if (forceConnect){
        [voipAccount setRegistered:NO];
        [voipAccount setRegistered:YES];
        NSLog(@"force Connect");
    }
    else {
        NSLog(@"register yes");
    }
}

@end
