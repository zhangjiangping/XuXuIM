//
//  VETGCDTimerHelper.m
//  MobileVoip
//
//  Created by Liu Yang on 16/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETGCDTimerHelper.h"
#import <objc/runtime.h>

@implementation VETGCDTimerHelper

+ (dispatch_source_t)createGCDTimerWithInterval:(NSUInteger)interval leeway:(NSUInteger)leeway queue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval * NSEC_PER_SEC, leeway * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, block);
    }
    return timer;
}

@end
