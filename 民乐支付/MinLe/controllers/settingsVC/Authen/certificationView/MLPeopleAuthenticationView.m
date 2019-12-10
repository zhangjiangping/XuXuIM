//
//  MLPeopleAuthenticationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLPeopleAuthenticationView.h"
#import "UIViewController+XHPhoto.h"
#import "UIView+Responder.h"
#import "MLPeopleCertificationViewController.h"

#define middleJianxi 40       //＋号与左边文字之间的间隙
#define imgLeftLableWidth 130 //上传图片左边lable的宽

@interface MLPeopleAuthenticationView () <UITextFieldDelegate>
{
    NSString *keboard;
}
@property (nonatomic, strong) UILabel *lable1;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UILabel *lable3;
@property (nonatomic, strong) UILabel *lable4;
@property (nonatomic, strong) UILabel *lable5;
@property (nonatomic, strong) UILabel *lable6;
@property (nonatomic, strong) UILabel *lable7;

@property (nonatomic, strong) UILabel *jcLable;
@property (nonatomic, strong) UILabel *qcLable;
@property (nonatomic, strong) UILabel *dzLable;

@property (nonatomic, strong) UILabel *phoneLable;
@property (nonatomic, strong) UILabel *yingYeLable;

@property (nonatomic, strong) UIButton *imgBut1;
@property (nonatomic, strong) UIButton *imgBut2;
@property (nonatomic, strong) UIButton *imgBut3;
@property (nonatomic, strong) UIButton *imgBut4;
@property (nonatomic, strong) UIButton *imgBut5;

@end

@implementation MLPeopleAuthenticationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.jcLable];
        [self addSubview:self.jcTextField];
        [self addSubview:self.qcLable];
        [self addSubview:self.qcTextField];
        [self addSubview:self.dzLable];
        [self addSubview:self.dzTextField];
        
        [self addSubview:self.lable1];
        [self addSubview:self.nameTextField];
        [self addSubview:self.phoneLable];
        [self addSubview:self.phoneTextField];
        [self addSubview:self.lable2];
        [self addSubview:self.haomaTextField];
        [self addSubview:self.yingYeLable];
        [self addSubview:self.yingYeTextField];
        
        [self addSubview:self.lable3];
        [self addSubview:self.but1];
        [self addSubview:self.imgBut1];
        
        [self addSubview:self.lable4];
        [self addSubview:self.but2];
        [self addSubview:self.imgBut2];
        
        [self addSubview:self.lable5];
        [self addSubview:self.but3];
        [self addSubview:self.imgBut3];
        
        [self addSubview:self.lable6];
        [self addSubview:self.but4];
        [self addSubview:self.imgBut4];
        
        [self addSubview:self.lable7];
        [self addSubview:self.but5];
        [self addSubview:self.imgBut5];
    }
    return self;
}

- (UILabel *)jcLable
{
    if (!_jcLable) {
        _jcLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, widths-40, 30)];
        _jcLable.text = [CommenUtil LocalizedString:@"Authen.MerchantsReferred"];
        _jcLable.alpha = 0.7;
        _jcLable.font = FT(15);
    }
    return _jcLable;
}

- (MLMinLeTextField *)jcTextField
{
    if (!_jcTextField) {
        _jcTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.jcLable.frame)+5, widths-40, 40)];
        _jcTextField.delegate = self;
        _jcTextField.font = FT(15);
    }
    return _jcTextField;
}

- (UILabel *)qcLable
{
    if (!_qcLable) {
        _qcLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.jcTextField.frame)+5, widths-40, 30)];
        _qcLable.text = [CommenUtil LocalizedString:@"Authen.MerchantsAllName"];
        _qcLable.alpha = 0.7;
        _qcLable.font = FT(15);
    }
    return _qcLable;
}

- (MLMinLeTextField *)qcTextField
{
    if (!_qcTextField) {
        _qcTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.qcLable.frame)+5, widths-40, 40)];
        _qcTextField.delegate = self;
        _qcTextField.font = FT(15);
    }
    return _qcTextField;
}

- (UILabel *)dzLable
{
    if (!_dzLable) {
        _dzLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.qcTextField.frame)+5, widths-40, 30)];
        _dzLable.text = [CommenUtil LocalizedString:@"Authen.MerchantsAddress"];
        _dzLable.alpha = 0.7;
        _dzLable.font = FT(15);
    }
    return _dzLable;
}

- (MLMinLeTextField *)dzTextField
{
    if (!_dzTextField) {
        _dzTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.dzLable.frame)+5, widths-40, 40)];
        _dzTextField.delegate = self;
        _dzTextField.font = FT(15);
    }
    return _dzTextField;
}

- (UILabel *)lable1
{
    if (!_lable1) {
        _lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.dzTextField.frame)+5, widths-40, 30)];
        _lable1.text = [CommenUtil LocalizedString:@"Authen.LegalName"];
        _lable1.alpha = 0.7;
        _lable1.font = FT(15);
    }
    return _lable1;
}

//法人姓名
- (MLMinLeTextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lable1.frame)+5, widths-40, 40)];
        _nameTextField.delegate = self;
        _nameTextField.font = FT(15);
    }
    return _nameTextField;
}

- (UILabel *)phoneLable
{
    if (!_phoneLable) {
        _phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameTextField.frame)+5, widths-40, 30)];
        _phoneLable.text = [CommenUtil LocalizedString:@"Authen.LegalPhone"];
        _phoneLable.alpha = 0.7;
        _phoneLable.font = FT(15);
    }
    return _phoneLable;
}

- (MLMinLeTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneLable.frame)+5, widths-40, 40)];
        _phoneTextField.delegate = self;
        _phoneTextField.font = FT(15);
        _phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;//数字带小数点键盘
    }
    return _phoneTextField;
}

- (UILabel *)lable2
{
    if (!_lable2) {
        _lable2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneTextField.frame)+5, widths-40, 30)];
        _lable2.text = [CommenUtil LocalizedString:@"Authen.LegalIDNumber"];
        _lable2.alpha = 0.7;
        _lable2.font = FT(15);
    }
    return _lable2;
}

- (MLMinLeTextField *)haomaTextField
{
    if (!_haomaTextField) {
        _haomaTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lable2.frame)+5, widths-40, 40)];
        _haomaTextField.delegate = self;
        _haomaTextField.font = FT(15);
    }
    return _haomaTextField;
}

- (UILabel *)yingYeLable
{
    if (!_yingYeLable) {
        _yingYeLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.haomaTextField.frame)+5, widths-40, 30)];
        _yingYeLable.text = [CommenUtil LocalizedString:@"Authen.BusinessLicense"];
        _yingYeLable.alpha = 0.7;
        _yingYeLable.font = FT(15);
    }
    return _yingYeLable;
}

- (MLMinLeTextField *)yingYeTextField
{
    if (!_yingYeTextField) {
        _yingYeTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.yingYeLable.frame)+5, widths-40, 40)];
        _yingYeTextField.delegate = self;
        _yingYeTextField.font = FT(15);
    }
    return _yingYeTextField;
}


- (UILabel *)lable3
{
    if (!_lable3) {
        _lable3 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.yingYeTextField.frame)+30, imgLeftLableWidth, 50)];
        ///租房协议照片
        _lable3.text = [CommenUtil LocalizedString:@"Authen.BusinessLicensePhoto"];
        _lable3.alpha = 0.7;
        _lable3.numberOfLines = 0;
        _lable3.font = FT(15);
    }
    return _lable3;
}

//门面button
- (UIButton *)but1
{
    if (!_but1) {
        _but1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but1.frame = CGRectMake(CGRectGetMaxX(self.lable3.frame)+middleJianxi, CGRectGetMinY(self.lable3.frame)+7.5, 35, 35);
        [_but1 setImage:[UIImage imageNamed:@"shangchuantupian"] forState:UIControlStateNormal];
        [_but1 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but1.tag = 10;
    }
    return _but1;
}

- (UIButton *)imgBut1
{
    if (!_imgBut1) {
        _imgBut1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgBut1.frame = CGRectMake(widths-40, CGRectGetMinY(self.but1.frame)+6.5, 20, 20);
        [_imgBut1 setImage:[UIImage imageNamed:@"suonuetu_03"] forState:UIControlStateNormal];
        _imgBut1.clipsToBounds = YES;
        _imgBut1.alpha = 0;
        _imgBut1.tag = 1;
        [_imgBut1 addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBut1;
}

- (UILabel *)lable4
{
    if (!_lable4) {
        _lable4 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lable3.frame)+30, imgLeftLableWidth, 30)];
        _lable4.text = [CommenUtil LocalizedString:@"Authen.MerchantsDealPhoto"];
        _lable4.alpha = 0.7;
        _lable4.font = FT(15);
    }
    return _lable4;
}

//办公场地button
- (UIButton *)but2
{
    if (!_but2) {
        _but2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but2.frame = CGRectMake(CGRectGetMaxX(self.lable4.frame)+middleJianxi, CGRectGetMinY(self.lable4.frame)-2.5, 35, 35);
        [_but2 setImage:[UIImage imageNamed:@"shangchuantupian"] forState:UIControlStateNormal];
        [_but2 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but2.tag = 11;
    }
    return _but2;
}

- (UIButton *)imgBut2
{
    if (!_imgBut2) {
        _imgBut2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgBut2.frame = CGRectMake(widths-40, CGRectGetMinY(self.but2.frame)+6.5, 20, 20);
        [_imgBut2 setImage:[UIImage imageNamed:@"suonuetu_03"] forState:UIControlStateNormal];
        _imgBut2.clipsToBounds = YES;
        _imgBut2.alpha = 0;
        _imgBut2.tag = 2;
        [_imgBut2 addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBut2;
}

- (UILabel *)lable5
{
    if (!_lable5) {
        _lable5 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lable4.frame)+30, imgLeftLableWidth, 30)];
        _lable5.text = [CommenUtil LocalizedString:@"Authen.DoorFirstPhoto"];
        _lable5.alpha = 0.7;
        _lable5.font = FT(15);
    }
    return _lable5;
}

//收银button
- (UIButton *)but3
{
    if (!_but3) {
        _but3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but3.frame = CGRectMake(CGRectGetMaxX(self.lable5.frame)+middleJianxi, CGRectGetMinY(self.lable5.frame)-2.5, 35, 35);
        [_but3 setImage:[UIImage imageNamed:@"shangchuantupian"] forState:UIControlStateNormal];
        [_but3 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but3.tag = 12;
    }
    return _but3;
}

- (UIButton *)imgBut3
{
    if (!_imgBut3) {
        _imgBut3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgBut3.frame = CGRectMake(widths-40, CGRectGetMinY(self.but3.frame)+6.5, 20, 20);
        [_imgBut3 setImage:[UIImage imageNamed:@"suonuetu_03"] forState:UIControlStateNormal];
        _imgBut3.clipsToBounds = YES;
        _imgBut3.alpha = 0;
        _imgBut3.tag = 3;
        [_imgBut3 addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBut3;
}

- (UILabel *)lable6
{
    if (!_lable6) {
        _lable6 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lable5.frame)+30, imgLeftLableWidth, 30)];
        _lable6.text = [CommenUtil LocalizedString:@"Authen.StorePhoto"];
        _lable6.alpha = 0.7;
        _lable6.font = FT(15);
    }
    return _lable6;
}

- (UIButton *)but4
{
    if (!_but4) {
        _but4 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but4.frame = CGRectMake(CGRectGetMaxX(self.lable6.frame)+middleJianxi, CGRectGetMinY(self.lable6.frame)-2.5, 35, 35);
        [_but4 setImage:[UIImage imageNamed:@"shangchuantupian"] forState:UIControlStateNormal];
        [_but4 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but4.tag = 13;
    }
    return _but4;
}

- (UIButton *)imgBut4
{
    if (!_imgBut4) {
        _imgBut4 = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgBut4.frame = CGRectMake(widths-40, CGRectGetMinY(self.but4.frame)+6.5, 20, 20);
        [_imgBut4 setImage:[UIImage imageNamed:@"suonuetu_03"] forState:UIControlStateNormal];
        _imgBut4.clipsToBounds = YES;
        _imgBut4.alpha = 0;
        _imgBut4.tag = 4;
        [_imgBut4 addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBut4;
}


- (UILabel *)lable7
{
    if (!_lable7) {
        _lable7 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lable6.frame)+30, imgLeftLableWidth, 30)];
        _lable7.text = [CommenUtil LocalizedString:@"Authen.CheckstandPhoto"];
        _lable7.alpha = 0.7;
        _lable7.font = FT(15);
    }
    return _lable7;
}

- (UIButton *)but5
{
    if (!_but5) {
        _but5 = [UIButton buttonWithType:UIButtonTypeCustom];
        _but5.frame = CGRectMake(CGRectGetMaxX(self.lable7.frame)+middleJianxi, CGRectGetMinY(self.lable7.frame)-2.5, 35, 35);
        [_but5 setImage:[UIImage imageNamed:@"shangchuantupian"] forState:UIControlStateNormal];
        [_but5 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but5.tag = 14;
    }
    return _but5;
}

- (UIButton *)imgBut5
{
    if (!_imgBut5) {
        _imgBut5 = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgBut5.frame = CGRectMake(widths-40, CGRectGetMinY(self.but5.frame)+6.5, 20, 20);
        [_imgBut5 setImage:[UIImage imageNamed:@"suonuetu_03"] forState:UIControlStateNormal];
        _imgBut5.clipsToBounds = YES;
        _imgBut5.alpha = 0;
        _imgBut5.tag = 5;
        [_imgBut5 addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBut5;
}

- (void)onAction:(UIButton *)sender
{
    [self.viewController.view endEditing:YES];
    [self.viewController showCanCameraEdit:YES photo:^(UIImage *photo) {
        if (sender.tag == 1) {
            [self.but1 setImage:photo forState:UIControlStateNormal];
        } else if (sender.tag == 2) {
            [self.but2 setImage:photo forState:UIControlStateNormal];
        } else if (sender.tag == 3) {
            [self.but3 setImage:photo forState:UIControlStateNormal];
        } else if (sender.tag == 4) {
            [self.but4 setImage:photo forState:UIControlStateNormal];
        } else if (sender.tag == 5) {
            [self.but5 setImage:photo forState:UIControlStateNormal];
        }
    }];
}

//获取相册图片回调
- (void)pushAction:(UIButton *)sender
{
    [self.viewController.view endEditing:YES];
    [self.viewController showCanCameraEdit:YES photo:^(UIImage *photo) {
        if (sender.tag == 10) {
            self.but1.layer.borderWidth = 1;
            self.but1.layer.borderColor = LayerRGB(92, 201, 152);
            [self.but1 setImage:photo forState:UIControlStateNormal];
            self.imgBut1.alpha = 1;
        } else if (sender.tag == 11) {
            self.but2.layer.borderWidth = 1;
            self.but2.layer.borderColor = LayerRGB(92, 201, 152);
            [self.but2 setImage:photo forState:UIControlStateNormal];
            self.imgBut2.alpha = 1;
        } else if (sender.tag == 12) {
            self.but3.layer.borderWidth = 1;
            self.but3.layer.borderColor = LayerRGB(92, 201, 152);
            [self.but3 setImage:photo forState:UIControlStateNormal];
            self.imgBut3.alpha = 1;
        } else if (sender.tag == 13) {
            self.but4.layer.borderWidth = 1;
            self.but4.layer.borderColor = LayerRGB(92, 201, 152);
            [self.but4 setImage:photo forState:UIControlStateNormal];
            self.imgBut4.alpha = 1;
        } else if (sender.tag == 14) {
            self.but5.layer.borderWidth = 1;
            self.but5.layer.borderColor = LayerRGB(92, 201, 152);
            [self.but5 setImage:photo forState:UIControlStateNormal];
            self.imgBut5.alpha = 1;
        }
    }];
}

#pragma mark - textField  delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
