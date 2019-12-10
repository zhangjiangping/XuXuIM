//
//  VETCallingViewController.m
//  VETEphone
//
//  Created by young on 18/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETOutgoingCallingViewController.h"
#import "VETCallingMainView.h"
#import "VETPlaySoundHelper.h"
#import "DBUtil.h"
#import "VETUserManager.h"
#import <AVFoundation/AVFoundation.h>
#import "VETVoip.h"
#import "VETCallRecord.h"
#import "DBUtil.h"
#import "VETAddContactRecordHelper.h"

typedef NS_ENUM(NSUInteger, DisconnectType) {
    DisconnectTypeFailed = 0,
    DisconnectTypeInvalidateNumber = 1,
    DisconnectTypeRejected = 2,
    DisconnectTypeHangup = 3,
};

@interface VETOutgoingCallingViewController ()<VETCallingMainViewDelegate, VETCallDelegate>
{
//    GSCall *_call;
    AVAudioPlayer *_audioPlayer;
    NSUInteger _seconds;
    
    CGFloat _initialVolume;
    CGFloat _initialMicVolume;
    
    BOOL _isExecuteEnd; // 点击hangup后，也会收到disconnect回调，不判断会调用两次。
}

@end

@implementation VETOutgoingCallingViewController

- (void)dealloc {

    [self setCall:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    // 没有call就返回
    if (self.call == nil) {
        [self endCallOperation];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 新增通话记录到database
- (void)addRecord {
    VETCallRecord *record = [[DBUtil sharedManager] queryContactByAccount:self.callPhone withAccount:[[VETUserManager sharedInstance] currentUsername]];
    if (record.name) {
        self.vetNewRecord.name = record.name;
    }
    else {
        self.vetNewRecord.name = @"";
    }
    self.vetNewRecord.callType = VETCallTypeOutgoing;
    self.vetNewRecord.account = self.callPhone;
    self.vetNewRecord.attribution = @"";
    self.vetNewRecord.networkType = VETNetworkTypeSip;
    self.vetNewRecord.myAccount = [[VETUserManager sharedInstance] currentUsername];
    
    [VETAddContactRecordHelper insertRecentContactsRecord:self.vetNewRecord];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VETHistoryViewControllerRefreshHistoryNotification object:nil];
}   

#pragma mark - CallingMainViewController method
- (void)endCallOperation
{
    [super endCallOperation];
    [self addRecord];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
