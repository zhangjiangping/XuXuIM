//
//  VETAddContactRecordHelper.h
//  MobileVoip
//
//  Created by Liu Yang on 17/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VETCallRecord;

@interface VETAddContactRecordHelper : NSObject

+ (void)insertRecentContactsRecord:(VETCallRecord *)record;

@end
