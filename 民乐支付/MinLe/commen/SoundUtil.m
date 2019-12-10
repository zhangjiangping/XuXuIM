

//
//  SoundUtil.m
//  FlyChat
//
//  Created by SZVetron on 13/2/17.
//  Copyright © 2017年 SZVetron. All rights reserved.
//

#import "SoundUtil.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundUtil ()
{
    SystemSoundID soundID;
}
@end

@implementation SoundUtil

- (void)playSound
{
//    //这里使用在上面那个网址找到的铃声，注意格式  new-mail sms-received1
//    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received3",@"caf"];
    
    soundID = kSystemSoundID_Vibrate;
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"wav.bundle"]];
    NSBundle *bundle =  [NSBundle bundleWithPath:bundlePath];//;[NSBundle mainBundle]
    NSString *path = [bundle pathForResource:@"remark" ofType:@"mp3"];
    
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {
            soundID = 0;
        }
    } else {
        [self clearSound];
    }
    AudioServicesPlaySystemSound(soundID);//播放声音
}

- (void)playSoundWithName:(NSString *)name withSelectedName:(NSString *)selectedName withType:(NSString *)type withVibrate:(BOOL)isServicesVibrate
{
    soundID = kSystemSoundID_Vibrate;
    //   NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle",name]];
    NSBundle *bundle =  [NSBundle mainBundle];//[NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:selectedName ofType:type];
    
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
        if (error != kAudioServicesNoError) {
            soundID = 0;
        }
    }
    
    AudioServicesPlaySystemSound(soundID);//播放声音
    
    if (isServicesVibrate) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//静音模式下震动
    }
}

- (void)clearSound
{
    if (soundID != 0) {
        
        //移除系统播放完成后的回调函数
        
        AudioServicesRemoveSystemSoundCompletion(soundID);
        
        //销毁创建的SoundID
        
        AudioServicesDisposeSystemSoundID(soundID);
        
        soundID = 0;
        
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (SoundUtil *)sharedInstance
{
    static SoundUtil *soundUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        soundUtil = [[SoundUtil alloc] init];
    });
    return soundUtil;
}

@end








