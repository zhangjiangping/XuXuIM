//
//  SoundUtil.h
//  XMPPWrapper
//
//  Created by Jay on 03/05/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundUtil : NSObject

//播放系统铃声
- (void)playSound;

- (void)clearSound;

+ (SoundUtil *)sharedInstance;

- (void)playSoundWithName:(NSString *)name withSelectedName:(NSString *)selectedName withType:(NSString *)type withVibrate:(BOOL)isServicesVibrate;

@end
