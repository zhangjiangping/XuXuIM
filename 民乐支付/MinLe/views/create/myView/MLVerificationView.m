//
//  MLVerificationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/14.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLVerificationView.h"
#import "UIView+Responder.h"
#import "NSString+MyString.h"
#import "VETCountryViewController.h"

@interface MLVerificationView ()
@property (nonatomic, strong) UIButton *countryBut;
@property (nonatomic, strong) UIImageView *countryRightImg;
@property (nonatomic, strong) UILabel *countryLable;
@end

@implementation MLVerificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.countryBut];
        [self addSubview:self.phoneTextField];
        [self addSubview:self.verificationTextField];
        [self addSubview:self.but];
        
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

#pragma mark - getter setter

- (UIButton *)countryBut
{
    if (!_countryBut) {
        _countryBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _countryBut.frame = CGRectMake(40, 40, widths-80, 44);
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
        _phoneTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.countryBut.frame)+20, widths-80, 44)];
        _phoneTextField.placeholder = [CommenUtil LocalizedString:@"Login.PhoneNumber"];
        _phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _phoneTextField;
}

- (MLMinLeTextField *)verificationTextField
{
    if (!_verificationTextField) {
        _verificationTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.phoneTextField.frame)+20, (widths-120)/2, 44)];
        _verificationTextField.placeholder = [CommenUtil LocalizedString:@"Register.PhoneCode"];
        _verificationTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _verificationTextField;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(widths-(widths-120)/2-40, CGRectGetMaxY(self.phoneTextField.frame)+20, (widths-120)/2, 44);
        _but.layer.cornerRadius = 10;
        _but.layer.borderColor = LayerRGB(2, 138, 218);
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
        _lable.textColor = RGB(2, 138, 218);
        _lable.font = FT(15);
        _lable.layer.cornerRadius = 10;
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

@end













