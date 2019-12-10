//
//  MLNoCardRegisterView.m
//  minlePay
//
//  Created by JP on 2017/10/16.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLNoCardRegisterView.h"

@interface MLNoCardRegisterView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *phoneNumberLable;//手机号码
@property (nonatomic, strong) UILabel *openCardNumberLable;//开通快捷的贷记卡卡号

@end

@implementation MLNoCardRegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.phoneNumberLable];
        [self addSubview:self.phoneNumberTextField];
        [self addSubview:self.openCardNumberLable];
        [self addSubview:self.openCardNumberTextField];
    }
    return self;
}

#pragma mark - getter

- (UILabel *)phoneNumberLable
{
    if (!_phoneNumberLable) {
        _phoneNumberLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, widths-40, 30)];
        _phoneNumberLable.text = [CommenUtil LocalizedString:@"Login.PhoneNumber"];
        _phoneNumberLable.font = FT(15);
        _phoneNumberTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _phoneNumberLable;
}

- (MLMinLeTextField *)phoneNumberTextField
{
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneNumberLable.frame)+5, widths-40, 40)];
        _phoneNumberTextField.font = FT(15);
        _phoneNumberTextField.enabled = NO;
    }
    return _phoneNumberTextField;
}

- (UILabel *)openCardNumberLable
{
    if (!_openCardNumberLable) {
        _openCardNumberLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneNumberTextField.frame)+10, widths-40, 30)];
        _openCardNumberLable.text = [CommenUtil LocalizedString:@"NoCard.CreditCardNumber"];
        _openCardNumberLable.font = FT(15);
    }
    return _openCardNumberLable;
}

- (MLMinLeTextField *)openCardNumberTextField
{
    if (!_openCardNumberTextField) {
        _openCardNumberTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.openCardNumberLable.frame)+5, widths-40, 40)];
        _openCardNumberTextField.font = FT(15);
        _openCardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _openCardNumberTextField.delegate = self;
    }
    return _openCardNumberTextField;
}


#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.openCardNumberTextField) {
        if (![CommenUtil isPureInt:string] && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

@end
