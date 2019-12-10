//
//  VETCodecInfo.h
//  MobileVoip
//
//  Created by Liu Yang on 10/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETVoipCodecInfo : NSObject

/// Codec id as given by PJSIP
@property (nonatomic, strong, readonly) NSString *codecId;

/// Codec priority in the range 1-254 or 0 to disable.
@property (nonatomic, assign, readonly) NSUInteger priority;

- (BOOL)updatePriority:(NSUInteger)newPriority;

/* Disable the codec. (Sets priority to 0) 
 */
- (BOOL)disable;

- (instancetype)initWithCodecId:(NSString *)codecId priority:(NSUInteger)priority;

@end
