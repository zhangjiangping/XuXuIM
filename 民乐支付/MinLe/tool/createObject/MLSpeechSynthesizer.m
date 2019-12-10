//
//  MLSpeechSynthesizer.m
//  民乐支付
//
//  Created by JP on 2017/8/1.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "MLSpeechSynthesizer.h"

@implementation MLSpeechSynthesizer

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        //初始化语音播报
        av = [[AVSpeechSynthesizer alloc] init];
        //设置语言类别
        NSString * preferredLang = [CommenUtil getLanguage];
        if (preferredLang && preferredLang.length > 0) {
            voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:preferredLang];
        } else {
            voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        }
        //设置播报的内容
        utterance = [[AVSpeechUtterance alloc] initWithString:text];
        utterance.voice = voiceType;
        //设置播报语速
        utterance.rate = 0.001;
        [av speakUtterance:utterance];
    }
    return self;
}

- (void)clearSpeech
{
    av = nil;
    voiceType = nil;
    utterance = nil;
}


@end
