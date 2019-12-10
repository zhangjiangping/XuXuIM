//
//  MLMyDataView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/14.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyDataView.h"

@interface MLMyDataView () <UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *titleLable;//标题
@property (nonatomic, strong) UILabel *jianchengLable;//商户简称
@property (nonatomic, strong) UILabel *quanchengLable;//商户全称
@property (nonatomic, strong) UILabel *peopleLable;//法人信息
@property (nonatomic, strong) UILabel *sfzHaoLable;//身份证号
@property (nonatomic, strong) UILabel *dailishangLable;//代理商
@property (nonatomic, strong) UILabel *jiesuanLable;//结算银行信息
@property (nonatomic, strong) UIView *lineView;//分割线视图
@property (nonatomic, strong) UILabel *yinghangStyleLable;//银行类型
@property (nonatomic, strong) UILabel *kaihuYHLable;//开户银行
@property (nonatomic, strong) UILabel *kaihuCSLable;//开户城市
@property (nonatomic, strong) UILabel *yinghangKHLable;//银行卡号
@property (nonatomic, strong) UILabel *zhihangLable;//开户支行
@property (nonatomic, strong) UILabel *kaihuNameLable;//开户名称
@property (nonatomic, strong) UILabel *landingPassLable;//登录密码
@property (nonatomic, strong) UILabel *tureLandingLable;//确认密码
@property (nonatomic, strong) UILabel *gerenLable;//个人账户
@property (nonatomic, strong) UILabel *gongsiLable;//公司账户
@property (nonatomic, strong) UILabel *userNameLable;//民生电子账户
@end

@implementation MLMyDataView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //注册通知（监听者）键盘出现
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowV:) name:UIKeyboardWillShowNotification object:nil];
        //注册键盘隐藏的监听者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHiddenV:) name:UIKeyboardWillHideNotification object:nil];
        [self createView];
    }
    return self;
}

- (void)createView
{
    [self addSubview:self.dataView];
    [self.dataView addSubview:self.titleLable];
    [self.dataView addSubview:self.jianchengLable];
    [self.dataView addSubview:self.textField_JC];
    [self.dataView addSubview:self.quanchengLable];
    [self.dataView addSubview:self.textField_QC];
    [self.dataView addSubview:self.peopleLable];
    [self.dataView addSubview:self.textField_FR];
    [self.dataView addSubview:self.sfzHaoLable];
    [self.dataView addSubview:self.textField_SFZH];
    [self.dataView addSubview:self.dailishangLable];
    [self.dataView addSubview:self.textField_DLS];
    [self.dataView addSubview:self.jiesuanLable];
    [self.dataView addSubview:self.lineView];
    [self.dataView addSubview:self.yinghangStyleLable];
    [self.dataView addSubview:self.gerenBut];
    [self.dataView addSubview:self.gerenLable];
    [self.dataView addSubview:self.gongsiBut];
    [self.dataView addSubview:self.gongsiLable];
    [self.dataView addSubview:self.kaihuYHLable];
    [self.dataView addSubview:self.kaihuYHBut];
    [self.dataView addSubview:self.kaihuCSLable];
    [self.dataView addSubview:self.ccBut];
    [self.dataView addSubview:self.yinghangKHLable];
    [self.dataView addSubview:self.textField_YHKH];
    [self.dataView addSubview:self.zhihangLable];
    [self.dataView addSubview:self.textField_YHZH];
    [self.dataView addSubview:self.kaihuNameLable];
    [self.dataView addSubview:self.textField_KHName];
    [self.dataView addSubview:self.userNameLable];
    [self.dataView addSubview:self.textField_Email];
    [self.dataView addSubview:self.landingPassLable];
    [self.dataView addSubview:self.textField_DLMM];
    [self.dataView addSubview:self.tureLandingLable];
    [self.dataView addSubview:self.textField_TMM];
    [self.dataView addSubview:self.submitBut];
}

#pragma mark - getter setter
- (UIView *)dataView
{
    if (!_dataView) {
        _dataView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _dataView.contentSize = CGSizeMake(widths, heights+280);
    }
    return _dataView;
}
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, widths, 30)];
        _titleLable.text = @"商户资料";
        _titleLable.font = FT(26);
        _titleLable.textColor = RGB(2, 145, 255);
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}
- (UILabel *)jianchengLable
{
    if (!_jianchengLable) {
        _jianchengLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"商户简称 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _jianchengLable.attributedText = hintString;
    }
    return _jianchengLable;
}
- (MLRegisterTextField *)textField_JC
{
    if (!_textField_JC) {
        _textField_JC = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.jianchengLable.frame)+5, CGRectGetMaxY(self.titleLable.frame)+20, widths-CGRectGetMaxX(self.jianchengLable.frame)-20, 30)];
        _textField_JC.textField.delegate = self;
    }
    return _textField_JC;
}
- (UILabel *)quanchengLable
{
    if (!_quanchengLable) {
        _quanchengLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.jianchengLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"商户全称 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _quanchengLable.attributedText = hintString;
    }
    return _quanchengLable;
}
- (MLRegisterTextField *)textField_QC
{
    if (!_textField_QC) {
        _textField_QC = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.quanchengLable.frame)+5, CGRectGetMaxY(self.textField_JC.frame)+20, widths-CGRectGetMaxX(self.quanchengLable.frame)-20, 30)];
        _textField_QC.textField.delegate = self;
    }
    return _textField_QC;
}
- (UILabel *)peopleLable
{
    if (!_peopleLable) {
        _peopleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.quanchengLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"法人信息 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _peopleLable.attributedText = hintString;
    }
    return _peopleLable;
}
- (MLRegisterTextField *)textField_FR
{
    if (!_textField_FR) {
        _textField_FR = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.peopleLable.frame)+5, CGRectGetMaxY(self.textField_QC.frame)+20, widths-CGRectGetMaxX(self.peopleLable.frame)-20, 30)];
        _textField_FR.textField.delegate = self;
    }
    return _textField_FR;
}
- (UILabel *)sfzHaoLable
{
    if (!_sfzHaoLable) {
        _sfzHaoLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.peopleLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"身份证号 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _sfzHaoLable.attributedText = hintString;
    }
    return _sfzHaoLable;
}
- (MLRegisterTextField *)textField_SFZH
{
    if (!_textField_SFZH) {
        _textField_SFZH = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sfzHaoLable.frame)+5, CGRectGetMaxY(self.textField_FR.frame)+20, widths-CGRectGetMaxX(self.sfzHaoLable.frame)-20, 30)];
        _textField_SFZH.textField.delegate = self;
    }
    return _textField_SFZH;
}
- (UILabel *)dailishangLable
{
    if (!_dailishangLable) {
        _dailishangLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.sfzHaoLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"代理商编号 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _dailishangLable.attributedText = hintString;
    }
    return _dailishangLable;
}
- (MLRegisterTextField *)textField_DLS
{
    if (!_textField_DLS) {
        _textField_DLS = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dailishangLable.frame)+5, CGRectGetMaxY(self.textField_SFZH.frame)+20, widths-CGRectGetMaxX(self.dailishangLable.frame)-20, 30)];
        _textField_DLS.textField.delegate = self;
    }
    return _textField_DLS;
}
- (UILabel *)jiesuanLable
{
    if (!_jiesuanLable) {
        _jiesuanLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.dailishangLable.frame)+20, 150, 30)];
        _jiesuanLable.text = @"结算银行信息";
    }
    return _jiesuanLable;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.jiesuanLable.frame)+8, widths-20, 0.5)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
}
- (UILabel *)yinghangStyleLable
{
    if (!_yinghangStyleLable) {
        _yinghangStyleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.jiesuanLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"银行类型 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _yinghangStyleLable.attributedText = hintString;
    }
    return _yinghangStyleLable;
}
- (UIButton *)gerenBut
{
    if (!_gerenBut) {
        _gerenBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _gerenBut.frame = CGRectMake(CGRectGetMaxX(self.yinghangStyleLable.frame)+5, CGRectGetMaxY(self.jiesuanLable.frame)+25, 20, 20);
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
        _gerenLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gerenBut.frame)+5, CGRectGetMaxY(self.jiesuanLable.frame)+20, 60, 30)];
        _gerenLable.adjustsFontSizeToFitWidth = YES;
        _gerenLable.alpha = 0.5;
        _gerenLable.text = @"个人账户";
        _gerenLable.font = FT(15);
    }
    return _gerenLable;
}
- (UIButton *)gongsiBut
{
    if (!_gongsiBut) {
        _gongsiBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _gongsiBut.frame = CGRectMake(CGRectGetMaxX(self.gerenLable.frame)+30, CGRectGetMaxY(self.jiesuanLable.frame)+25, 20, 20);
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
        _gongsiLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.gongsiBut.frame)+5, CGRectGetMaxY(self.jiesuanLable.frame)+20, 60, 30)];
        _gongsiLable.adjustsFontSizeToFitWidth = YES;
        _gongsiLable.alpha = 0.5;
        _gongsiLable.text = @"公司账户";
        _gongsiLable.font = FT(15);
    }
    return _gongsiLable;
}
- (UILabel *)kaihuYHLable
{
    if (!_kaihuYHLable) {
        _kaihuYHLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.yinghangStyleLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"开户银行 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _kaihuYHLable.attributedText = hintString;
    }
    return _kaihuYHLable;
}

- (UIButton *)kaihuYHBut
{
    if (!_kaihuYHBut) {
        _kaihuYHBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _kaihuYHBut.frame = CGRectMake(CGRectGetMaxX(self.kaihuYHLable.frame), CGRectGetMaxY(self.yinghangStyleLable.frame)+20, widths-CGRectGetMaxX(self.kaihuYHLable.frame)-20, 30);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.kaihuYHBut.frame)-19, 5.5, 19, 19)];
        img.image = [UIImage imageNamed:@"yhBut"];
        [_kaihuYHBut addSubview:img];
        
        [_kaihuYHBut addSubview:self.yinhangNameLable];
        
        UIView *xianView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, CGRectGetWidth(self.kaihuYHBut.frame)-19-5, 1)];
        xianView.backgroundColor = [UIColor lightGrayColor];
        xianView.alpha = 0.5;
        [_kaihuYHBut addSubview:xianView];
    }
    return _kaihuYHBut;
}

- (UILabel *)yinhangNameLable
{
    if (!_yinhangNameLable) {
        _yinhangNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.kaihuYHBut.frame)-19-5, 30)];
        _yinhangNameLable.text = @"请选择开户银行";
        _yinhangNameLable.textColor = [UIColor lightGrayColor];
        _yinhangNameLable.textAlignment = NSTextAlignmentRight;
    }
    return _yinhangNameLable;
}

- (UILabel *)kaihuCSLable
{
    if (!_kaihuCSLable) {
        _kaihuCSLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.kaihuYHLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"开户城市 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _kaihuCSLable.attributedText = hintString;
    }
    return _kaihuCSLable;
}

- (UIButton *)ccBut
{
    if (!_ccBut) {
        _ccBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _ccBut.frame = CGRectMake(CGRectGetMaxX(self.kaihuCSLable.frame), CGRectGetMaxY(self.kaihuYHBut.frame)+20, widths-CGRectGetMaxX(self.yinghangKHLable.frame)-20, 30);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.kaihuYHBut.frame)-19, 5.5, 19, 19)];
        img.image = [UIImage imageNamed:@"yhBut"];
        [_ccBut addSubview:img];
        
        [_ccBut addSubview:self.cityNameLable];
        
        UIView *xianView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, CGRectGetWidth(self.ccBut.frame)-19-5, 1)];
        xianView.backgroundColor = [UIColor lightGrayColor];
        xianView.alpha = 0.5;
        [_ccBut addSubview:xianView];
    }
    return _ccBut;
}

- (UILabel *)cityNameLable
{
    if (!_cityNameLable) {
        _cityNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.ccBut.frame)-19-5, 30)];
        _cityNameLable.text = @"请选择开户城市";
        _cityNameLable.textColor = [UIColor lightGrayColor];
        _cityNameLable.textAlignment = NSTextAlignmentRight;
    }
    return _cityNameLable;
}

- (UILabel *)yinghangKHLable
{
    if (!_yinghangKHLable) {
        _yinghangKHLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.kaihuCSLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"银行卡号 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _yinghangKHLable.attributedText = hintString;
    }
    return _yinghangKHLable;
}
- (MLRegisterTextField *)textField_YHKH
{
    if (!_textField_YHKH) {
        _textField_YHKH = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.yinghangKHLable.frame)+5, CGRectGetMaxY(self.ccBut.frame)+20, widths-CGRectGetMaxX(self.yinghangKHLable.frame)-20, 30)];
        _textField_YHKH.textField.delegate = self;
    }
    return _textField_YHKH;
}
- (UILabel *)zhihangLable
{
    if (!_zhihangLable) {
        _zhihangLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.textField_YHKH.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"开户支行 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _zhihangLable.attributedText = hintString;
    }
    return _zhihangLable;
}
- (MLRegisterTextField *)textField_YHZH
{
    if (!_textField_YHZH) {
        _textField_YHZH = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.zhihangLable.frame)+5, CGRectGetMaxY(self.textField_YHKH.frame)+20, widths-CGRectGetMaxX(self.zhihangLable.frame)-20, 30)];
        _textField_YHZH.textField.delegate = self;
    }
    return _textField_YHZH;
}

- (UILabel *)kaihuNameLable
{
    if (!_kaihuNameLable) {
        _kaihuNameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.zhihangLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:@"开户名称 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _kaihuNameLable.attributedText = hintString;
    }
    return _kaihuNameLable;
}

- (MLRegisterTextField *)textField_KHName
{
    if (!_textField_KHName) {
        _textField_KHName = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.kaihuNameLable.frame)+5, CGRectGetMaxY(self.textField_YHZH.frame)+20, widths-CGRectGetMaxX(self.kaihuNameLable.frame)-20, 30)];
        _textField_KHName.textField.delegate = self;
    }
    return _textField_KHName;
}

- (UILabel *)userNameLable
{
    if (!_userNameLable) {
        _userNameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.kaihuNameLable.frame)+20, 110, 30)];
        _userNameLable.text = @"民生电子账户";
    }
    return _userNameLable;
}

- (MLRegisterTextField *)textField_Email
{
    if (!_textField_Email) {
        _textField_Email = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLable.frame)+5, CGRectGetMinY(self.userNameLable.frame), widths-CGRectGetMaxX(self.userNameLable.frame)-20, 30)];
        _textField_Email.textField.delegate = self;
        _textField_Email.textField.placeholder = @"选填";
    }
    return _textField_Email;
}

- (UILabel *)landingPassLable
{
    if (!_landingPassLable) {
        _landingPassLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.textField_Email.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString= [[NSMutableAttributedString alloc]initWithString:@"登录密码 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _landingPassLable.attributedText = hintString;
    }
    return _landingPassLable;
}
- (MLRegisterTextField *)textField_DLMM
{
    if (!_textField_DLMM) {
        _textField_DLMM = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.landingPassLable.frame)+5, CGRectGetMaxY(self.textField_Email.frame)+20, widths-CGRectGetMaxX(self.landingPassLable.frame)-20, 30)];
        _textField_DLMM.textField.secureTextEntry = YES;//密码形式
        _textField_DLMM.textField.delegate = self;
        _textField_DLMM.textField.placeholder = @"请输入6至12位数字或字母";
    }
    return _textField_DLMM;
}
- (UILabel *)tureLandingLable
{
    if (!_tureLandingLable) {
        _tureLandingLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.landingPassLable.frame)+20, 110, 30)];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"确认密码 *"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range = [[hintString string]rangeOfString:@"*"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        _tureLandingLable.attributedText = hintString;
    }
    return _tureLandingLable;
}
- (MLRegisterTextField *)textField_TMM
{
    if (!_textField_TMM) {
        _textField_TMM = [[MLRegisterTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tureLandingLable.frame)+5, CGRectGetMaxY(self.landingPassLable.frame)+20, widths-CGRectGetMaxX(self.tureLandingLable.frame)-20, 30)];
        _textField_TMM.textField.secureTextEntry = YES;//密码形式
        _textField_TMM.textField.delegate = self;
        _textField_TMM.textField.placeholder = @"请输入6至12位数字或字母";
    }
    return _textField_TMM;
}
- (UIButton *)submitBut
{
    if (!_submitBut) {
        _submitBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _submitBut.frame = CGRectMake(30, CGRectGetMaxY(self.textField_TMM.frame)+40, widths-60, 40);
        [_submitBut setTitle:[CommenUtil LocalizedString:@"Common.Submit"] forState:UIControlStateNormal];
        [_submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBut.backgroundColor = RGB(2, 145, 255);
        _submitBut.layer.cornerRadius = 5;
    }
    return _submitBut;
}

#pragma mark -----键盘弹出响应通知方法
-(void)keyboardShowV:(NSNotification *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.dataView.contentSize = CGSizeMake(CGRectGetWidth(self.dataView.frame), CGRectGetHeight(self.dataView.frame)+540);
    }];
}

#pragma mark -----隐藏键盘的时候调回原来的样子
-(void)keyboardHiddenV:(NSNotification *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        self.dataView.contentSize = CGSizeMake(widths, heights+280);
        [self.dataView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

#pragma mark - textField 代理

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _textField_YHKH.textField   ||
        textField == _textField_YHZH.textField   ||
        textField == _textField_KHName.textField ||
        textField == _textField_Email.textField  ||
        textField == _textField_DLMM.textField   ||
        textField == _textField_TMM.textField) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.dataView setContentOffset:CGPointMake(0, 450) animated:YES];
        }];
    }
    return YES;
}

//点击return取消键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action

- (void)onAction:(UIButton *)sender
{
    UIButton *but1 = [self.dataView viewWithTag:1];
    UIButton *but2 = [self.dataView viewWithTag:2];
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

@end



