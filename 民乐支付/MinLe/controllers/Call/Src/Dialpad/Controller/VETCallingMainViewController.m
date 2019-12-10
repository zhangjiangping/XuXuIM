//
//  VETOutgoingViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 09/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCallingMainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VETVoip.h"
#import "VETPlaySoundHelper.h"
#import "VETCallingMainView.h"
#import "VETCallRecord.h"
#import "VETDTMFView.h"
#import "VETReconnectHelper.h"
#import "VETGCDTimerHelper.h"
#import "LYCFunctionTool.h"

typedef NS_ENUM(NSUInteger, DisconnectType) {
    DisconnectTypeFailed = 0,
    DisconnectTypeInvalidateNumber = 1,
    DisconnectTypeRejected = 2,
    DisconnectTypeHangup = 3,
};

@interface VETCallingMainViewController ()<VETCallingMainViewDelegate, VETCallDelegate, VETDTMFViewDelegate>
{
    AVAudioPlayer *_audioPlayer;
    NSUInteger _seconds;

    CGFloat _initialVolume;
    CGFloat _initialMicVolume;
    
    BOOL _isExecuteEnd; // 点击hangup后，也会收到disconnect回调，不判断会调用两次。
}

@property (nonatomic, strong) VETCallingMainView *mainView;
@property (nonatomic, strong) VETDTMFView *dtmfView;

// TODO:连接断开类型
@property (nonatomic, assign) DisconnectType disconnectType;
@property (nonatomic, retain) NSTimer *callTimer;
@property (nonatomic, retain) VETCallRecord *vetNewRecord;

// A Boolean value indicating whether the receiver's call is on hold.
@property(nonatomic, assign, getter=isCallOnHold) BOOL callOnHold;
// A Boolean value indicating whether the receiver's call is unhandled.
@property(nonatomic, readonly, getter=isCallUnhandled) BOOL callUnhandled;

@property (strong, readwrite, nonatomic) dispatch_source_t qualityTimer;

@property (nonatomic, assign) NSUInteger currentQualityMs;

@end

@implementation VETCallingMainViewController

- (void)dealloc
{
    [self setCall:nil];
    if (self.qualityTimer) {
        dispatch_source_cancel(self.qualityTimer);
    }
}

# pragma mark - setup

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.dtmfView];
    
    _vetNewRecord = [VETCallRecord new];
    _mainView.phoneLabel.text = _callPhone;
    [self setupLayout];
    [self setup];
    
    if (_call == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setCall:(VETVoipCall *)call
{
    if (_call != call) {
        if (_call.delegate == self) {
            _call.delegate = nil;
        }
        _call = call;
        _call.delegate = self;
    }
}

- (void)setup {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    _vetNewRecord.callTime = [dateFormatter stringFromDate:[NSDate date]];
}

- (VETCallingMainView *)mainView
{
    if (_mainView == nil) {
        _mainView = [VETCallingMainView new];
        _mainView.delegate = self;
        _mainView.userInteractionEnabled = YES;
    }
    return _mainView;
}

- (VETDTMFView *)dtmfView
{
    if (_dtmfView == nil) {
        _dtmfView = [VETDTMFView new];
        _dtmfView.alpha = 0.0;
        _dtmfView.delegate = self;
    }
    return _dtmfView;
}

- (void)setupLayout
{
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view).offset(0);
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    [_dtmfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view).offset(0);
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

- (void)setCallPhone:(NSString *)callPhone
{
    _callPhone = callPhone;
    _mainView.phoneLabel.text = _callPhone;
}

- (void)setCurrentQualityMs:(NSUInteger)currentQualityMs
{
    _currentQualityMs = currentQualityMs;
    [_mainView.qualityLeftLabel setHidden:NO];
    [_mainView.qualityRightLabel setHidden:NO];
    [_mainView.qualityImageView setHidden:NO];
    // Excellent Quality
    if (currentQualityMs < 150) {
        self.mainView.qualityRightLabel.text = [CommenUtil LocalizedString:@"Call.Excellent"];
        self.mainView.qualityImageView.image = [UIImage imageNamed:@"quality_excellent"];
    }
    // Good Quality
    else if (currentQualityMs >= 150 && currentQualityMs < 200) {
        self.mainView.qualityRightLabel.text = [CommenUtil LocalizedString:@"Call.Good"];
        self.mainView.qualityImageView.image = [UIImage imageNamed:@"quality_good"];
    }
    // Average Quality
    else if (currentQualityMs >= 200 && currentQualityMs < 300) {
        self.mainView.qualityRightLabel.text = [CommenUtil LocalizedString:@"Call.Average"];
        self.mainView.qualityImageView.image = [UIImage imageNamed:@"quality_average"];
    }
    // Bad Quality
    else {
        self.mainView.qualityRightLabel.text = [CommenUtil LocalizedString:@"Call.Bad"];
        self.mainView.qualityImageView.image = [UIImage imageNamed:@"quality_bad"];
    }
}

#pragma mark - button event

- (void)callingMainView:(VETCallingMainView *)view tapSpeakerButton:(id)sender
{
    UIButton *speakerButton = (UIButton *)sender;
    speakerButton.selected = !speakerButton.selected;
    //  扩音器
    if (speakerButton.selected) {
        [VETPlaySoundHelper setSpeaker];
    }
    //  麦克风
    else {
        [VETPlaySoundHelper setHeadphone];
    }
}

- (void)callingMainView:(VETCallingMainView *)view tapMuteButton:(id)sender
{
    UIButton *muteButton = (UIButton *)sender;
    if ([self.call state] != kVETVoipCallConfirmedState) {
        return;
    }
    [self.call toggleMicrophoneMute];
    if ([self.call isMicrophoneMuted]) {
        muteButton.selected = YES;
        if (![self isCallOnHold]) {
            [self stopTelephonometry];
            [_mainView.muteLabel setText:[CommenUtil LocalizedString:@"Call.Mute"]];
            [_mainView.statusLabel setText:[CommenUtil LocalizedString:@"Call.Mute"]];
        }
        else {
            [_mainView.muteLabel setText:[CommenUtil LocalizedString:@"Call.Unmute"]];
        }
    }
    else {
        [self startTelephonometry];
        muteButton.selected = NO;
    }
}

- (void)callingMainView:(VETCallingMainView *)view tapHoldButton:(id)sender
{
    if (_call.state != kVETVoipCallConfirmedState) {
        return;
    }
    if (_call.isOnRemoteHold) {
        return;
    }
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    [self.call toggleHold];
    if ([self.call isOnLocalHold]) {
        button.selected = YES;
        button.selected = YES;
        if (![self isCallOnHold]) {
            [self stopTelephonometry];
            [_mainView.holdLabel setText:[CommenUtil LocalizedString:@"Call.Hold"]];
            [_mainView.statusLabel setText:[CommenUtil LocalizedString:@"Call.Hold"]];
        }
        else {
            [_mainView.holdLabel setText:[CommenUtil LocalizedString:@"Call.UnHold"]];
        }
    }
    else {
        [self startTelephonometry];
        button.selected = NO;
    }
}

- (void)callingMainView:(VETCallingMainView *)view tapVideoButton:(id)sender
{
    
}

- (void)callingMainView:(VETCallingMainView *)view tapHangupButton:(id)sender
{
//    if (self.call.ringback.isPlaying) {
//        [self.call.ringback stop];
//    }
//    [self.call end];
    if (!_isExecuteEnd) {
        [self endCallOperation];
    }
}

- (void)callingMainView:(VETCallingMainView *)view tapKeypadButton:(id)sender
{
    LYLog(@"tapKeypad...");
    [UIView animateWithDuration:0.2 animations:^{
        self.mainView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.dtmfView.alpha = 1.0;
    }];
}

- (void)callingMainView:(VETCallingMainView *)view tapMinimizeButton:(id)sender
{
    
}

#pragma mark - DTMF view delegate

- (void)DTMFView:(VETDTMFView *)view tapHangupButton:(id)sender
{
    if (!_isExecuteEnd) {
        [self endCallOperation];
    }
}

- (void)DTMFView:(VETDTMFView *)view tapHideButton:(id)sender
{
    [view hide];
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.alpha = 1.0;
   }];
}

- (void)DTMFView:(VETDTMFView *)view longPressZeroButton:(id)sender
{
    
}

- (void)DTMFView:(VETDTMFView *)view tapNumberButton:(id)sender number:(VETKeypadNumberType)numberType
{
    NSString *numberStr;
    switch (numberType) {
        case VETKeypadNumberZero: {
            numberStr = @"0";
            break;
        }
        case VETKeypadNumberOne: {
            numberStr = @"1";
            break;
        }
        case VETKeypadNumberTwo: {
            numberStr = @"2";
            break;
        }
        case VETKeypadNumberThree: {
            numberStr = @"3";
            break;
        }
        case VETKeypadNumberFour: {
            numberStr = @"4";
            break;
        }
        case VETKeypadNumberFive: {
            numberStr = @"5";
            break;
        }
        case VETKeypadNumberSix: {
            numberStr = @"6";
            break;
        }
        case VETKeypadNumberSeven: {
            numberStr = @"7";
            break;
        }
        case VETKeypadNumberEight: {
            numberStr = @"8";
            break;
        }
        case VETKeypadNumberNine: {
            numberStr = @"9";
            break;
        }
        case VETKeypadNumberStar: {
            numberStr = @"*";
            break;
        }
        case VETKeypadNumberWell: {
            numberStr = @"#";
            break;
        }
        default:
            break;
    }
    [_call sendDTMFDigits:numberStr];
}

#pragma mark - 通话时长统计
- (void)startTelephonometry
{
    if(!_callTimer) {
        self.callTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTelephonometry) userInfo:nil repeats:YES];
    }
}

- (void)stopTelephonometry
{
    if (_callTimer != nil) {
        [_callTimer invalidate];
        self.callTimer = nil;
    }
}

- (void)updateTelephonometry
{
    _seconds ++;
    NSUInteger hours = _seconds / 60 / 60;
    NSUInteger minutes = _seconds / 60;
    NSUInteger nowSeconds = _seconds % 60;
    
    if (_seconds < 3600) {
        _vetNewRecord.duration = [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)minutes, (unsigned long)nowSeconds];
    }
    else {
        _vetNewRecord.duration = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)nowSeconds];
    }
    LYLog(@"Duration: %lu:%lu:%lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)nowSeconds);
    self.mainView.statusLabel.text = _vetNewRecord.duration;
}

#pragma mark - private

- (void)endCallOperation
{
    _isExecuteEnd = YES;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    });
    
    if (_vetNewRecord.duration && _vetNewRecord.duration.length > 0 ) {
        [self.mainView endCalling:_vetNewRecord.duration];
    }
    else {
        [self.mainView endCalling:@"00:00"];
    }
    [self stopTelephonometry];
//    [self addRecord];
    self.mainView.statusLabel.text = [CommenUtil LocalizedString:@"Call.CallEnded"];
    
    [[VETVoipManager sharedManager] stopRingbackForCall:_call];
    [_call hangUp];
    if (self.qualityTimer) {
        dispatch_source_cancel(self.qualityTimer);
    }
}

#pragma mark - call delegate

- (void)VETCallEarly:(NSNotification *)notification
{
    NSLog(@"Early........");
    self.mainView.statusLabel.text = [CommenUtil LocalizedString:@"Ringing..."];
}

- (void)VETCallDidConfirm:(NSNotification *)notification
{
    NSLog(@"已连接........");
    self.mainView.statusLabel.text = [CommenUtil LocalizedString:@"Call.Connected"];
    [self startTelephonometry];
    [[VETVoipManager sharedManager] stopRingbackForCall:_call];
    
    [self queryQuality];
}

- (void)VETCallDidDisconnect:(NSNotification *)notification
{
    if (!_isExecuteEnd) {
        self.mainView.statusLabel.text = [CommenUtil LocalizedString:@"Call.Disconnected"];
        [self endCallOperation];
    }
}

- (void)VETCallCalling:(NSNotification *)notification
{
    self.mainView.statusLabel.text = [CommenUtil LocalizedString:@"Call.Disconnected"];
    NSLog(@"呼叫中........");
//    [[VETVoipManager sharedManager] startRingbackForCall:_call];
}

- (void)VETCallIncoming:(NSNotification *)notification
{
    
}

- (void)VETCallConnecting:(NSNotification *)notification
{
    self.mainView.statusLabel.text = [CommenUtil LocalizedString:@"Call.AccountConnecting"];
    NSLog(@"连接中........");
}

- (void)VETCallMediaDidBecomeActive:(NSNotification *)notification
{
    LYLog(@"VETCallMediaDidBecomeActive");
}

- (void)VETCallDidLocalHold:(NSNotification *)notification
{
    
}

- (void)VETCallDidRemoteHold:(NSNotification *)notification
{
    
}

- (void)VETCallTransferStatusDidChange:(NSNotification *)notification
{
    
}

// 480 Register
- (void)VETCallDidDisconnectWhen480:(NSNotification *)notification
{
    self.mainView.statusLabel.text = [CommenUtil LocalizedString:@"Call.TemporarilyUnavailable"];
    [VETReconnectHelper reconnectForce:YES];
}

#pragma mark - query quality
- (void)queryQuality
{
    self.qualityTimer = [VETGCDTimerHelper createGCDTimerWithInterval:5 leeway:0 queue:dispatch_get_main_queue() block:^{
        static char some_buf[1024];
        pjsua_call_dump(_call.callId, PJ_TRUE, some_buf, sizeof(some_buf), "  ");
        char ms[10];
        NSUInteger index = 0;
        int firstIndex = findChar(some_buf, "ms");
        if (firstIndex > 7) {
            for (NSUInteger i = firstIndex - 7; i < firstIndex; i++) {
                if (isNumberWithChar(some_buf[i])) {
                    ms[index] = some_buf[i];
                    index++;
                }
            }
        }
        ms[index++] = 0;
        int num = atoi(ms);
        self.currentQualityMs = num;
    }];
    dispatch_resume(self.qualityTimer);
}

@end
