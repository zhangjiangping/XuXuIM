//
//  VETCodecInfo.m
//  MobileVoip
//
//  Created by Liu Yang on 10/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETVoipCodecInfo.h"
#import <pjsip.h>
#import "NSString+VETVoipExtension.h"

@interface VETVoipCodecInfo ()

/// Codec id as given by PJSIP
@property (nonatomic, strong) NSString *codecId;

/// Codec priority in the range 1-254 or 0 to disable.
@property (nonatomic, assign) NSUInteger priority;

@end

@implementation VETVoipCodecInfo

- (instancetype)initWithCodecId:(NSString *)codecId priority:(NSUInteger)priority
{
    if (self = [super init]) {
        _codecId = codecId;
        _priority = priority;
    }
    return self;
}

- (BOOL)updatePriority:(NSUInteger)newPriority
{
    pj_str_t codecId = [_codecId pjString];
    pj_status_t status = pjsua_codec_set_priority(&codecId, newPriority);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error setting codec(%@) priority to the %d value", _codecId, newPriority);
    }
    return YES;
}

- (BOOL)disable
{
    pj_str_t codecId = [_codecId pjString];
    pj_status_t status = pjsua_codec_set_priority(&codecId, 0);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error setting codec(%@) priority to disable", _codecId);
    }
    return YES;
}

@end
