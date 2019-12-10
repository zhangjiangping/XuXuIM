//
//  MLNoCardCodeView.m
//  minlePay
//
//  Created by JP on 2017/11/9.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLNoCardCodeView.h"

@interface MLNoCardCodeView ()

@property (nonatomic, strong) UILabel *orderTradingMoneyLable;//订单交易金额
@property (nonatomic, strong) UILabel *cardNameLable;//结算卡姓名
@property (nonatomic, strong) UILabel *haomaLable;//身份证号码
@property (nonatomic, strong) UILabel *settlementBorrowLable;//结算借记卡卡号
@property (nonatomic, strong) UILabel *phoneNumberLable;//手机号
@property (nonatomic, strong) UILabel *smsLable;//手机号

@end

@implementation MLNoCardCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    [self addSubview:self.smsLable];
    [self addSubview:self.smsCodeTextField];
    [self addSubview:self.smsCodeBut];
    
    [self addSubview:self.orderTradingMoneyLable];
    [self addSubview:self.orderTradingMoneyTextField];
    
    [self addSubview:self.cardNameLable];
    [self addSubview:self.cardNameTextField];
    
    [self addSubview:self.haomaLable];
    [self addSubview:self.haomaTextField];
    
    [self addSubview:self.settlementBorrowLable];
    [self addSubview:self.settlementBorrowTextField];
    
    [self addSubview:self.phoneNumberLable];
    [self addSubview:self.phoneNumberTextField];
}

- (UILabel *)smsLable
{
    if (!_smsLable) {
        _smsLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, widths-40, 30)];
        _smsLable.text = [CommenUtil LocalizedString:@"NoCard.GetSMSCode"];
        _smsLable.font = FT(15);
    }
    return _smsLable;
}

- (MLMinLeTextField *)smsCodeTextField
{
    if (!_smsCodeTextField) {
        _smsCodeTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.smsLable.frame)+5, (widths-80)/2, 40)];
        _smsCodeTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _smsCodeTextField.font = FT(15);
        _smsCodeTextField.placeholder = [CommenUtil LocalizedString:@"NoCard.InputCode"];
    }
    return _smsCodeTextField;
}

- (UIButton *)smsCodeBut
{
    if (!_smsCodeBut) {
        _smsCodeBut= [UIButton buttonWithType:UIButtonTypeSystem];
        _smsCodeBut.backgroundColor = blueRGB;
        _smsCodeBut.frame = CGRectMake(40+CGRectGetMaxX(self.smsCodeTextField.frame), CGRectGetMinY(self.smsCodeTextField.frame), (widths-80)/2, 40);
        _smsCodeBut.layer.cornerRadius = 10;

        _smsCodeLable = [[UILabel alloc] initWithFrame:_smsCodeBut.bounds];
        _smsCodeLable.text = [CommenUtil LocalizedString:@"NoCard.TapSendCode"];
        _smsCodeLable.textColor = [UIColor whiteColor];
        _smsCodeLable.adjustsFontSizeToFitWidth = YES;
        _smsCodeLable.contentMode = UIViewContentModeScaleAspectFill;
        _smsCodeLable.layer.cornerRadius = 10;
        _smsCodeLable.font = FT(15);
        _smsCodeLable.textAlignment = NSTextAlignmentCenter;
        [_smsCodeBut addSubview:_smsCodeLable];
    }
    return _smsCodeBut;
}

- (UILabel *)orderTradingMoneyLable
{
    if (!_orderTradingMoneyLable) {
        _orderTradingMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.smsCodeTextField.frame)+10, widths-40, 30)];
        _orderTradingMoneyLable.text = [CommenUtil LocalizedString:@"NoCard.OrderAmount"];
        _orderTradingMoneyLable.font = FT(15);
    }
    return _orderTradingMoneyLable;
}

- (MLMinLeTextField *)orderTradingMoneyTextField
{
    if (!_orderTradingMoneyTextField) {
        _orderTradingMoneyTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.orderTradingMoneyLable.frame)+5, widths-40, 40)];
        _orderTradingMoneyTextField.font = FT(15);
        _orderTradingMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;//数字带小数点键盘
        _orderTradingMoneyTextField.enabled = NO;
    }
    return _orderTradingMoneyTextField;
}

- (UILabel *)cardNameLable
{
    if (!_cardNameLable) {
        _cardNameLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.orderTradingMoneyTextField.frame)+5, widths-40, 30)];
        _cardNameLable.text = [CommenUtil LocalizedString:@"NoCard.DebitCardName"];
        _cardNameLable.font = FT(15);
    }
    return _cardNameLable;
}

- (MLMinLeTextField *)cardNameTextField
{
    if (!_cardNameTextField) {
        _cardNameTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.cardNameLable.frame)+5, widths-40, 40)];
        _cardNameTextField.font = FT(15);
        _cardNameTextField.enabled = NO;
    }
    return _cardNameTextField;
}

- (UILabel *)haomaLable
{
    if (!_haomaLable) {
        _haomaLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.cardNameTextField.frame)+5, widths-40, 30)];
        _haomaLable.text = [CommenUtil LocalizedString:@"NoCard.IDNumber"];
        _haomaLable.font = FT(15);
    }
    return _haomaLable;
}

- (MLMinLeTextField *)haomaTextField
{
    if (!_haomaTextField) {
        _haomaTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.haomaLable.frame)+5, widths-40, 40)];
        _haomaTextField.font = FT(15);
        _haomaTextField.enabled = NO;
    }
    return _haomaTextField;
}

- (UILabel *)settlementBorrowLable
{
    if (!_settlementBorrowLable) {
        _settlementBorrowLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.haomaTextField.frame)+5, widths-40, 30)];
        _settlementBorrowLable.text = [CommenUtil LocalizedString:@"NoCard.DebitCardNumber"];
        _settlementBorrowLable.font = FT(15);
    }
    return _settlementBorrowLable;
}

- (MLMinLeTextField *)settlementBorrowTextField
{
    if (!_settlementBorrowTextField) {
        _settlementBorrowTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.settlementBorrowLable.frame)+5, widths-40, 40)];
        _settlementBorrowTextField.font = FT(15);
        _settlementBorrowTextField.enabled = NO;
    }
    return _settlementBorrowTextField;
}

- (UILabel *)phoneNumberLable
{
    if (!_phoneNumberLable) {
        _phoneNumberLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.settlementBorrowTextField.frame)+5, widths-40, 30)];
        _phoneNumberLable.text = [CommenUtil LocalizedString:@"Login.PhoneNumber"];
        _phoneNumberLable.font = FT(15);
    }
    return _phoneNumberLable;
}

- (MLMinLeTextField *)phoneNumberTextField
{
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneNumberLable.frame)+5, widths-40, 40)];
        _phoneNumberTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _phoneNumberTextField.font = FT(15);
        _phoneNumberTextField.enabled = NO;
    }
    return _phoneNumberTextField;
}

@end
