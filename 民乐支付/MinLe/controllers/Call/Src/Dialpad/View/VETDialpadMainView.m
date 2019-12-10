//
//  VETDiadadMainView.m
//  VETEphone
//
//  Created by young on 17/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETDialpadMainView.h"
#import "VETDialpadButton.h"
#import "pop.h"
#import "VETCountry.h"

#define kNumberColor RGBCOLOR(69, 69, 69)
#define kPayLableColor RGBCOLOR(0xfd, 0xd4, 0x27)

@interface VETDialpadMainView ()<POPAnimationDelegate, UITextFieldDelegate>
{
    BOOL _changeFlag;
    BOOL _isLoosenDeleteBtn;
    float callWH;
}

@property (strong, readwrite, nonatomic) dispatch_source_t dispatchSource;

@end

@implementation VETDialpadMainView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        callWH = 64;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            callWH = 50;
        }
        
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

#pragma mark - events

- (void)startAnimation:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.transform = CGAffineTransformMakeScale(0.85, 0.85); //先缩小
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        btn.transform = CGAffineTransformIdentity;//恢复原状
    } completion:^(BOOL finished) {
    }];
}

- (void)startCallAnimation
{
    self.callButton.transform = CGAffineTransformMakeScale(1.15, 1.15); //先缩小
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.callButton.transform = CGAffineTransformIdentity;//恢复原状
    } completion:^(BOOL finished) {
        
    }];
}

- (void)pop_animationDidReachToValue:(POPAnimation *)anim
{
    
}

- (void)tapNumberButton:(id)sender
{
    [self startAnimation:sender];
    if (_phoneString.length > 20) {
        return;
    }
    if (sender == self.numberOneButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberOneButton:)]) {
            [self.delegate dialpadMainView:self tapNumberOneButton:sender];
        }
    }
    else if (sender == self.numberTwoButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberTwoButton:)]) {
            [self.delegate dialpadMainView:self tapNumberTwoButton:sender];
        }
    }
    else if (sender == self.numberThreeButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberThreeButton:)]) {
            [self.delegate dialpadMainView:self tapNumberThreeButton:sender];
        }
    }
    else if (sender == self.numberFourButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberFourButton:)]) {
            [self.delegate dialpadMainView:self tapNumberFourButton:sender];
        }
    }
    else if (sender == self.numberFiveButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberFiveButton:)]) {
            [self.delegate dialpadMainView:self tapNumberFiveButton:sender];
        }
    }
    else if (sender == self.numberSixButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberSixButton:)]) {
            [self.delegate dialpadMainView:self tapNumberSixButton:sender];
        }
    }
    else if (sender == self.numberSevenButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberSevenButton:)]) {
            [self.delegate dialpadMainView:self tapNumberSevenButton:sender];
        }
    }
    else if (sender == self.numberEightButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberEightButton:)]) {
            [self.delegate dialpadMainView:self tapNumberEightButton:sender];
        }
    }
    else if (sender == self.numberNineButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberNineButton:)]) {
            [self.delegate dialpadMainView:self tapNumberNineButton:sender];
        }
    }
    else if (sender == self.numberStarButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberStarButton:)]) {
            [self.delegate dialpadMainView:self tapNumberStarButton:sender];
        }
    }
    else if (sender == self.numberZeroButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberZeroButton:)]) {
            [self.delegate dialpadMainView:self tapNumberZeroButton:sender];
        }
    }
    else if (sender == self.numberWellButton) {
        if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapNumberWellButton:)]) {
            [self.delegate dialpadMainView:self tapNumberWellButton:sender];
        }
    }
}

- (void)tapCallButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapCallButton:)]) {
        [self.delegate dialpadMainView:self tapCallButton:sender];
    }
}

- (void)tapDeleteBtnAlways:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dialpadMainView:didDeleteTouchDownButton:)]) {
        [self.delegate dialpadMainView:self didDeleteTouchDownButton:sender];
    }
}

- (void)tapDeleteButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dialpadMainView:didDeleteTouchUpInsideButton:)]) {
        [self.delegate dialpadMainView:self didDeleteTouchUpInsideButton:sender];
    }
}

- (void)tapCountryButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapCountryButton:)]) {
        [self.delegate dialpadMainView:self tapCountryButton:sender];
    }
}

- (void)tapAddContactsButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapAddContactsButton:)]) {
        [self.delegate dialpadMainView:self tapAddContactsButton:sender];
    }
}

- (void)longPressZeroButton:(UILongPressGestureRecognizer *)longGes
{
    switch (longGes.state) {
        case UIGestureRecognizerStateBegan:{
            _changeFlag = NO;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (!_changeFlag) {
                if ([self.delegate respondsToSelector:@selector(dialpadMainView:longPressZeroButton:)]) {
                    [self.delegate dialpadMainView:self longPressZeroButton:_numberZeroButton];
                }
            }
            _changeFlag = YES;
            if ([self.delegate respondsToSelector:@selector(dialpadMainView:tapLongButton:)]) {
                [self.delegate dialpadMainView:self tapLongButton:_numberZeroButton];
            }
            NSLog(@"UIGestureRecognizerStateChanged");
            break;
        }
        default:
            break;
    }
}

#pragma mark - setupViews;
- (void)setupViews
{
    /*
     *   topView
     */
    _topPhoneContainer = [UIView new];
    _topPhoneContainer.backgroundColor = RGB(245, 246, 249);
    [self addSubview:_topPhoneContainer];
    
//    _statusView = [UIView new];
//    [_topPhoneContainer addSubview:_statusView];
//
//    _statusImg = [UIImageView new];
//    _statusImg.image = [UIImage imageNamed:@"phone_missed"];
//    [_statusView addSubview:_statusImg];
//
//    _statusLabel = [UILabel new];
//    _statusLabel.text = NSLocalizedString(@"Account connecting", @"PhoneView");
//    _statusLabel.font = FT(14);
//    _statusLabel.textColor = blueRGB;
//    [_statusView addSubview:_statusLabel];
    
//    _encryptionImageView = [UIImageView new];
//    _encryptionImageView.image = [UIImage imageNamed:@"calling_ico_encrypt"];
//    [_statusView addSubview:_encryptionImageView];
    
    _showPhoneView = [UIView new];
    [_topPhoneContainer addSubview:_showPhoneView];

    // TODO:head truncating
    _phoneTextfield = [[UITextField alloc] init];
    _phoneTextfield.adjustsFontSizeToFitWidth = YES;
    _phoneTextfield.minimumFontSize = 14.0;
    _phoneTextfield.font = [UIFont systemFontOfSize:36];
    _phoneTextfield.textAlignment = NSTextAlignmentCenter;
    _phoneTextfield.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextfield.textColor = [UIColor blackColor];
    //_phoneTextfield.text = @"+"; // +不能删除
    _phoneTextfield.text = @"";
    _phoneTextfield.delegate = self;
    _phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [_showPhoneView addSubview:_phoneTextfield];
    
//    _phoneLabel = [[UILabel alloc] init];
//    _phoneLabel.textAlignment = NSTextAlignmentLeft;
//    _phoneLabel.font = [UIFont systemFontOfSize:30.0];
//    _phoneLabel.numberOfLines = 1;
//    _phoneLabel.adjustsFontSizeToFitWidth = YES;
//    _phoneLabel.lineBreakMode = NSLineBreakByTruncatingHead;
//    _phoneLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//    _phoneLabel.textColor = [UIColor whiteColor];
//    [_showPhoneView addSubview:_phoneLabel];
//    _phoneLabel.minimumScaleFactor = 0.4;
    
//    _areaCodeLabel = [UILabel new];
//    _areaCodeLabel.textColor = [UIColor whiteColor];
//    _areaCodeLabel.font = [UIFont systemFontOfSize:30.0];
//    _areaCodeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//    _areaCodeLabel.adjustsFontSizeToFitWidth = YES;
//    _areaCodeLabel.textAlignment = NSTextAlignmentCenter;
//    _areaCodeLabel.text = @" +";
//    [self addSubview:_areaCodeLabel];
    
//    _showPayLabel = [UILabel new];
//    [_showPhoneView addSubview:_showPayLabel];
//    _showPayLabel.textColor = kPayLableColor;
//    _showPayLabel.textAlignment = NSTextAlignmentCenter;
//    _showPayLabel.text = @"$0.11/min";
//    _showPayLabel.font = [UIFont systemFontOfSize:10.0];
//    _showPayLabel.hidden = YES;
    
//    // payview
//    _payView = [UIView new];
//    [_topPhoneContainer addSubview:_payView];
    
    _deleteButton = [UIButton new];
    [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteButton.imageView setTintColor:blueRGB];
    [_showPhoneView addSubview:_deleteButton];
    // 长按删除
    [_deleteButton addTarget:self action:@selector(tapDeleteBtnAlways:) forControlEvents:UIControlEventTouchDown];
    // 松开
    [_deleteButton addTarget:self action:@selector(tapDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
//    // country
//    _countryLable = [UILabel new];
//    _countryLable.textColor = blueRGB;
//    _countryLable.font = [UIFont systemFontOfSize:14.0];
//    _countryLable.userInteractionEnabled = YES;
//    _countryLable.text = NSLocalizedString(@"Select country/region", @"PhoneView");
//    [_payView addSubview:_countryLable];
//
//    UITapGestureRecognizer *countryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCountryButton:)];
//    [_countryLable addGestureRecognizer:countryTap];
    
    /*
     *   centerView
     */
    _centerPadContainer = [UIView new];
    _centerPadContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:_centerPadContainer];
    
    //  1号键
    _numberOneView = [UIView new];
    _numberOneButton = [self createNumberButtonWithMainView:_numberOneView title:@"1" subTitle:nil sel:@selector(tapNumberButton:)];
    
    //  2号键
    _numberTwoView = [UIView new];
    _numberTwoButton = [self createNumberButtonWithMainView:_numberTwoView title:@"2" subTitle:@"ABC" sel:@selector(tapNumberButton:)];

    //  3号键
    _numberThreeView = [UIView new];
    _numberThreeButton = [self createNumberButtonWithMainView:_numberThreeView title:@"3" subTitle:@"DEF" sel:@selector(tapNumberButton:)];
    
    //  4号键
    _numberFourView = [UIView new];
    _numberFourButton = [self createNumberButtonWithMainView:_numberFourView title:@"4" subTitle:@"GHI" sel:@selector(tapNumberButton:)];
    
    //  5号键
    _numberFiveView = [UIView new];
    _numberFiveButton = [self createNumberButtonWithMainView:_numberFiveView title:@"5" subTitle:@"JKL" sel:@selector(tapNumberButton:)];
    
    //  6号键
    _numberSixView = [UIView new];
    _numberSixButton = [self createNumberButtonWithMainView:_numberSixView title:@"6" subTitle:@"MNO" sel:@selector(tapNumberButton:)];
    
    //  7号键
    _numberSevenView = [UIView new];
    _numberSevenButton = [self createNumberButtonWithMainView:_numberSevenView title:@"7" subTitle:@"PQRS" sel:@selector(tapNumberButton:)];
    
    //  8号键
    _numberEightView = [UIView new];
    _numberEightButton = [self createNumberButtonWithMainView:_numberEightView title:@"8" subTitle:@"TUV" sel:@selector(tapNumberButton:)];
    
    //  9号键
    _numberNineView = [UIView new];
    _numberNineButton = [self createNumberButtonWithMainView:_numberNineView title:@"9" subTitle:@"WXYZ" sel:@selector(tapNumberButton:)];
    
    //  *号键
    _numberStarView = [UIView new];
    _numberStarButton = [self createNumberButtonWithMainView:_numberStarView title:@"*" subTitle:nil sel:@selector(tapNumberButton:)];
    
    //  0号键
    _numberZeroView = [UIView new];
    _numberZeroButton = [self createNumberButtonWithMainView:_numberZeroView title:@"0" subTitle:@"+" sel:@selector(tapNumberButton:)];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressZeroButton:)];
//    [_numberZeroButton addGestureRecognizer:longPress];
//    longPress.minimumPressDuration = 0.8;
    
    //  #号键
    _numberWellView = [UIView new];
    _numberWellButton = [self createNumberButtonWithMainView:_numberWellView title:@"#" subTitle:nil sel:@selector(tapNumberButton:)];

    /*
     *   bottomView
     */
    _bottomCallButtonContainer = [UIView new];
    _bottomCallButtonContainer.backgroundColor = [UIColor whiteColor];
    _bottomCallButtonContainer.clipsToBounds = YES;
    [self addSubview:_bottomCallButtonContainer];
    
    _callButton = [UIButton new];
    _callButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _callButton.layer.cornerRadius = callWH / 2.f;
    [_callButton addTarget:self action:@selector(tapCallButton:) forControlEvents:UIControlEventTouchUpInside];
    [_callButton setImage:[UIImage imageNamed:@"keyPad_Call"] forState:UIControlStateNormal];
    [_callButton setImage:[UIImage imageNamed:@"hangup"] forState:UIControlStateHighlighted];
    [_bottomCallButtonContainer addSubview:_callButton];
}

- (VETDialpadButton *)createNumberButtonWithMainView:(UIView *)mainView title:(NSString *)title subTitle:(NSString *)subtTitle sel:(SEL)sel
{
    [_centerPadContainer addSubview:mainView];
    VETDialpadButton *button = [VETDialpadButton new];
    [mainView addSubview:button];
    [button setTitle:title forState:UIControlStateNormal];
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        button.titleLabel.font = [UIFont systemFontOfSize:32.0];
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:40.0];
    }
    [button setTitleColor:kNumberColor forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchDown];
    if (!subtTitle || !subtTitle.length) {
        return button;
    }
    button.subText = subtTitle;
    return button;
}

#pragma mark - setupLayouts;
- (void)setupLayouts
{
    /*
     *  topView
     */
    [_topPhoneContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.left.and.right.mas_equalTo(self).offset(0);
        make.height.equalTo(self.mas_height).multipliedBy(0.25);
    }];
    
//    // statusView
//    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_topPhoneContainer).offset(10);
//        make.left.and.right.mas_equalTo(_topPhoneContainer).offset(0);
//        make.height.mas_equalTo(@50);
//    }];
//
//    [_statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_statusView).mas_offset(@25);
//        make.left.mas_equalTo(_statusView).mas_equalTo(@15);
//        make.width.and.height.mas_equalTo(@12);
//    }];
//
//    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(_statusImg.mas_centerY);;
//        make.left.mas_equalTo(_statusImg.mas_right).mas_equalTo(10);
//    }];
    
//    [_encryptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(_statusImg.mas_centerY);;
//        make.right.mas_equalTo(_statusView).mas_equalTo(@-15);
//    }];
    
    // phoneview
    [_showPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(_topPhoneContainer).offset(0);
        make.centerY.mas_equalTo(_topPhoneContainer);
    }];
    
//    [_areaCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_showPhoneView).offset(10.0);
//        make.centerY.mas_equalTo(_phoneTextfield.mas_centerY);;
//        make.width.equalTo(_deleteButton.mas_width);
//    }];
    
    [_phoneTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_showPhoneView.mas_bottom);
        make.centerY.mas_equalTo(_showPhoneView);
        make.left.mas_equalTo(_showPhoneView).offset(10.0);
        make.right.mas_equalTo(_deleteButton.mas_left).mas_offset(0);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_phoneTextfield.mas_centerY);;
        make.right.mas_equalTo(_showPhoneView.mas_right).offset(-10);
        make.width.height.equalTo(@55);
    }];
    
//    [_showPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_phoneTextfield.mas_bottom).mas_offset(5);
//        make.height.equalTo(@21);
//        make.centerX.mas_equalTo(_payView.mas_centerX);
//    }];
    
    // payview
//    [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_showPhoneView.mas_bottom).offset(0);
//        make.bottom.and.left.and.right.mas_equalTo(_topPhoneContainer).offset(0);
//        make.height.mas_equalTo(_topPhoneContainer).multipliedBy(0.3);
//    }];

//    [_countryLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_payView).offset(15);
//        make.bottom.mas_equalTo(_payView.mas_bottom).offset(-15);
//    }];
    
//    [_balanceNotiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(_countryLable.mas_left).offset(-5);
//        make.centerY.mas_equalTo(_countryLable.mas_centerY);
//    }];
//
//    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(_payView.mas_right).offset(-15);
//        make.centerY.mas_equalTo(_countryLable.mas_centerY);
//    }];
    
    /*
     *  centerView
     */
    [_centerPadContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topPhoneContainer.mas_bottom).offset(0);
        make.left.and.right.mas_equalTo(self).offset(0);
        make.height.equalTo(self.mas_height).multipliedBy(0.55);
    }];
    
    [_numberOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(_centerPadContainer).offset(0);
    }];
    [_numberOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberOneView).offset(0);
    }];
    
    [_numberTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_centerPadContainer).offset(0);
        make.left.mas_equalTo(_numberOneView.mas_right).offset(0);
        make.width.and.height.mas_equalTo(_numberOneView);
    }];
    [_numberTwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberTwoView).offset(0);
    }];
    
    [_numberThreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.mas_equalTo(_centerPadContainer).offset(0);
        make.left.mas_equalTo(_numberTwoView.mas_right).offset(0);
        make.width.and.height.mas_equalTo(_numberTwoView);
    }];
    [_numberThreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberThreeView).offset(0);
    }];
    
    [_numberFourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_centerPadContainer).offset(0);
        make.top.mas_equalTo(_numberOneView.mas_bottom).offset(0);
        make.height.mas_equalTo(_numberOneView);
    }];
    [_numberFourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberFourView).offset(0);
    }];
    
    [_numberFiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberTwoView.mas_bottom).offset(0);
        make.left.mas_equalTo(_numberFourView.mas_right).offset(0);
        make.width.mas_equalTo(_numberFourView);
        make.height.mas_equalTo(_numberTwoView);
    }];
    [_numberFiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberFiveView).offset(0);
    }];
    
    [_numberSixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberThreeView.mas_bottom).offset(0);
        make.left.mas_equalTo(_numberFiveView.mas_right).offset(0);
        make.right.mas_equalTo(_centerPadContainer).offset(0);
        make.width.mas_equalTo(_numberFiveView);
        make.height.mas_equalTo(_numberThreeView);
    }];
    [_numberSixButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberSixView).offset(0);
    }];
    
    [_numberSevenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberFourView.mas_bottom).offset(0);
        make.left.mas_equalTo(_centerPadContainer).offset(0);
        make.width.and.height.mas_equalTo(_numberFourView);
    }];
    [_numberSevenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberSevenView).offset(0);
    }];
    
    [_numberEightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberFiveView.mas_bottom).offset(0);
        make.left.mas_equalTo(_numberSevenView.mas_right).offset(0);
        make.width.mas_equalTo(_numberSevenView);
        make.height.mas_equalTo(_numberFiveView);
    }];
    [_numberEightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberEightView).offset(0);
    }];
    
    [_numberNineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberSixView.mas_bottom).offset(0);
        make.left.mas_equalTo(_numberEightView.mas_right).offset(0);
        make.width.mas_equalTo(_numberEightView);
        make.height.mas_equalTo(_numberSixView);
    }];
    [_numberNineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberNineView).offset(0);
    }];
    
    [_numberStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberSevenView.mas_bottom).offset(0);
        make.left.and.bottom.mas_equalTo(_centerPadContainer).offset(0);
        make.width.and.height.mas_equalTo(_numberSevenView);
    }];
    [_numberStarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberStarView).offset(0);
    }];
    
    [_numberZeroView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberEightView.mas_bottom).offset(0);
        make.left.mas_equalTo(_numberStarView.mas_right).offset(0);
        make.height.mas_equalTo(_numberEightView);
        make.width.mas_equalTo(_numberStarView);
    }];
    [_numberZeroButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberZeroView).offset(0);
    }];
    
    [_numberWellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numberNineView.mas_bottom).offset(0);
        make.left.mas_equalTo(_numberZeroView.mas_right).offset(0);
        make.width.mas_equalTo(_numberZeroView);
        make.height.mas_equalTo(_numberNineView);
    }];
    [_numberWellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.and.bottom.mas_equalTo(_numberWellView).offset(0);
    }];
    
    /*
     *  bottomView
     */
    [_bottomCallButtonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_centerPadContainer.mas_bottom).offset(22);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.left.right.mas_equalTo(self).offset(0);
    }];
    
    [_callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(callWH));
        make.centerX.and.centerY.mas_equalTo(_bottomCallButtonContainer);
    }];
}

//- (void)setNowAreaCode:(NSUInteger)nowAreaCode
//{
//    _nowAreaCode = nowAreaCode;
//    if (nowAreaCode == 0) {
////        _areaCodeLabel.text = @"+";
//        _countryLabel.text = NSLocalizedString(@"Select country/region", @"PhoneView");
//        _phoneTextfield.text = @"+";
//    }
//    else{
//        
//    }
//}

- (void)setPhoneString:(NSString *)phoneString
{
    _phoneString = phoneString;
    
    if (_phoneString && _phoneString.length > 0) {
        // 如果有国家显示加号
//        if (self.country) {
//            self.phoneTextfield.text = [NSString stringWithFormat:@"+%@", _phoneString];
//        }
//        else {
            self.phoneTextfield.text = _phoneString;
        //}
    } else {
        // 删除所有显示为空
        self.phoneTextfield.text = @"";
    }
}

- (void)setCountry:(VETCountry *)country
{
    _country = country;
    if (country) {
        //self.phoneTextfield.text = [NSString stringWithFormat:@"+%@", _phoneString];
        self.phoneTextfield.text = _phoneString ? _phoneString : @"";
    }
}

- (void)setEncryptionStatus:(BOOL)encryptionStatus
{
    _encryptionStatus = encryptionStatus;
    //self.encryptionImageView.hidden = encryptionStatus;
}

@end
