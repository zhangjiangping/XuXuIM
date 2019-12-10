//
//  VETGCDTimerHelper.h
//  MobileVoip
//
//  Created by Liu Yang on 16/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETGCDTimerHelper : NSObject

+ (dispatch_source_t)createGCDTimerWithInterval:(NSUInteger)interval leeway:(NSUInteger)leeway queue:(dispatch_queue_t)queue block:(dispatch_block_t)block;

@end
