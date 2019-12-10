//
//  VETDTMFView.m
//  MobileVoip
//
//  Created by Liu Yang on 12/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETDTMFView.h"
#import "VETDialpadButton.h"

#define kLineColor RGBCOLOR(29, 71, 109)
#define BACKGROUND_COLOR_END RGBCOLOR(0x06, 0x21, 0x36)

@interface VETDTMFView ()
{
    BOOL _changeFlag;
}

/*
 * space view
 */
@property (nonatomic, retain) UIView *topSpaceView;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) UIView *centerView;

/*
 * hideBtn
 */
@property (nonatomic, retain) UIButton *hideBtn;

/*
 * showPhone View
 */
@property (nonatomic, retain) UIView *showPhoneView;
@property (nonatomic, retain) UILabel *phoneLabel;

/*
 *  keypadView
 */
//@property (nonatomic, retain) UIView *keypadView;
@property (nonatomic, retain) UIView *centerPadContainer;
@property (nonatomic, retain) UIView *numberOneView;
@property (nonatomic, retain) UIButton *numberOneButton;

@property (nonatomic, retain) UIView *numberTwoView;
@property (nonatomic, retain) VETDialpadButton *numberTwoButton;

@property (nonatomic, retain) UIView *numberThreeView;
@property (nonatomic, retain) VETDialpadButton *numberThreeButton;

@property (nonatomic, retain) UIView *numberFourView;
@property (nonatomic, retain) VETDialpadButton *numberFourButton;

@property (nonatomic, retain) UIView *numberFiveView;
@property (nonatomic, retain) VETDialpadButton *numberFiveButton;

@property (nonatomic, retain) UIView *numberSixView;
@property (nonatomic, retain) VETDialpadButton *numberSixButton;

@property (nonatomic, retain) UIView *numberSevenView;
@property (nonatomic, retain) VETDialpadButton *numberSevenButton;

@property (nonatomic, retain) UIView *numberEightView;
@property (nonatomic, retain) VETDialpadButton *numberEightButton;

@property (nonatomic, retain) UIView *numberNineView;
@property (nonatomic, retain) VETDialpadButton *numberNineButton;

@property (nonatomic, retain) UIView *numberStarView;   //  *
@property (nonatomic, retain) UIButton *numberStarButton;

@property (nonatomic, retain) UIView *numberZeroView;
@property (nonatomic, retain) VETDialpadButton *numberZeroButton;

@property (nonatomic, retain) UIView *numberWellView;   //  #
@property (nonatomic, retain) UIButton *numberWellButton;

/*
 *  hangupBtn
 */
@property (nonatomic, retain) UIButton *hangupBtn;

@end

@implementation VETDTMFView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
        [self setupLayouts];
        self.alpha = 0.0;
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

- (void)setupViews
{
    self.backgroundColor = BACKGROUND_COLOR_END;
    
    _topSpaceView = [UIView new];
    [self addSubview:_topSpaceView];
    _topSpaceView.backgroundColor = [UIColor whiteColor];
    
    _centerView = [UIView new];
    [self addSubview:_centerView];
    _centerView.backgroundColor = [UIColor whiteColor];
    
    _bottomView = [UIView new];
    [self addSubview:_bottomView];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    _hideBtn = [UIButton new];
    [_hideBtn setTitle:[CommenUtil LocalizedString:@"Common.Hide"] forState:UIControlStateNormal];
    [_hideBtn addTarget:self action:@selector(tapHideBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_hideBtn];
    
    _showPhoneView = [UIView new];
    _showPhoneView.backgroundColor = [UIColor clearColor];
    [self addSubview:_showPhoneView];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = [UIFont systemFontOfSize:32.0];
    _phoneLabel.adjustsFontSizeToFitWidth = YES;
    _phoneLabel.minimumScaleFactor = 0.4;
    _phoneLabel.text = @"";
    [_showPhoneView addSubview:_phoneLabel];
    
    /*
     *   keypadView
     */
    _centerPadContainer = [UIView new];
    _centerPadContainer.backgroundColor = [UIColor clearColor];
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
    _numberSixButton = [self createNumberButtonWithMainView:_numberSixView title:@"6" subTitle:@"MNQ" sel:@selector(tapNumberButton:)];
    
    //  7号键
    _numberSevenView = [UIView new];
    _numberSevenButton = [self createNumberButtonWithMainView:_numberSevenView title:@"7" subTitle:@"PQR" sel:@selector(tapNumberButton:)];
    
    //  8号键
    _numberEightView = [UIView new];
    _numberEightButton = [self createNumberButtonWithMainView:_numberEightView title:@"8" subTitle:@"SDU" sel:@selector(tapNumberButton:)];
    
    //  9号键
    _numberNineView = [UIView new];
    _numberNineButton = [self createNumberButtonWithMainView:_numberNineView title:@"9" subTitle:@"VWX" sel:@selector(tapNumberButton:)];
    
    //  *号键
    _numberStarView = [UIView new];
    _numberStarButton = [self createNumberButtonWithMainView:_numberStarView title:@"*" subTitle:nil sel:@selector(tapNumberButton:)];
    
    //  0号键
    _numberZeroView = [UIView new];
    _numberZeroButton = [self createNumberButtonWithMainView:_numberZeroView title:@"0" subTitle:@"+" sel:@selector(tapNumberButton:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressZeroButton:)];
    [_numberZeroButton addGestureRecognizer:longPress];
    longPress.minimumPressDuration = 0.8;
    
    //  #号键
    _numberWellView = [UIView new];
    _numberWellButton = [self createNumberButtonWithMainView:_numberWellView title:@"#" subTitle:nil sel:@selector(tapNumberButton:)];
    
    _hangupBtn = [UIButton new];
    [self addSubview:_hangupBtn];
    [_hangupBtn addTarget:self action:@selector(tapHangupButton:) forControlEvents:UIControlEventTouchUpInside];
    [_hangupBtn setImage:[UIImage imageNamed:@"DTMF_hang_up"] forState:UIControlStateNormal];
    [_hangupBtn setImage:[UIImage imageNamed:@"DTMF_hang_up_dark"] forState:UIControlStateSelected];
}

- (VETDialpadButton *)createNumberButtonWithMainView:(UIView *)mainView title:(NSString *)title subTitle:(NSString *)subtTitle sel:(SEL)sel
{
    [_centerPadContainer addSubview:mainView];
    VETDialpadButton *button = [VETDialpadButton new];
    [mainView addSubview:button];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:40.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchDown];
    button.layer.borderColor = kLineColor.CGColor;
    button.layer.borderWidth = PointHeight;
    if (!subtTitle || !subtTitle.length) {
        return button;
    }
    button.subText = subtTitle;
    return button;
}

- (void)setupLayouts
{
    CGFloat keypadViewWH = SCREEN_WIDTH - 20 * 2;
    
   
    /*
     *  HideBtn
     */
    [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(self).mas_offset(20);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@40);
    }];
    
    [_showPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hideBtn.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_centerPadContainer.mas_top);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(_showPhoneView);
        make.left.mas_equalTo(_showPhoneView).mas_offset(20);
        make.right.mas_equalTo(_showPhoneView).mas_offset(-20);
    }];
    
    /*
     *  KeypadView
     */
    [_centerPadContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(0);
        make.left.mas_equalTo(self).mas_offset(20);
        make.right.mas_equalTo(self).mas_offset(-20);
        make.height.mas_equalTo(@(keypadViewWH));
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
        make.left.mas_equalTo(_numberOneView).offset(0);
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
     * Center space view
     */
//    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_centerPadContainer.mas_bottom);
//        make.left.and.right.mas_equalTo(self);
//        make.height.mas_equalTo(_bottomView.mas_height);
//    }];
    
    [_hangupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).multipliedBy(0.5);
        make.height.mas_equalTo(@55);
        make.bottom.mas_equalTo(@-55);
        make.centerX.mas_equalTo(self);
    }];
    
    /*
     * Bottom space view
     */
//    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_hangupBtn.mas_bottom);
//        make.left.and.right.and.bottom.mas_equalTo(self);
//        make.height.mas_equalTo(_topSpaceView.mas_height);
//    }];
}

- (void)tapHideBtn:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapHideButton:)]) {
        [self.delegate DTMFView:self tapHideButton:sender];
    }
}

- (void)tapHangupButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapHangupButton:)]) {
        [self.delegate DTMFView:self tapHangupButton:sender];
    }
}

- (void)tapNumberButton:(id)sender
{
    [self startAnimation:sender];
    if (sender == self.numberOneButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberOne];
            _phoneLabel.text = [NSString stringWithFormat:@"%@1", _phoneLabel.text];
        }
    }
    else if (sender == self.numberTwoButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberTwo];
            _phoneLabel.text = [NSString stringWithFormat:@"%@2", _phoneLabel.text];
        }
    }
    else if (sender == self.numberThreeButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberThree];
            _phoneLabel.text = [NSString stringWithFormat:@"%@3", _phoneLabel.text];
        }
    }
    else if (sender == self.numberFourButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberFour];
            _phoneLabel.text = [NSString stringWithFormat:@"%@4", _phoneLabel.text];
        }
    }
    else if (sender == self.numberFiveButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberFive];
            _phoneLabel.text = [NSString stringWithFormat:@"%@5", _phoneLabel.text];
        }
    }
    else if (sender == self.numberSixButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberSix];
            _phoneLabel.text = [NSString stringWithFormat:@"%@6", _phoneLabel.text];
        }
    }
    else if (sender == self.numberSevenButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberSeven];
            _phoneLabel.text = [NSString stringWithFormat:@"%@7", _phoneLabel.text];
        }
    }
    else if (sender == self.numberEightButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberEight];
            _phoneLabel.text = [NSString stringWithFormat:@"%@8", _phoneLabel.text];
        }
    }
    else if (sender == self.numberNineButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberOne];
            _phoneLabel.text = [NSString stringWithFormat:@"%@9", _phoneLabel.text];
        }
    }
    else if (sender == self.numberStarButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberStar];
            _phoneLabel.text = [NSString stringWithFormat:@"%@*", _phoneLabel.text];
        }
    }
    else if (sender == self.numberZeroButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberZero];
            _phoneLabel.text = [NSString stringWithFormat:@"%@0", _phoneLabel.text];
        }
    }
    else if (sender == self.numberWellButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
            [self.delegate DTMFView:self tapNumberButton:sender number:VETKeypadNumberWell];
            _phoneLabel.text = [NSString stringWithFormat:@"%@#", _phoneLabel.text];
        }
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
                if ([self.delegate respondsToSelector:@selector(DTMFView:tapNumberButton:number:)]) {
                    [self.delegate DTMFView:self tapNumberButton:_numberZeroButton number:VETKeypadNumberZero];
                }
            }
            _changeFlag = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(DTMFView:longPressZeroButton:)]) {
                [self.delegate DTMFView:self longPressZeroButton:_numberZeroButton];
            }
            NSLog(@"UIGestureRecognizerStateChanged");
            break;
        }
        default:
            break;
    }
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }];
}

@end
