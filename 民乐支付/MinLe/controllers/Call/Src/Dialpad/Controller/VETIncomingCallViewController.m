//
//  VETIncomingCallViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 07/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETIncomingCallViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VETPlaySoundHelper.h"
#import "VETVoip.h"
#import "VETCallRecord.h"
#import "DBUtil.h"
#import "NSNotificationCenter+LYXExtension.h"
#import "VETCallingMainView.h"
#import "VETAddContactRecordHelper.h"

@interface VETIncomingCallViewController ()
{
    __block AVAudioPlayer *_player;
    __block NSTimer *_vibrateTimer;
    BOOL _handledIncoming;  //  已处理来电标识
}

@property (nonatomic, retain) UIButton *answerBtn;

@end

@implementation VETIncomingCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _player = [VETPlaySoundHelper loopPlaybackWithType:VETPlaySoundHelperLoopPlaybackTypeRing];
    
    [self setupSubViews];
    [self setupSubLayout];
    self.mainView.phoneLabel.text = self.call.remoteURI.user;
    self.mainView.statusLabel.text = [CommenUtil LocalizedString:@"Ringing..."];
    [self.call sendRingingNotification];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupSubViews
{
    _answerBtn = [UIButton new];
    [_answerBtn addTarget:self action:@selector(tapAnswerButton:) forControlEvents:UIControlEventTouchUpInside];
    [_answerBtn setImage:[UIImage imageNamed:@"answer"] forState:UIControlStateNormal];
    [_answerBtn setImage:[UIImage imageNamed:@"answer_ended"] forState:UIControlStateSelected];
    [self.mainView.bottomContainer addSubview:_answerBtn];
    self.mainView.centerContainer.alpha = 0.0;
}

- (void)setupSubLayout
{
    CGFloat padding = 30.0;
    
    [self.mainView.hangupButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainView.bottomContainer).mas_offset(padding);
        make.bottom.mas_equalTo(self.mainView.bottomContainer).offset(-padding);
        make.width.mas_equalTo(self.mainView.hangupButton.mas_height);
        make.height.mas_equalTo(self.mainView.bottomContainer.mas_height).multipliedBy(0.5);
    }];

    [self.answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainView.bottomContainer).mas_offset(-padding);
        make.bottom.mas_equalTo(self.mainView.bottomContainer).offset(-padding);
        make.width.mas_equalTo(self.answerBtn.mas_height);
        make.height.mas_equalTo(self.mainView.bottomContainer.mas_height).multipliedBy(0.5);
    }];
}

#pragma mark - private

- (void)tapAnswerButton:(id)sender
{
    _handledIncoming = YES;
    [_vibrateTimer invalidate];
    _vibrateTimer = nil;
    [_player stop];
    _player = nil;
    [self.call answer];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.centerContainer.alpha = 1.0;
        self.answerBtn.alpha = 0.0;
    }];
    
    [self.mainView.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mainView);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.mainView layoutIfNeeded];
    }];
}

// TODO:区分开是主动挂断，还是被动挂断。
- (void)endCallOperation
{
    [super endCallOperation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    self.answerBtn.selected = YES;
    [self cancelAnswerPhone:_player vibrateTimer:_vibrateTimer incomingPhone:self.call.remoteURI.user];
}

- (void)cancelAnswerPhone:(AVAudioPlayer *)player vibrateTimer:(NSTimer *)vibrateTimer incomingPhone:(NSString *)incomingPhone{
    [player stop];
    player = nil;
    [vibrateTimer invalidate];
    [self.call hangUp];
    self.call = nil;
    [self addMissedRecord:incomingPhone];
}

- (void)addMissedRecord:(NSString *)callPhone {
    if (!(callPhone.length > 0))  return;
    VETCallRecord *record = [VETCallRecord new];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    record.callTime = [dateFormatter stringFromDate:[NSDate date]];
    record.callType = VETCallTypeMissed;
    record.account = callPhone;
    record.attribution = @"";
    record.networkType = VETNetworkTypeSip;
    record.myAccount = [[VETUserManager sharedInstance] currentUsername];
    
    [VETAddContactRecordHelper insertRecentContactsRecord:record];
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThread:[[NSNotification alloc] initWithName:VETHistoryViewControllerRefreshHistoryNotification object:nil userInfo:nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
