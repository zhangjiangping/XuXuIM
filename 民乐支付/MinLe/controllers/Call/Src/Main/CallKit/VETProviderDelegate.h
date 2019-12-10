//
//  VETProviderDelegate.h
//  MobileVoip
//
//  Created by Liu Yang on 24/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETProviderDelegate : NSObject

- (void)reportIncomingCallFrom:(NSString *)from withUUID:(NSUUID *)uuid;

@end
