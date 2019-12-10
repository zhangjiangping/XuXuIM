//
//  MLYHKAuthenticationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLYHKAuthenticationView.h"
#import "UIView+Responder.h"
#import "UIViewController+XHPhoto.h"
#import "AddressViewController.h"
#import "MLRegisterBankViewController.h"
#import "MLYHKCertificationViewController.h"
#import "AVCaptureViewController.h"
#import "XLBankScanViewController.h"

@interface MLYHKAuthenticationView () <UITextFieldDelegate>
{
    float defaultHeight;
    float defaultWidth;
}
@property (nonatomic, strong) UILabel *lable1;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UILabel *gerenLable;//个人账户
@property (nonatomic, strong) UILabel *gongsiLable;//公司账户
@property (nonatomic, strong) UILabel *yinghangStyleLable;//银行类型
@property (nonatomic, strong) UILabel *zhihangLable;//开户支行
@property (nonatomic, strong) UILabel *lhhLable;//开户支行
@property (nonatomic, strong) UILabel *kaihuYHLable;//开户银行
@property (nonatomic, strong) UILabel *kaihuCSLable;//开户城市
@property (nonatomic, strong) UIView *xianView1;
@property (nonatomic, strong) UIView *xianView2;
@property (nonatomic, strong) UIView *xianView3;
@property (nonatomic, strong) UIView *xianView4;

@property (nonatomic, strong) UILabel *yhkMessageLable;//提示信息lable
@property (nonatomic, strong) UIView *messageRightLineView;

@end

@implementation MLYHKAuthenticationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *str = [CommenUtil LocalizedString:@"Authen.CheckCardInfo"];
        defaultHeight = [CommenUtil getTxtHeight:str forContentWidth:widths-30 fotFontSize:12];
        defaultWidth = [CommenUtil getWidthWithContent:str height:defaultHeight font:12];
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    [self addSubview:self.yinghangStyleLable];
    [self addSubview:self.gerenLable];
    [self addSubview:self.gerenBut];
    [self addSubview:self.gongsiLable];
    [self addSubview:self.gongsiBut];
    [self addSubview:self.xianView3];
    
    [self addSubview:self.kaihuYHLable];
    [self addSubview:self.kaihuYHBut];
    [self addSubview:self.xianView1];
    
    [self addSubview:self.kaihuCSLable];
    [self addSubview:self.ccBut];
    [self addSubview:self.xianView2];
    
    [self addSubview:self.zhihangLable];
    [self addSubview:self.yhzhBut];
    [self addSubview:self.xianView4];
    
    [self addSubview:self.lhhLable];
    [self addSubview:self.textField_LHH];
    [self addSubview:self.lable1];
    [self addSubview:self.nameTextField];
    [self addSubview:self.lable2];
    [self addSubview:self.haomaTextField];
    
    [self addSubview:self.cerYHKView];
    [self addSubview:self.yhkMessageLable];
    [self addSubview:self.messageRightLineView];
    [self addSubview:self.cardNumberTextField];
}

#pragma mark - getter

- (UILabel *)yinghangStyleLable
{
    if (!_yinghangStyleLable) {
        _yinghangStyleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 50)];
        _yinghangStyleLable.text = [CommenUtil LocalizedString:@"Authen.BankState"];
        _yinghangStyleLable.font = FT(15);
    }
    return _yinghangStyleLable;
}
- (UIButton *)gerenBut
{
    if (!_gerenBut) {
        _gerenBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _gerenBut.frame = CGRectMake(CGRectGetMaxX(self.yinghangStyleLable.frame)+10, 27.5, 15, 15);
        [_gerenBut setImage:[UIImage imageNamed:@"quanquan_03"] forState:UIControlStateNormal];
        [_gerenBut setImage:[UIImage imageNamed:@"quanquan_05"] forState:UIControlStateSelected];
        [_gerenBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _gerenBut.tag = 1;
    }
    return _gerenBut;
}
- (UILabel *)gerenLable
{
    if (!_gerenLable) {
        _gerenLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gerenBut.frame)+5, 10, 60, 50)];
        _gerenLable.adjustsFontSizeToFitWidth = YES;
        _gerenLable.text = [CommenUtil LocalizedString:@"Authen.IndividualAccount"];
        _gerenLable.font = FT(14);
        _gerenLable.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _gerenLable;
}
- (UIButton *)gongsiBut
{
    if (!_gongsiBut) {
        _gongsiBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _gongsiBut.frame = CGRectMake(CGRectGetMaxX(self.gerenLable.frame)+10, 27.5, 15, 15);
        [_gongsiBut setImage:[UIImage imageNamed:@"quanquan_05"] forState:UIControlStateNormal];
        [_gongsiBut setImage:[UIImage imageNamed:@"quanquan_03"] forState:UIControlStateSelected];
        [_gongsiBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _gongsiBut.tag = 2;
    }
    return _gongsiBut;
}
- (UILabel *)gongsiLable
{
    if (!_gongsiLable) {
        _gongsiLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gongsiBut.frame)+5, 10, 60, 50)];
        _gongsiLable.adjustsFontSizeToFitWidth = YES;
        _gongsiLable.text = [CommenUtil LocalizedString:@"Authen.CompanyAccount"];
        _gongsiLable.font = FT(14);
        _gongsiLable.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _gongsiLable;
}

- (UIView *)xianView3
{
    if (!_xianView3) {
        _xianView3 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.gongsiLable.frame)-1, widths-20, 1)];
        _xianView3.backgroundColor = [UIColor lightGrayColor];
        _xianView3.alpha = 0.5;
    }
    return _xianView3;
}

- (UILabel *)kaihuYHLable
{
    if (!_kaihuYHLable) {
        _kaihuYHLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.yinghangStyleLable.frame), 80, 50)];
        _kaihuYHLable.text = [CommenUtil LocalizedString:@"Authen.OpenBank"];
        _kaihuYHLable.font = FT(15);
    }
    return _kaihuYHLable;
}

- (UIButton *)kaihuYHBut
{
    if (!_kaihuYHBut) {
        _kaihuYHBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _kaihuYHBut.frame = CGRectMake(CGRectGetMaxX(self.kaihuYHLable.frame), CGRectGetMinY(self.kaihuYHLable.frame), widths-CGRectGetMaxX(self.kaihuYHLable.frame)-15, 50);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.kaihuYHBut.frame)-15, 17.5, 15, 15)];
        img.image = [UIImage imageNamed:@"yhBut"];
        [_kaihuYHBut addSubview:img];
        
        [_kaihuYHBut addSubview:self.yinhangNameLable];
        
        [_kaihuYHBut addTarget:self action:@selector(toAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kaihuYHBut;
}

- (UIView *)xianView1
{
    if (!_xianView1) {
        _xianView1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.kaihuYHBut.frame)-1, widths-20, 1)];
        _xianView1.backgroundColor = [UIColor lightGrayColor];
        _xianView1.alpha = 0.5;
    }
    return _xianView1;
}

- (UILabel *)yinhangNameLable
{
    if (!_yinhangNameLable) {
        _yinhangNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.kaihuYHBut.frame)-15-5, 50)];
        _yinhangNameLable.text = [CommenUtil LocalizedString:@"Authen.PleaseSelectedBank"];
        _yinhangNameLable.textColor = [UIColor lightGrayColor];
        _yinhangNameLable.textAlignment = NSTextAlignmentRight;
        _yinhangNameLable.adjustsFontSizeToFitWidth = YES;
        _yinhangNameLable.contentMode = UIViewContentModeScaleAspectFill;
        _yinhangNameLable.font = FT(15);
    }
    return _yinhangNameLable;
}

- (UILabel *)kaihuCSLable
{
    if (!_kaihuCSLable) {
        _kaihuCSLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.kaihuYHLable.frame), 80, 50)];
        _kaihuCSLable.text = [CommenUtil LocalizedString:@"Authen.OpenCity"];
        _kaihuCSLable.font = FT(15);
    }
    return _kaihuCSLable;
}

- (UIButton *)ccBut
{
    if (!_ccBut) {
        _ccBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _ccBut.frame = CGRectMake(CGRectGetMaxX(self.kaihuCSLable.frame), CGRectGetMinY(self.kaihuCSLable.frame), widths-CGRectGetMaxX(self.kaihuCSLable.frame)-15, 50);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.kaihuYHBut.frame)-15, 17.5, 15, 15)];
        img.image = [UIImage imageNamed:@"yhBut"];
        [_ccBut addSubview:img];
        
        [_ccBut addSubview:self.cityNameLable];
        
        [_ccBut addTarget:self action:@selector(xuanzeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ccBut;
}

- (UIView *)xianView2
{
    if (!_xianView2) {
        _xianView2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.ccBut.frame)-1, widths-20, 1)];
        _xianView2.backgroundColor = [UIColor lightGrayColor];
        _xianView2.alpha = 0.5;
    }
    return _xianView2;
}

- (UILabel *)cityNameLable
{
    if (!_cityNameLable) {
        _cityNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.ccBut.frame)-15-5, 50)];
        _cityNameLable.text = [CommenUtil LocalizedString:@"Authen.PleaseSelectedCity"];
        _cityNameLable.textColor = [UIColor lightGrayColor];
        _cityNameLable.textAlignment = NSTextAlignmentRight;
        _cityNameLable.adjustsFontSizeToFitWidth = YES;
        _cityNameLable.contentMode = UIViewContentModeScaleAspectFill;
        _cityNameLable.font = FT(15);
    }
    return _cityNameLable;
}

- (UILabel *)zhihangLable
{
    if (!_zhihangLable) {
        _zhihangLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.kaihuCSLable.frame), 80, 50)];
        _zhihangLable.text = [CommenUtil LocalizedString:@"Authen.OpenBranch"];
        _zhihangLable.font = FT(15);
    }
    return _zhihangLable;
}

- (UIButton *)yhzhBut
{
    if (!_yhzhBut) {
        _yhzhBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _yhzhBut.frame = CGRectMake(CGRectGetMaxX(self.zhihangLable.frame), CGRectGetMinY(self.zhihangLable.frame), widths-CGRectGetMaxX(self.zhihangLable.frame)-15, 50);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.yhzhBut.frame)-15, 17.5, 15, 15)];
        img.image = [UIImage imageNamed:@"yhBut"];
        [_yhzhBut addSubview:img];
        
        [_yhzhBut addSubview:self.zhihangNameLable];
        
    }
    return _yhzhBut;
}

- (UILabel *)zhihangNameLable
{
    if (!_zhihangNameLable) {
        _zhihangNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.yhzhBut.frame)-15-5, 50)];
        _zhihangNameLable.text = [CommenUtil LocalizedString:@"Authen.PleaseSelectedBranch"];
        _zhihangNameLable.textColor = [UIColor lightGrayColor];
        _zhihangNameLable.textAlignment = NSTextAlignmentRight;
        _zhihangNameLable.adjustsFontSizeToFitWidth = YES;
        _zhihangNameLable.contentMode = UIViewContentModeScaleAspectFill;
        _zhihangNameLable.font = FT(15);
    }
    return _zhihangNameLable;
}

- (UIView *)xianView4
{
    if (!_xianView4) {
        _xianView4 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.zhihangLable.frame)-1, widths-20, 1)];
        _xianView4.backgroundColor = [UIColor lightGrayColor];
        _xianView4.alpha = 0.5;
    }
    return _xianView4;
}

- (UILabel *)lhhLable
{
    if (!_lhhLable) {
        _lhhLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.yhzhBut.frame)+10, widths-40, 30)];
        _lhhLable.text = [CommenUtil LocalizedString:@"Authen.LianHnagHao"];
        _lhhLable.font = FT(15);
    }
    return _lhhLable;
}
- (MLMinLeTextField *)textField_LHH
{
    if (!_textField_LHH) {
        _textField_LHH = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lhhLable.frame)+5, widths-40, 40)];
        _textField_LHH.font = FT(15);
    }
    return _textField_LHH;
}

- (UILabel *)lable1
{
    if (!_lable1) {
        _lable1 = [[UILabel alloc] init];
        _lable1.frame = CGRectMake(20, CGRectGetMaxY(self.textField_LHH.frame)+5, widths-40, 30);
        _lable1.text = [CommenUtil LocalizedString:@"Authen.OpenName"];
        _lable1.font = FT(15);
    }
    return _lable1;
}

- (MLMinLeTextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lable1.frame)+5, widths-40, 40)];
        _nameTextField.delegate = self;
        _nameTextField.font = FT(15);
    }
    return _nameTextField;
}

- (UILabel *)lable2
{
    if (!_lable2) {
        _lable2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameTextField.frame)+5, widths-40, 30)];
        _lable2.text = [CommenUtil LocalizedString:@"Authen.ReservedPhone"];
        _lable2.font = FT(15);
    }
    return _lable2;
}

- (MLMinLeTextField *)haomaTextField
{
    if (!_haomaTextField) {
        _haomaTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.lable2.frame)+5, widths-40, 40)];
        _haomaTextField.delegate = self;
        _haomaTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _haomaTextField.font = FT(15);
    }
    return _haomaTextField;
}

- (CertificationView *)cerYHKView
{
    if (!_cerYHKView) {
        _cerYHKView = [[CertificationView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.haomaTextField.frame)+30, widths-40, 131) withLeftImgName:@"bank-card" withAddName:[CommenUtil LocalizedString:@"Authen.TapShootBank"]];
        [_cerYHKView.rightBut addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        _cerYHKView.state = TakingPicturesStateDefault;
    }
    return _cerYHKView;
}

- (UILabel *)yhkMessageLable
{
    if (!_yhkMessageLable) {
        _yhkMessageLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.cerYHKView.frame)+22.5, defaultWidth, defaultHeight)];
        _yhkMessageLable.font = FT(12);
        _yhkMessageLable.text = [CommenUtil LocalizedString:@"Authen.CheckAndTure"];
        _yhkMessageLable.hidden = YES;
    }
    return _yhkMessageLable;
}

- (UIView *)messageRightLineView
{
    if (!_messageRightLineView) {
        _messageRightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.yhkMessageLable.frame)+5, CGRectGetMinY(self.yhkMessageLable.frame)+(defaultHeight-0.5)/2, widths-(CGRectGetMaxX(self.yhkMessageLable.frame)+5), 0.5)];
        _messageRightLineView.backgroundColor = RGB(85, 85, 85);
        _messageRightLineView.alpha = 0.25;
        _messageRightLineView.hidden = YES;
    }
    return _messageRightLineView;
}

- (MLMinLeTextField *)cardNumberTextField
{
    if (!_cardNumberTextField) {
        _cardNumberTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.yhkMessageLable.frame)+20, widths-40, 50)];
        _cardNumberTextField.hidden = YES;
    }
    return _cardNumberTextField;
}

#pragma mark - action

- (void)addAction:(UIButton *)sender
{
    [self.viewController.view endEditing:YES];
    
    XLBankScanViewController *bankVc = [[XLBankScanViewController alloc] init];
    bankVc.type = BankCardTypePositive;
    bankVc.block = ^(IDInfo *info) {
        _cerYHKView.state = TakingPicturesStateEnded;
        _cerYHKView.leftImg.image = info.bankImage;
        self.cardNumberTextField.text = info.bankNumber;
        
        self.yhkMessageLable.hidden = NO;
        self.messageRightLineView.hidden = NO;
        self.cardNumberTextField.hidden = NO;
        self.size = CGSizeMake(widths, 742.5+defaultHeight);
        if (self.yhkDelegate && [self.yhkDelegate respondsToSelector:@selector(selectedEnder)]) {
            [self.yhkDelegate selectedEnder];
        }
    };
    [self.viewController.navigationController pushViewController:bankVc animated:YES];
}

- (void)xuanzeAction:(UIButton *)sender
{
    [self celearData];
    
    AddressViewController *addressVC = [[AddressViewController alloc] init];
    addressVC.block = ^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        ((MLYHKCertificationViewController *)self.viewController).ccStr = dic[@"two"];
        _cityNameLable.text = dic[@"three"];
        _cityNameLable.textColor = [UIColor blackColor];
    };
    [self.viewController.navigationController pushViewController:addressVC animated:YES];
}

- (void)toAction:(UIButton *)sender
{
    [self celearData];
    
    MLRegisterBankViewController *bankVC = [[MLRegisterBankViewController alloc] init];
    bankVC.block = ^(NSDictionary *dic) {
        ((MLYHKCertificationViewController *)self.viewController).bankStr = dic[@"code"];
        _yinhangNameLable.textColor = [UIColor blackColor];
        _yinhangNameLable.text = dic[@"name"];
    };
    [self.viewController.navigationController pushViewController:bankVC animated:YES];
}

//再次点击清空原有信息
- (void)celearData
{
    [self.viewController.view endEditing:YES];
    
    if (self.textField_LHH.text.length != 0) {
        self.textField_LHH.text = @"";
    }
    if (![self.zhihangNameLable.text isEqualToString:[CommenUtil LocalizedString:@"Authen.PleaseSelectedBranch"]]) {
        self.zhihangNameLable.text = [CommenUtil LocalizedString:@"Authen.PleaseSelectedBranch"];
        self.zhihangNameLable.textColor = [UIColor lightGrayColor];
    }
}

- (void)onAction:(UIButton *)sender
{
    UIButton *but1 = [self viewWithTag:1];
    UIButton *but2 = [self viewWithTag:2];
    if ([sender isEqual:but1]) {
        if (but1.selected) {
            but1.selected = NO;
            but2.selected = NO;
        }
    } else {
        if (!but2.selected) {
            but1.selected = YES;
            but2.selected = YES;
        }
    }
}

#pragma mark - UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end










