//
//  VETCallModel.h
//  VETEphone
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VETCallType) {
    VETCallTypeOutgoing = 0,
    VETCallTypeIncoming = 1,
    VETCallTypeFailed = 2,
    VETCallTypeMissed = 3,
};

typedef NS_ENUM(NSUInteger, VETNetworkType) {
    VETNetworkTypeSip = 0,
    VETNetworkTypePSTN = 1,
};

@interface VETCallRecord : NSObject

@property (nonatomic, assign) int dbId;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *account; // callPhoneNumber
@property (nonatomic, retain) NSString *callPhoneFullName; // callPhoenContactName

@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *attribution;
@property (nonatomic, retain) NSString *callTime;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, assign) VETCallType callType;
@property (nonatomic) VETNetworkType networkType;
@property (nonatomic, retain) NSString *myAccount;

@end
