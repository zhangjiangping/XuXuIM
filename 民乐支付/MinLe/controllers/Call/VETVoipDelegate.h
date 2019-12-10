//
//  VETVOIPDelegate.h
//  MobileVoip
//
//  Created by Liu Yang on 02/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

@import Foundation;

@class VETVoipAccount;

/// Protocol that must be adopted by objects that want to act as delegates of AKSIPUserAgent objects.
@protocol AKSIPUserAgentDelegate <NSObject>

@optional

/// Called when AKSIPUserAgent is about to add an account.
- (BOOL)SIPUserAgentShouldAddAccount:(VETVoipAccount *)anAccount;

// Methods to handle AKSIPUserAgent notifications to which delegate is automatically subscribed.
- (void)SIPUserAgentDidFinishStarting:(NSNotification *)notification;
- (void)SIPUserAgentDidFinishStopping:(NSNotification *)notification;
- (void)SIPUserAgentDidDetectNAT:(NSNotification *)notification;

@end
