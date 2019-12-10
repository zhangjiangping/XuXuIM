//
//  VETCallingMainView.m
//  VETEphone
//
//  Created by young on 18/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETCallingMainView.h"

#define TEXTCOLOR_UNSELECT RGBCOLOR(173, 180, 174)
#define TEXTCOLOR_SELECTED RGBCOLOR(255, 255, 255)

#define BACKGROUND_COLOR_END RGBCOLOR(0x06, 0x21, 0x36)

@interface VETCallingMainView ()

/*
 *   topContainer
 */
@property (nonatomic, retain) UIView *topContainer;
@property (nonatomic, retain) UIImageView *avatar;

/* call time label */

@property (nonatomic, retain) UILabel *callTimeLabel;

@end

@implementation VETCallingMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor = RGBCOLOR(0x07, 0x7d, 0xb4);
    
    /*
     *   topContainer
     */
    _topContainer = [UIView new];
    [self addSubview:_topContainer];
    
    _avatar  = [UIImageView new];
    [_topContainer addSubview:_avatar];
    _avatar.image = [UIImage imageNamed:@"calling_default_avatar"];
    _avatar.contentMode = UIViewContentModeScaleAspectFit;
    
    _qualityLeftLabel = [UILabel new];
    _qualityLeftLabel.textColor = [UIColor whiteColor];
    _qualityLeftLabel.textAlignment = NSTextAlignmentCenter;
    _qualityLeftLabel.text = [CommenUtil LocalizedString:@"Call.NetworkQuality"];
    _qualityLeftLabel.font = [UIFont systemFontOfSize:14.0];
    [_topContainer addSubview:_qualityLeftLabel];
    [_qualityLeftLabel setHidden:YES];
    
    _qualityImageView = [UIImageView new];
    _qualityImageView.image = [UIImage imageNamed:@"quality_excellent"];
    [_topContainer addSubview:_qualityImageView];
    [_qualityImageView setHidden:YES];
    
    _qualityRightLabel = [UILabel new];
    _qualityRightLabel.textColor = [UIColor whiteColor];
    _qualityRightLabel.textAlignment = NSTextAlignmentCenter;
    _qualityRightLabel.font = [UIFont systemFontOfSize:14.0];
    [_topContainer addSubview:_qualityRightLabel];
    [_qualityRightLabel setHidden:YES];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont systemFontOfSize:30.0];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    [_topContainer addSubview:_phoneLabel];

    _statusLabel = [UILabel new];
    [_topContainer addSubview:_statusLabel];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.text = [CommenUtil LocalizedString:@"Calling..."];
    _statusLabel.font = [UIFont systemFontOfSize:16.0];
    
    /*
     *   centerContainer
     */
    _centerContainer = [UIView new];
    [self addSubview:_centerContainer];
    
    //  Firstrow
    _centerFirstRowView = [UIView new];
    [_centerContainer addSubview:_centerFirstRowView];
    
    //  Mute
    _muteView = [UIView new];
    _muteButton = [self creatButtonWithMainView:_muteView disabledImageName:@"mute_ended" selectedImageName:@"mute_selected" normalImageName:@"mute_unselect" sel:@selector(tapMuteButton:)];
    _muteLabel = [self createLabelWithMainView:_muteView text:[CommenUtil LocalizedString:@"Call.Mute"]];
    _muteButton.enabled = YES;
    [_centerFirstRowView addSubview:_muteView];

    // Speaker
    _speakerView = [UIView new];
    _speakerButton = [self creatButtonWithMainView:_speakerView disabledImageName:@"speaker_ended" selectedImageName:@"speaker_selected" normalImageName:@"speaker_unselect" sel:@selector(tapSpeakerButton:)];
    _speakerLabel = [self createLabelWithMainView:_speakerView text:[CommenUtil LocalizedString:@"Call.Speaker"]];
    [_centerFirstRowView addSubview:_speakerView];

    //  Keypad
    _keypadView = [UIView new];
    _keypadButton = [self creatButtonWithMainView:_keypadView disabledImageName:@"keypad_ended" selectedImageName:@"keypad_selected" normalImageName:@"keypad_unselect" sel:@selector(tapKeypadButton:)];
    _keypadLabel = [self createLabelWithMainView:_keypadView text:[CommenUtil LocalizedString:@"Call.Dialpad"]];
    _keypadButton.enabled = YES;
    [_centerFirstRowView addSubview:_keypadView];
    
    /*
     *   bottomContainer
     */
    _bottomContainer = [UIView new];
    [self addSubview:_bottomContainer];
    _hangupButton = [UIButton new];
    [_bottomContainer addSubview:_hangupButton];
    [_hangupButton addTarget:self action:@selector(tapHangupButton:) forControlEvents:UIControlEventTouchUpInside];
    [_hangupButton setImage:[UIImage imageNamed:@"hangup"] forState:UIControlStateNormal];
    [_hangupButton setImage:[UIImage imageNamed:@"hangup_ended"] forState:UIControlStateSelected];

    _callTimeLabel = [UILabel new];
    _callTimeLabel.textColor = [UIColor whiteColor];
    _callTimeLabel.font = [UIFont systemFontOfSize:90];
    _callTimeLabel.alpha = 0.0;
    [self addSubview:_callTimeLabel];
}

- (UIButton *)creatButtonWithMainView:(UIView *)mainView disabledImageName:(NSString *)disabledName selectedImageName:(NSString *)selectedName normalImageName:(NSString *)normalName sel:(SEL)sel
{
    UIButton *button = [UIButton new];
    [mainView addSubview:button];
    [button setImage:[UIImage imageNamed:disabledName] forState:UIControlStateDisabled];
    [button setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)createLabelWithMainView:(UIView *)mainView text:(NSString *)text
{
    UILabel *label = [UILabel new];
    [mainView addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.text = text;
    return label;
}

- (void)setupLayouts
{
    CGFloat padding = 30.0;
    
//    CGFloat muteViewW = (SCREEN_WIDTH - padding * 2) / 3;
//    CGFloat muteViewH = muteViewW + 30;
    
    /*
     *   topContainer
     */
    [_topContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.4);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topContainer).mas_offset(40.0);
        make.left.and.right.mas_equalTo(_topContainer);
        make.centerX.mas_equalTo(_topContainer);
        make.height.mas_equalTo(@25);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(_topContainer);
    }];
    
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_topContainer);
        make.top.mas_equalTo(_statusLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(_topContainer).multipliedBy(0.4);
//        make.bottom.mas_equalTo(_topContainer).mas_offset(-10);
        make.width.mas_equalTo(_avatar.mas_height);
    }];
    
    [_qualityLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_topContainer.mas_centerX);
        make.top.mas_equalTo(_avatar.mas_bottom).mas_offset(10);
    }];
    
    [_qualityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_qualityLeftLabel);
        make.left.mas_equalTo(_qualityLeftLabel.mas_right).mas_offset(5);
        make.width.and.height.mas_equalTo(@20);
    }];
    
    [_qualityRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_qualityLeftLabel);
        make.left.mas_equalTo(_qualityImageView.mas_right).mas_offset(5);
    }];
    
    /*
     *   centerContainer
     */
    [_centerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self).offset(0);
        make.centerY.mas_equalTo(self).mas_offset(20.0);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.2);
    }];
    
    //  First row
    [_centerFirstRowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_centerContainer).offset(padding);
        make.top.and.bottom.mas_equalTo(_centerContainer).offset(0);
        make.right.mas_equalTo(_centerContainer).offset(-padding);
    }];
    
    //  Mute
    [_muteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(_centerFirstRowView).offset(0);
    }];
    
    [_muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_muteView);
        make.centerX.mas_equalTo(_muteView.mas_centerX);
        make.height.mas_equalTo(_muteView.mas_height).multipliedBy(0.6);
        make.width.mas_equalTo(_muteButton.mas_height);
    }];
    
    [_muteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_muteButton.mas_bottom).offset(5).priorityHigh();
//        make.bottom.mas_equalTo(_muteView.mas_bottom).offset(-5).priorityHigh();
        make.centerX.mas_equalTo(_muteButton.mas_centerX);
    }];
    
    //  Keyboard
    [_keypadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_muteView.mas_right).offset(0);
        make.top.and.bottom.mas_equalTo(_centerFirstRowView).offset(0);
        make.width.mas_equalTo(_muteView);
    }];
    
    [_keypadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_keypadView);
        make.centerX.mas_equalTo(_keypadView.mas_centerX);
        make.width.and.height.mas_equalTo(_muteButton);
    }];
    
    [_keypadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_keypadButton.mas_bottom).offset(5).priorityHigh();
        make.centerX.mas_equalTo(_keypadButton.mas_centerX);
    }];
    
    //  Speaker
    [_speakerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_keypadView.mas_right).offset(0);
        make.top.and.bottom.and.right.mas_equalTo(_centerFirstRowView).offset(0);
        make.width.mas_equalTo(_keypadView);
    }];
    
    [_speakerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_speakerView);
        make.centerX.mas_equalTo(_speakerView.mas_centerX);
        make.width.and.height.mas_equalTo(_muteButton);
    }];
    
    [_speakerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_speakerButton.mas_bottom).offset(5).priorityHigh();
        make.centerX.mas_equalTo(_speakerButton.mas_centerX);
    }];
    
    /*
     *   bottomContainer
     */
    [_bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_centerContainer.mas_bottom).offset(0);
        make.left.and.right.and.bottom.mas_equalTo(self).offset(0);
//        make.height.mas_equalTo(_topContainer.mas_height);
    }];
    [_hangupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomContainer.mas_centerX);
        make.bottom.mas_equalTo(_bottomContainer).offset(-padding);
        make.width.mas_equalTo(_hangupButton.mas_height);
        make.height.mas_equalTo(_bottomContainer.mas_height).multipliedBy(0.5);
    }];
    
    [_callTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(self);
    }];
}

- (void)tapMuteButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(callingMainView:tapMuteButton:)]) {
        [self.delegate callingMainView:self tapMuteButton:sender];
    }
}

- (void)tapVideoButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(callingMainView:tapMuteButton:)]) {
        [self.delegate callingMainView:self tapMuteButton:sender];
    }
}

- (void)tapSpeakerButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(callingMainView:tapSpeakerButton:)]) {
        [self.delegate callingMainView:self tapSpeakerButton:sender];
    }
}

- (void)tapHoldButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(callingMainView:tapHoldButton:)]) {
        [self.delegate callingMainView:self tapHoldButton:sender];
    }
}

- (void)tapMinimizeButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(callingMainView:tapMinimizeButton:)]) {
        [self.delegate callingMainView:self tapMinimizeButton:sender];
    }
}

- (void)tapKeypadButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(callingMainView:tapKeypadButton:)]) {
        [self.delegate callingMainView:self tapKeypadButton:sender];
    }
}

- (void)tapHangupButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(callingMainView:tapHangupButton:)]) {
        [self.delegate callingMainView:self tapHangupButton:sender];
    }
}

- (void)setSelect:(BOOL)select btn:(UIButton *)button label:(UILabel *)label
{
    button.selected = select;
    label.textColor = select ? TEXTCOLOR_SELECTED : TEXTCOLOR_UNSELECT;
}

- (void)endCalling:(NSString *)callTime
{
    self.backgroundColor = BACKGROUND_COLOR_END;
    _callTimeLabel.text = callTime;
    [UIView animateWithDuration:0.5 animations:^{
        _centerContainer.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _callTimeLabel.alpha = 1.0;
        }];
    }];
    _hangupButton.selected = YES;
    _phoneLabel.alpha = 0.2;
    _statusLabel.alpha = 0.2;
    _avatar.image = [UIImage imageNamed:@"calling_default_avatar_hangup"];
    _qualityRightLabel.textColor = [UIColor lightGrayColor];
    _qualityLeftLabel.textColor = [UIColor lightGrayColor];
}

@end
