//
//  VETAccount.h
//  VETEphone
//
//  Created by Liu Yang on 28/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VETEncryptionType) {
    VETEncryptionTypeRC4 = 0,
    VETEncryptionTypeSRTP = 1,
    VETEncryptionTypeNone = 2,
};

typedef NS_ENUM(NSUInteger, VETTransportType) {
    VETTransportTypeTCP = 0,
    VETTransportTypeUDP = 1,
    VETTransportTypeTLS = 2,
};

@interface VETAccount : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, assign, getter=isAutoLogin) BOOL autoLogin;
@property (nonatomic, assign) VETEncryptionType encryptionType;
@property (nonatomic, assign) VETTransportType transportType;

//@property (nonatomic, assign, getter=isVosEncryption) BOOL vosEncryption;

@end
