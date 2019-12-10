//
//  VETReconnectHelper.h
//  MobileVoip
//
//  Created by Liu Yang on 19/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETReconnectHelper : NSObject

/*
 * forceConnect强制重连接，否则已连接状态不会重连.
 */
+ (void)reconnectForce:(BOOL)forceConnect;

@end
