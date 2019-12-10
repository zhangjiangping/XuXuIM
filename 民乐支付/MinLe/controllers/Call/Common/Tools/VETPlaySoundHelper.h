//
//  DYXPlaySoundHelper.h
//  DunyunLock
//
//  Created by young on 16/6/1.
//  Copyright © 2016年 duyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVAudioPlayer;
typedef NS_ENUM(NSUInteger, VETPlaySoundHelperType) {
    VETPlaySoundHelperTypeBeep1s,
    VETPlaySoundHelperTypeBeep4s,
    VETPlaySoundHelperTypeWell,
    VETPlaySoundHelperTypeZero,
    VETPlaySoundHelperTypeOne,
    VETPlaySoundHelperTypeTwo,
    VETPlaySoundHelperTypeThree,
    VETPlaySoundHelperTypeFour,
    VETPlaySoundHelperTypeFive,
    VETPlaySoundHelperTypeSix,
    VETPlaySoundHelperTypeSeven,
    VETPlaySoundHelperTypeEight,
    VETPlaySoundHelperTypeNine,
    VETPlaySoundHelperTypeStar,
};

typedef NS_ENUM(NSUInteger, VETPlaySoundHelperLoopPlaybackType) {
    VETPlaySoundHelperLoopPlaybackTypeRingback,  //  呼叫声
    VETPlaySoundHelperLoopPlaybackTypeRing,  //  铃声
};

@interface VETPlaySoundHelper : NSObject

+ (void)playSoundWithType:(VETPlaySoundHelperType)type;

//  需要自己释放
+ (AVAudioPlayer *)loopPlaybackWithType:(VETPlaySoundHelperLoopPlaybackType)type;

//  需要自己释放
+ (NSTimer *)playVibrateConstantly;

+ (void)setSpeaker;

+ (void)setHeadphone;

@end
