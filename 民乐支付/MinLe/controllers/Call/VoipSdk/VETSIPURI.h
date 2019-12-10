//
//  VETSIPURI.h
//  MobileVoip
//
//  Created by Liu Yang on 02/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETSIPURI : NSObject

// SIP address in the form |user@host| or |host|.
@property(nonatomic, readonly, copy) NSString *remoteUri;

// The receiver's display-name part.
@property(nonatomic, copy) NSString *displayName;

// The receiver's user part.
@property(nonatomic, copy) NSString *user;

// The receiver's password part.
@property(nonatomic, copy) NSString *password;

// The receiver's host part. Must not be nil.
@property(nonatomic, copy) NSString *host;

// The receiver's host part. Must not be nil.
@property(nonatomic, copy) NSString *address;

// The receiver's user parameter.
@property(nonatomic, copy) NSString *userParameter;

// The receiver's method parameter.
@property(nonatomic, copy) NSString *methodParameter;

// The receiver's transport parameter.
@property(nonatomic, copy) NSString *transportParameter;

// The receiver's TTL parameter.
@property(nonatomic, assign) NSInteger TTLParameter;

// The receiver's loose routing parameter.
@property(nonatomic, assign) NSInteger looseRoutingParameter;

// The receiver's maddr parameter.
@property(nonatomic, copy) NSString *maddrParameter;

// The receiver's port part.
@property(nonatomic, assign) NSInteger port;

// Creates and returns AKSIPURI object initialized with a specified user, host, and display name.
+ (instancetype)SIPURIWithUser:(NSString *)aUser host:(NSString *)aHost displayName:(NSString *)aDisplayName;

// Creates and returns AKSIPURI object initialized with a provided string.
+ (instancetype)SIPURIWithString:(NSString *)SIPURIString;

- (instancetype)initWithRemoteUri:(NSString *)remoteUri displayName:(NSString *)aDisplayName;

- (instancetype)initWithUser:(NSString *)aUser host:(NSString *)aHost displayName:(NSString *)aDisplayName;

@end
