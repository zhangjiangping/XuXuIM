//
//  VETProviderDelegate.m
//  MobileVoip
//
//  Created by Liu Yang on 24/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETProviderDelegate.h"
#import <CallKit/CallKit.h>

@interface VETProviderDelegate ()<CXProviderDelegate>

@property (nonatomic, retain) CXProvider *provider;

@end

@implementation VETProviderDelegate

- (instancetype)init
{
    if (self == [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    CXProviderConfiguration *config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"MobileVoip"];
    config.supportsVideo = YES;
    config.maximumCallGroups = 1;
    config.supportedHandleTypes = [[NSSet alloc] initWithObjects:[NSNumber numberWithInt:(int)CXHandleTypePhoneNumber], nil];
    config.maximumCallGroups = 1;
    config.maximumCallsPerCallGroup = 5;
    
    self.provider = [[CXProvider alloc] initWithConfiguration:config];
    [self.provider setDelegate:self queue:dispatch_get_main_queue()];
}

#pragma mark - public

// 通知系统收到来电，通过CXCallUpdate来传递信息。
- (void)reportIncomingCallFrom:(NSString *)from withUUID:(NSUUID *)uuid
{
    CXHandle *callHandle = [[CXHandle alloc] initWithType:CXHandleTypeGeneric value:from];
    
    // CXCallUpdate用来封装拨打者的姓名等信息
    CXCallUpdate *callUpdate = [[CXCallUpdate alloc] init];
    callUpdate.remoteHandle = callHandle;
    callUpdate.supportsDTMF = YES;
    callUpdate.supportsHolding = NO;
    callUpdate.supportsGrouping = NO;
    callUpdate.supportsUngrouping = NO;
    callUpdate.hasVideo = NO;
    
    [self.provider reportNewIncomingCallWithUUID:uuid update:callUpdate completion:^(NSError * _Nullable error) {
        if (!error) {
            LYLog(@"Incoming call successfully reported.");
        }
        else {
            LYLog(@"Failed to report incoming call successfully:%@", [error localizedDescription]);
        }
    }];
}

#pragma mark - provider state

- (void)providerDidBegin:(CXProvider *)provider
{
    
}

- (void)providerDidReset:(CXProvider *)provider
{
    LYLog(@"reset");
}

#pragma mark - AVAudioSession

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession
{
    
}

- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession
{
    
}

#pragma mark - Action

//呼叫请求成功后的回调
- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action
{
    LYLog(@"performStartCallAction");
    
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action
{
    LYLog(@"performAnswerCallAction");

    [action fulfill];
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action
{
    LYLog(@"performEndCallAction");

    [action fulfill];
}

- (void)provider:(CXProvider *)provider performSetHeldCallAction:(CXSetHeldCallAction *)action
{
    LYLog(@"performSetHeldCallAction");

}

- (void)provider:(CXProvider *)provider performPlayDTMFCallAction:(CXPlayDTMFCallAction *)action
{
    LYLog(@"performPlayDTMFCallAction");

}

- (void)provider:(CXProvider *)provider performSetGroupCallAction:(CXSetGroupCallAction *)action
{
    LYLog(@"performSetGroupCallAction");

}

- (void)provider:(CXProvider *)provider performSetMutedCallAction:(CXSetMutedCallAction *)action
{
    LYLog(@"performSetMutedCallAction");

}

- (void)provider:(CXProvider *)provider timedOutPerformingAction:(CXAction *)action
{
    LYLog(@"timedOutPerformingAction");

}

@end
