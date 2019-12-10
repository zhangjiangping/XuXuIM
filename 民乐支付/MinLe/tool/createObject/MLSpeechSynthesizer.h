//
//  MLSpeechSynthesizer.h
//  民乐支付
//
//  Created by JP on 2017/8/1.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MLSpeechSynthesizer : NSObject
{
    AVSpeechSynthesizer * av;
    AVSpeechSynthesisVoice *voiceType;
    AVSpeechUtterance *utterance;
}

- (instancetype)initWithText:(NSString *)text;

- (void)clearSpeech;

@end
