//
//  VETRatesViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 07/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETRatesViewController.h"

@interface VETRatesViewController ()

@property (nonatomic, retain) UIView *mainView;

/*
 * topView
 */
@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UILabel *hintLabel;
@property (nonatomic, retain) UIButton *closeBtn;

/*
 * centerView
 */
@property (nonatomic, retain) UIView *centerView;
@property (nonatomic, retain) UILabel *phoneLabel;
@property (nonatomic, retain) UIImageView *flagImg;
@property (nonatomic, retain) UILabel *areaAndCode;

/*
 * bottomView
 */
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) UIButton *callBtn;
@property (nonatomic, retain) UILabel *moneyLabel;
@property (nonatomic, retain) UILabel *unitLabel;

@end

@implementation VETRatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAINTHEMECOLOR;
    
    [self setupViews];
    [self setupLayouts];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setupViews
{
    _mainView = [UIView new];
    _mainView.backgroundColor = [UIColor whiteColor];
    _mainView.layer.cornerRadius = 20.0;
    [self.view addSubview:_mainView];
    
    /*
     * topView
     */
    _topView = [UIView new];
    [_mainView addSubview:_topView];
    
    _hintLabel = [UILabel new];
    _hintLabel.text = [CommenUtil LocalizedString:@"Call.Rates"];
    _hintLabel.textColor = [UIColor blackColor];
    _hintLabel.font = [UIFont systemFontOfSize:18.0];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_hintLabel];

    _closeBtn = [UIButton new];
    [_closeBtn setImage:[UIImage imageNamed:@"rates_cancel"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(tapCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_closeBtn];
    
    /*
     * centerView
     */
    _centerView = [UIView new];
    [_mainView addSubview:_centerView];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.font = [UIFont systemFontOfSize:20.0];
    _phoneLabel.text = _phoneNumber;
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    [_centerView addSubview:_phoneLabel];
    
    _flagImg = [UIImageView new];
    _flagImg.image = [UIImage imageNamed:@"CN"];
    [_centerView addSubview:_flagImg];
    
    _areaAndCode = [UILabel new];
    _areaAndCode.textAlignment = NSTextAlignmentCenter;
    _areaAndCode.text = @"China    +86";
    [_centerView addSubview:_areaAndCode];
    
    /*
     * bottomView
     */
    _bottomView = [UIView new];
    [_mainView addSubview:_bottomView];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.text = @"0.14";
    [_bottomView addSubview:_moneyLabel];
    
    _unitLabel = [UILabel new];
    _unitLabel.textAlignment = NSTextAlignmentCenter;
    _unitLabel.text = [CommenUtil LocalizedString:@"Call.CNY/min"];
    [_bottomView addSubview:_unitLabel];
    
    _callBtn = [UIButton new];
    [_callBtn setImage:[UIImage imageNamed:@"call_outgoing"] forState:UIControlStateNormal];
    [_callBtn addTarget:self action:@selector(tapCallBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_callBtn setBackgroundColor:MAINTHEMECOLOR];
    _callBtn.layer.cornerRadius = 80 / 2;
    _callBtn.layer.masksToBounds = YES;
    [_bottomView addSubview:_callBtn];
}

- (void)setupLayouts
{
    CGFloat mainViewSpace = 20.0;
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.mas_equalTo(mainViewSpace);
        make.right.and.bottom.mas_equalTo(-mainViewSpace);
    }];
    
    /*
     * topView
     */
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(_mainView);
        make.height.mas_equalTo(_topView.mas_height);
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(_topView);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView).mas_offset(@20);
        make.right.mas_equalTo(_topView).mas_offset(@-20);
        make.width.mas_equalTo(_closeBtn.mas_height);
    }];

    /*
     * centerView
     */
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.left.and.right.mas_equalTo(_mainView);
        make.height.mas_equalTo(_bottomView.mas_height);
        make.centerY.and.centerX.mas_equalTo(_mainView);
    }];
    
    [_flagImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.centerX.mas_equalTo(_centerView);
        make.width.and.height.mas_equalTo(@30);
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_flagImg.mas_top).mas_offset(-15);
        make.centerX.mas_equalTo(_centerView);
    }];
    
    [_areaAndCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_flagImg.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(_centerView);
    }];
    
    /*
     * bottomView
     */
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_centerView.mas_bottom);
        make.left.and.right.mas_equalTo(_mainView);
        make.bottom.mas_equalTo(_mainView);
    }];
    
    [_callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView);
        make.bottom.mas_equalTo(_bottomView.mas_bottom).offset(-20);
        make.width.and.height.mas_equalTo(@80);
    }];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_callBtn.mas_top).offset(-20);
        make.centerX.mas_equalTo(_bottomView);
        make.height.mas_equalTo(@24);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomView);
        make.bottom.mas_equalTo(_unitLabel.mas_top).offset(-5);
        make.height.mas_equalTo(@21);
    }];
}

#pragma mark - event

- (void)tapCloseBtn:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.repeatCount = 1;
    transition.type = @"oglFlip";
    //    - 确定子类型(方向等)
    transition.subtype = kCATransitionFromRight;
    transition.duration = 0.6;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapCallBtn:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
