//
//  DYXPlaySoundHelper.m
//  DunyunLock
//
//  Created by young on 16/6/1.
//  Copyright © 2016年 duyun. All rights reserved.
//

#import "VETPlaySoundHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation VETPlaySoundHelper

+ (void)playSoundWithType:(VETPlaySoundHelperType)type
{
    BOOL isMp3Flag = NO;
    NSString *soundName;
    switch (type) {
        case VETPlaySoundHelperTypeBeep1s:{
            soundName = @"beepbeep1s";
            break;
        }
        case VETPlaySoundHelperTypeBeep4s:{
            soundName = @"beepbeep4s";
            break;
        }
        case VETPlaySoundHelperTypeZero:{
            soundName = @"dtmf-0";
            break;
        }
        case VETPlaySoundHelperTypeOne:{
            soundName = @"dtmf-1";
            break;
        }
        case VETPlaySoundHelperTypeTwo:{
            soundName = @"dtmf-2";
            break;
        }
        case VETPlaySoundHelperTypeThree:{
            soundName = @"dtmf-3";
            break;
        }
        case VETPlaySoundHelperTypeFour:{
            soundName = @"dtmf-4";
            break;
        }
        case VETPlaySoundHelperTypeFive:{
            soundName = @"dtmf-5";
            break;
        }
        case VETPlaySoundHelperTypeSix:{
            soundName = @"dtmf-6";
            break;
        }
        case VETPlaySoundHelperTypeSeven:{
            soundName = @"dtmf-7";
            break;
        }
        case VETPlaySoundHelperTypeEight:{
            soundName = @"dtmf-8";
            break;
        }
        case VETPlaySoundHelperTypeNine:{
            soundName = @"dtmf-9";
            break;
        }
        case VETPlaySoundHelperTypeStar:{
            soundName = @"dtmf-s";
            break;
        }
        case VETPlaySoundHelperTypeWell:{
            soundName = @"dtmf-well";
            break;
        }
        default:
            break;
    }
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundName ofType:isMp3Flag?@"mp3":@"wav"];
    NSURL *soundURL = [NSURL URLWithString:soundFilePath];
    NSError *error;
    __block AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    if (error) {
        LYLog(@"Could not play beep file.");
        LYLog(@"%@", [error localizedDescription]);
    }
    else{
        [audioPlayer prepareToPlay];
    }
    [audioPlayer play];
    
    CGFloat second = audioPlayer.duration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [audioPlayer stop];
        audioPlayer = nil;
    });
}

+ (AVAudioPlayer *)loopPlaybackWithType:(VETPlaySoundHelperLoopPlaybackType)type
{
    NSString *soundFilePath;
    switch (type) {
        case VETPlaySoundHelperLoopPlaybackTypeRing:{
            soundFilePath = [[NSBundle mainBundle] pathForResource:@"adrianro_09b" ofType:@"mp3"];
            break;
        }
        case VETPlaySoundHelperLoopPlaybackTypeRingback:{
            soundFilePath = [[NSBundle mainBundle] pathForResource:@"dudu" ofType:@"wav"];
            break;
        }
        default:
            break;
    }
    NSURL *soundURL = [NSURL URLWithString:soundFilePath];
    NSError *error;
    __block AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    if (error) {
        LYLog(@"Could not play dudu file.");
        LYLog(@"%@", [error localizedDescription]);
    }
    else{
        [audioPlayer prepareToPlay];
    }
    [audioPlayer play];
    audioPlayer.numberOfLoops = 100;
    CGFloat second = audioPlayer.duration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [audioPlayer stop];
        audioPlayer = nil;
    });
    return audioPlayer;
}

+ (NSTimer *)playVibrateConstantly
{
    [self playVibrateOnce];
    NSTimer *vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(playVibrateOnce) userInfo:nil repeats:YES];
    return vibrateTimer;
}

+ (void)playVibrateOnce {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+ (void)setSpeaker {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
}

+ (void)setHeadphone {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
}

@end
