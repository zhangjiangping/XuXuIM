//
//  MLRegisterView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/7.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLRegisterView.h"
#import "UIView+Responder.h"
#import "BaseWebViewController.h"
#import "VETCountryViewController.h"

@interface MLRegisterView () <UITextFieldDelegate>
{
    float hh;
}
@property (nonatomic, strong) UIButton *countryBut;
@property (nonatomic, strong) UIImageView *countryRightImg;
@property (nonatomic, strong) UILabel *countryLable;

@end

@implementation MLRegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
             hh = 30;
        } else {
             hh = 44;
        }
        
        [self addSubview:self.countryBut];
        [self addSubview:self.phoneTextField];
        [self addSubview:self.verificationTextField];
        [self addSubview:self.but];
        [self addSubview:self.textField_DLS];
        [self addSubview:self.textField_DLMM];
        [self addSubview:self.textField_TMM];
        [self addSubview:self.gouBut];
        [self addSubview:self.tureBut];
        
        [self setupCountry];
    }
    return self;
}

- (void)setupCountry
{
    if (!SharedApp.currentCountry) {
        [SharedApp setupDefaultAccount];
    }
    _countryName = SharedApp.currentCountry.countryChineseName;
    _countryCode = SharedApp.currentCountry.code;
    _countryIcon = SharedApp.currentCountry.icon;
    _countryLable.text = [NSString stringWithFormat:@"%@ (+%@)",_countryName,_countryCode];
}

//选择国家
- (void)tapCountryButton:(UIButton *)sender
{
    VETCountryViewController *countryVC = [VETCountryViewController new];
    countryVC.countryBlock = ^(VETCountry *country) {
        _countryName = country.countryChineseName;
        _countryCode = country.code;
        _countryIcon = country.icon;
        _countryLable.text = [NSString stringWithFormat:@"%@ (+%@)",_countryName,_countryCode];
    };
    [self.viewController.navigationController pushViewController:countryVC animated:YES];
}

#pragma mark - getter

- (UIButton *)countryBut
{
    if (!_countryBut) {
        _countryBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _countryBut.frame = CGRectMake(30, 20, widths-60, hh);
        _countryBut.backgroundColor = RGB(241, 241, 241);
        _countryBut.layer.cornerRadius = 10;
        [_countryBut addTarget:self action:@selector(tapCountryButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_countryBut addSubview:self.countryLable];
        [_countryBut addSubview:self.countryRightImg];
    }
    return _countryBut;
}

- (UILabel *)countryLable
{
    if (!_countryLable) {
        _countryLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.countryBut.frame)-10*2-15-18, CGRectGetHeight(self.countryBut.frame))];
    }
    return _countryLable;
}

- (UIImageView *)countryRightImg
{
    if (!_countryRightImg) {
        _countryRightImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryLable.frame)+10, (CGRectGetHeight(self.countryBut.frame)-18)/2, 18, 18)];
        _countryRightImg.image = [UIImage imageNamed:@"icon--more"];
        _countryRightImg.clipsToBounds = YES;
    }
    return _countryRightImg;
}

- (MLMinLeTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[MLMinLeTextField alloc] init];
        _phoneTextField.frame = CGRectMake(30, CGRectGetMaxY(self.countryBut.frame)+20, widths-60, hh);
        _phoneTextField.placeholder = [CommenUtil LocalizedString:@"Login.PhoneNumber"];
        _phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _phoneTextField;
}

- (MLMinLeTextField *)verificationTextField
{
    if (!_verificationTextField) {
        _verificationTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.phoneTextField.frame)+20, (widths-30*2-20)/2, hh)];
        _verificationTextField.placeholder = [CommenUtil LocalizedString:@"Register.PhoneCode"];
        _verificationTextField.keyboardType = UIKeyboardTypeDecimalPad;//数字带小数点键盘
        _verificationTextField.delegate = self;
    }
    return _verificationTextField;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(widths-(widths-30*2-20)/2-30, CGRectGetMaxY(self.phoneTextField.frame)+20, (widths-30*2-20)/2, hh);
        _but.layer.cornerRadius = 10;
        _but.layer.borderColor = LayerRGB(0, 134, 219);
        _but.layer.borderWidth = 1;
        [_but addSubview:self.lable];
    }
    return _but;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:self.but.bounds];
        _lable.text = [CommenUtil LocalizedString:@"Register.GetCode"];
        _lable.textColor = RGB(0, 134, 219);
        _lable.font = FT(15);
        _lable.layer.cornerRadius = 10;
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

- (MLMinLeTextField *)textField_DLS
{
    if (!_textField_DLS) {
        _textField_DLS = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.but.frame)+20, widths-60, hh)];
        _textField_DLS.delegate = self;
        _textField_DLS.placeholder = [CommenUtil LocalizedString:@"Register.RecommendedCode"];
        _textField_DLS.delegate = self;
    }
    return _textField_DLS;
}

- (MLMinLeTextField *)textField_DLMM
{
    if (!_textField_DLMM) {
        _textField_DLMM = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.textField_DLS.frame)+20, widths-60, hh)];
        _textField_DLMM.secureTextEntry = YES;//密码形式
        _textField_DLMM.delegate = self;
        _textField_DLMM.placeholder = [CommenUtil LocalizedString:@"Register.PleaseSetup6-12PasswordMsg"];
    }
    return _textField_DLMM;
}

- (MLMinLeTextField *)textField_TMM
{
    if (!_textField_TMM) {
        _textField_TMM = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.textField_DLMM.frame)+20, widths-60, hh)];
        _textField_TMM.secureTextEntry = YES;//密码形式
        _textField_TMM.delegate = self;
        _textField_TMM.placeholder = [CommenUtil LocalizedString:@"Register.TurePassword"];
    }
    return _textField_TMM;
}

- (UIButton *)gouBut
{
    if (!_gouBut) {
        _gouBut = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _gouBut.frame = CGRectMake(20, CGRectGetMaxY(self.textField_TMM.frame)+15, 40, 40);
        } else {
            _gouBut.frame = CGRectMake(20, CGRectGetMaxY(self.textField_TMM.frame)+30, 40, 50);
        }
        [_gouBut addTarget:self action:@selector(gouAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CGRectGetHeight(self.gouBut.frame)-18)/2, 18, 18)];
        img.tag = 11;
        img.image = [UIImage imageNamed:@"tongyi_03"];
        [_gouBut addSubview:img];
    }
    return _gouBut;
}

- (UIButton *)tureBut
{
    if (!_tureBut) {
        _tureBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _tureBut.frame = CGRectMake(60, CGRectGetMinY(self.gouBut.frame), 100, CGRectGetHeight(self.gouBut.frame));
        [_tureBut setTitle:[CommenUtil LocalizedString:@"Register.AgreeServiceAgreement"] forState:UIControlStateNormal];
        [_tureBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_tureBut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tureBut;
}

#pragma mark - button action

//查看服务协议
- (void)pushAction:(UIButton *)sender
{
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.titleStr = [CommenUtil LocalizedString:@"Register.ServiceAgreement"];
    webVC.urlStr = [NSString stringWithFormat:@"%@4",ApiH5URL];
    [self.viewController.navigationController pushViewController:webVC animated:YES];
}

//是否同意服务协议
- (void)gouAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    UIImageView *img = [sender viewWithTag:11];
    if (sender.selected) {
        img.image = [UIImage imageNamed:@"tongyi_05_03"];
    } else {
        img.image = [UIImage imageNamed:@"tongyi_03"];
    }
}

#pragma mark - UITextField  delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
