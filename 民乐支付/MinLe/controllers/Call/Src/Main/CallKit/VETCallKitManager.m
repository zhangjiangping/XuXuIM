//
//  VETCallKitManager.m
//  MobileVoip
//
//  Created by Liu Yang on 24/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCallKitManager.h"
#import <CallKit/CallKit.h>

@interface VETCallKitManager ()

@property (nonatomic, retain) CXCallController *callController;
@property (nonatomic, retain) NSMutableArray *calls;

@end

@implementation VETCallKitManager

- (instancetype)init
{
    if (self = [super init]) {
        _callController = [[CXCallController alloc] init];
        _calls = [NSMutableArray array];
    }
    return self;
}

#pragma mark - CallKit Actions

- (void)startCallWithUUID:(NSUUID *)uuid handle:(NSString *)handle
{
    if (uuid == nil || handle == nil) {
        return;
    }
    
    CXHandle *callHandle = [[CXHandle alloc] initWithType:CXHandleTypeGeneric value:handle];
    CXStartCallAction *startCallAction = [[CXStartCallAction alloc] initWithCallUUID:uuid handle:callHandle];
    CXTransaction *transaction = [[CXTransaction alloc] initWithAction:startCallAction];
    
    [self.callController requestTransaction:transaction completion:^(NSError * _Nullable error) {
        if (error) {
            LYLog(@"StartCallAction transaction request failed:%@", [error localizedDescription]);
        }
        else {
            LYLog(@"StartCallAction transcation request successful");
        }
    }];
}

- (void)endCallWithUUID:(NSUUID *)uuid
{
    CXEndCallAction *encCallAction = [[CXEndCallAction alloc] initWithCallUUID:uuid];
    CXTransaction *transcation = [[CXTransaction alloc] initWithAction:encCallAction];
    
    [self.callController requestTransaction:transcation completion:^(NSError * _Nullable error) {
        if (error) {
            LYLog(@"EndCallAction transcation request failed:%@", [error localizedDescription]);
        }
        else {
            LYLog(@"EndCallAction transcation request successful");
        }
    }];
}

- (void)setHeldWithUUID:(NSUUID *)uuid onHold:(BOOL)onHold
{
    CXSetHeldCallAction *setHeldCallAction = [[CXSetHeldCallAction alloc] initWithCallUUID:uuid onHold:onHold];
    CXTransaction *transcation = [[CXTransaction alloc] initWithAction:setHeldCallAction];
    
    [self.callController requestTransaction:transcation completion:^(NSError * _Nullable error) {
        if (error) {
            LYLog(@"setHeldWithUUID transcation request failed:%@", [error localizedDescription]);
        }
        else {
            LYLog(@"setHeldWithUUID transcation request successful");
        }
    }];
}

- (void)addCall:(id)call
{
    
}

- (void)removeCall:(id)call
{
    
}

- (void)removeAllCalls
{
    
}

@end
