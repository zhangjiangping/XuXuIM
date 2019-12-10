//
//  LYAppInfoTools.h
//  MobileVoip
//
//  Created by Liu Yang on 17/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

@interface LYAppInfoTools : NSObject

+ (NSString *)phoneVersion;
+ (CGFloat)getBattery;
+ (NSString *)iphoneType;

@end
