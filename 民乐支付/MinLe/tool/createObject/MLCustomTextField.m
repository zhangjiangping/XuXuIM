//
//  MLCustomTextField.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//
#import "MLCustomTextField.h"

@implementation MLCustomTextField

- (instancetype)initWithFrame:(CGRect)frame withPlaceholder:(NSString *)holderStr
{
    self = [super initWithFrame:frame];
    if (self) {
        //STHeitiSC-Light   STHeitiSC-Medium
        [self setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:32.00]];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.placeholder = holderStr;
        [self setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont boldSystemFontOfSize:20] forKeyPath:@"_placeholderLabel.font"];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        self.keyboardType = UIKeyboardTypeDecimalPad;//数字带小数点键盘
        
        //自定按钮添加到键盘上
        UIView *bar;
        if (IOS_VERSION >= 11.0) {
            bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,40)];
        } else {
            bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth,40)];
        }
        bar.backgroundColor = [UIColor whiteColor];
        [bar addSubview:self.tureBut];
        [bar addSubview:self.cancelBut];
        self.inputAccessoryView = bar;
    }
    return self;
}

//重写这个方法是为了使Placeholder居中，不会出现文字稍微偏上了一些
- (void)drawPlaceholderInRect:(CGRect)rect {
    if (IOS_VERSION >= 11.f) {
        [super drawPlaceholderInRect:rect];
    } else {
        [super drawPlaceholderInRect:CGRectMake(0, CGRectGetHeight(self.frame) * 0.5 - 1, 0, 0)];
    }
}

- (UIButton *)tureBut
{
    if (!_tureBut) {
        _tureBut = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 70, 5, 60, 30)];
        [_tureBut setTitle:[CommenUtil LocalizedString:@"Common.Done"] forState:UIControlStateNormal];
        _tureBut.backgroundColor = RGB(195, 210, 223);
        [_tureBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tureBut.layer.cornerRadius = 15;
        _tureBut.titleLabel.font = FT(15);
        [_tureBut addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tureBut;
}

- (UIButton *)cancelBut
{
    if (!_cancelBut) {
        _cancelBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 60, 30)];
        [_cancelBut setTitle:[CommenUtil LocalizedString:@"Common.Cancle"] forState:UIControlStateNormal];
        _cancelBut.backgroundColor = RGB(195, 210, 223);
        [_cancelBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBut.layer.cornerRadius = 15;
        _cancelBut.titleLabel.font = FT(15);
        [_cancelBut addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBut;
}

- (void)print
{
    [self resignFirstResponder];
}

@end








