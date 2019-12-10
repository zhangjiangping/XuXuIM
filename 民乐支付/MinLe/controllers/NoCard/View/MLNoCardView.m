//
//  MLYHKAuthenticationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLNoCardView.h"
#import "UIView+Responder.h"
#import "UIViewController+XHPhoto.h"
#import "AddressViewController.h"
#import "MLRegisterBankViewController.h"
#import "MLYHKCertificationViewController.h"
#import "AVCaptureViewController.h"
#import "XLBankScanViewController.h"

@interface MLNoCardView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *tishiLable;//清算周期
@property (nonatomic, strong) UILabel *oneLable;//T1
@property (nonatomic, strong) UILabel *twoLable;//T0
@property (nonatomic, strong) UIView *xianView1;

@property (nonatomic, strong) UILabel *openCardOrderLable;//商户开卡订单号
@property (nonatomic, strong) UIView *xianView2;

@property (nonatomic, strong) UILabel *orderTradingMoneyLable;//订单交易金额
@property (nonatomic, strong) UILabel *cardNameLable;//结算卡姓名
@property (nonatomic, strong) UILabel *haomaLable;//身份证号码
@property (nonatomic, strong) UILabel *settlementBorrowLable;//结算借记卡卡号
@property (nonatomic, strong) UILabel *phoneNumberLable;//手机号

@end

@implementation MLNoCardView

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
    [self addSubview:self.tishiLable];
    //[self addSubview:self.oneBut];
    [self addSubview:self.twoBut];
    [self addSubview:self.xianView1];
    
    [self addSubview:self.openOrderBut];
    [self addSubview:self.xianView2];
    
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

#pragma mark - getter

- (UILabel *)tishiLable
{
    if (!_tishiLable) {
        _tishiLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 50)];
        _tishiLable.text = [CommenUtil LocalizedString:@"NoCard.Cycle"];
        _tishiLable.font = FT(15);
    }
    return _tishiLable;
}
- (UIButton *)oneBut
{
    if (!_oneBut) {
        _oneBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneBut.frame = CGRectMake(CGRectGetMaxX(self.tishiLable.frame)+10, CGRectGetMinY(_tishiLable.frame), 80, 50);
        _oneBut.tag = 1;
        [_oneBut addSubview:self.oneImageView];
        [_oneBut addSubview:self.oneLable];
    }
    return _oneBut;
}

- (UIImageView *)oneImageView
{
    if (!_oneImageView) {
        _oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(_oneBut.frame)-15)/2, 15, 15)];
        _oneImageView.clipsToBounds = YES;
        _oneImageView.image = [UIImage imageNamed:@"quanquan_03"];
    }
    return _oneImageView;
}

- (UILabel *)oneLable
{
    if (!_oneLable) {
        _oneLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.oneImageView.frame)+5, 0, 60, CGRectGetHeight(_oneBut.frame))];
        _oneLable.adjustsFontSizeToFitWidth = YES;
        _oneLable.text = [CommenUtil LocalizedString:@"NoCard.T1ToAcoount"];
        _oneLable.font = FT(14);
        _oneLable.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _oneLable;
}
- (UIButton *)twoBut
{
    if (!_twoBut) {
        _twoBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoBut.frame = CGRectMake(CGRectGetMaxX(self.tishiLable.frame)+10, CGRectGetMinY(_tishiLable.frame), 80, 50);
        _twoBut.tag = 2;
        [_twoBut addSubview:self.twoImageView];
        [_twoBut addSubview:self.twoLable];
    }
    return _twoBut;
}

- (UIImageView *)twoImageView
{
    if (!_twoImageView) {
        _twoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(_twoBut.frame)-15)/2, 15, 15)];
        _twoImageView.clipsToBounds = YES;
        _twoImageView.image = [UIImage imageNamed:@"quanquan_03"];
    }
    return _twoImageView;
}

- (UILabel *)twoLable
{
    if (!_twoLable) {
        _twoLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.twoImageView.frame)+5, 0, 60, CGRectGetHeight(_twoBut.frame))];
        _twoLable.adjustsFontSizeToFitWidth = YES;
        _twoLable.text = [CommenUtil LocalizedString:@"NoCard.T0ToAcoount"];
        _twoLable.font = FT(14);
        _twoLable.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _twoLable;
}

- (UIView *)xianView1
{
    if (!_xianView1) {
        _xianView1 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tishiLable.frame)-1, widths-20, 1)];
        _xianView1.backgroundColor = [UIColor lightGrayColor];
        _xianView1.alpha = 0.5;
    }
    return _xianView1;
}

- (UIButton *)openOrderBut
{
    if (!_openOrderBut) {
        _openOrderBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _openOrderBut.frame = CGRectMake(20, CGRectGetMaxY(self.tishiLable.frame), widths-20-15, 50);
        
        [_openOrderBut addSubview:self.openCardOrderLable];
        [_openOrderBut addSubview:self.openOrderLable];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.openOrderBut.frame)-15, 17.5, 15, 15)];
        img.image = [UIImage imageNamed:@"yhBut"];
        [_openOrderBut addSubview:img];
    }
    return _openOrderBut;
}

- (UILabel *)openCardOrderLable
{
    if (!_openCardOrderLable) {
        NSString *str = [CommenUtil LocalizedString:@"NoCard.OpenCreditCard"];
        float ww = [CommenUtil getWidthWithContent:str height:50 font:15];
        _openCardOrderLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ww, CGRectGetHeight(self.openOrderBut.frame))];
        _openCardOrderLable.text = str;
        _openCardOrderLable.font = FT(15);
    }
    return _openCardOrderLable;
}

- (UILabel *)openOrderLable
{
    if (!_openOrderLable) {
        _openOrderLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.openCardOrderLable.frame)+10, 0, CGRectGetWidth(self.openOrderBut.frame)-CGRectGetMaxX(self.openCardOrderLable.frame)-10-15, CGRectGetHeight(self.openOrderBut.frame))];
        _openOrderLable.text = [CommenUtil LocalizedString:@"NoCard.PleaseSelect"];
        _openOrderLable.font = FT(15);
        _openOrderLable.textAlignment = NSTextAlignmentRight;
    }
    return _openOrderLable;
}

- (UIView *)xianView2
{
    if (!_xianView2) {
        _xianView2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.openOrderBut.frame)-1, widths-20, 1)];
        _xianView2.backgroundColor = [UIColor lightGrayColor];
        _xianView2.alpha = 0.5;
    }
    return _xianView2;
}

- (UILabel *)orderTradingMoneyLable
{
    if (!_orderTradingMoneyLable) {
        _orderTradingMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.xianView2.frame)+10, widths-40, 30)];
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
        _orderTradingMoneyTextField.delegate = self;
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
        _settlementBorrowTextField.keyboardType = UIKeyboardTypeNumberPad;
        _settlementBorrowTextField.delegate = self;
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

- (void)selectedChannel:(BOOL)isT1
{
    if (isT1) {
        self.oneBut.selected = NO;
        self.twoBut.selected = NO;
        self.oneImageView.image = [UIImage imageNamed:@"quanquan_03"];
        self.twoImageView.image = [UIImage imageNamed:@"quanquan_05"];
        self.orderTradingMoneyTextField.text = @"";
    } else {
        self.oneBut.selected = YES;
        self.twoBut.selected = YES;
        self.oneImageView.image = [UIImage imageNamed:@"quanquan_05"];
        self.twoImageView.image = [UIImage imageNamed:@"quanquan_03"];
        self.orderTradingMoneyTextField.text = @"";
    }
}

#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.orderTradingMoneyTextField) {
        NSString *text = self.orderTradingMoneyTextField.text;
        NSString *newText = [NSString stringWithFormat:@"%@%@",text,string];
        if (newText.length > 20) {
            return NO;
        }
        if ([string containsString:@"."]) {
            if ([text containsString:@"."]) {
                //有了一个点的时候不写入
                return NO;
            } else {
                if (text.length == 0 && [string isEqualToString:@"."]) {
                    //输入的第一个字符就为点的时候不写入
                    return NO;
                } else {
                    //判断不是浮点型不写入
                    if (![string isEqualToString:@"."] &&
                        ![CommenUtil isPureFloat:string]) {
                        return NO;
                    }
                }
            }
        } else if ([string isEqualToString:@""]) {
            NSLog(@"删除空格");
        } else {
            //判断整型或者浮点型
            if (![CommenUtil isPureInt:string] ||
                ![CommenUtil isPureFloat:string])
            {
                return NO;
            }
        }
    } else if (textField == self.settlementBorrowTextField) {
        if (![CommenUtil isPureInt:string] && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

@end











