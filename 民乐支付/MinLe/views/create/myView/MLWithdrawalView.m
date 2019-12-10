//
//  MLWithdrawalView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLWithdrawalView.h"

@interface MLWithdrawalView () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *ligView;
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIView *xianView;//分割线
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *nameYhLable;
@property (nonatomic, strong) UILabel *fuhaoLable;
@end

@implementation MLWithdrawalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.ligView];
        [self addSubview:self.lable];
        [self addSubview:self.moneyTextField];
        [self addSubview:self.xianView];
        [self addSubview:self.nameYhLable];
        [self addSubview:self.img];
        [self addSubview:self.yhLable];
        [self addSubview:self.fuhaoLable];
    }
    return self;
}

- (UIView *)ligView
{
    if (!_ligView) {
        _ligView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widths, heights/4)];
        _ligView.backgroundColor = RGB(250, 251, 252);
        _ligView.layer.cornerRadius = 5;
        [_ligView addSubview:self.balanceLable];
        [_ligView addSubview:self.allBut];
    }
    return _ligView;
}

- (UILabel *)balanceLable
{
    if (!_balanceLable) {
        _balanceLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 170, CGRectGetHeight(self.ligView.frame))];
        _balanceLable.font = FT(16);
        _balanceLable.contentMode = UIViewContentModeScaleAspectFill;
        _balanceLable.adjustsFontSizeToFitWidth = YES;
    }
    return _balanceLable;
}

- (UIButton *)allBut
{
    if (!_allBut) {
        _allBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _allBut.frame = CGRectMake(widths-95, 0, 80, CGRectGetHeight(self.ligView.frame));
        [_allBut setTitle:[CommenUtil LocalizedString:@"Draw.AllWithdrawal"] forState:UIControlStateNormal];
        _allBut.titleLabel.font = FT(16);
        _allBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _allBut;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.ligView.frame), widths-30, heights/4)];
        _lable.font = FT(22);
        _lable.text = [CommenUtil LocalizedString:@"Draw.WithdrawalMoney"];
    }
    return _lable;
}

- (UILabel *)fuhaoLable
{
    if (!_fuhaoLable) {
        _fuhaoLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.lable.frame), 40, heights/4)];
        _fuhaoLable.text = @"￥";
        _fuhaoLable.font = FT(32);
    }
    return _fuhaoLable;
}

- (MLCustomTextField *)moneyTextField
{
    if (!_moneyTextField) {
        _moneyTextField = [[MLCustomTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fuhaoLable.frame), CGRectGetMaxY(self.lable.frame), widths-CGRectGetMaxX(self.fuhaoLable.frame)-40, heights/4) withPlaceholder:[CommenUtil LocalizedString:@"Draw.MoneyNotBelow0.01"]];
        _moneyTextField.delegate = self;
    }
    return _moneyTextField;
}

- (UIView *)xianView
{
    if (!_xianView) {
        _xianView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.moneyTextField.frame), widths-30, 0.5)];
        _xianView.backgroundColor = [UIColor lightGrayColor];
        _xianView.alpha = 0.6;
    }
    return _xianView;
}


- (UILabel *)nameYhLable
{
    if (!_nameYhLable) {
        _nameYhLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.xianView.frame), 70, heights-CGRectGetMaxY(self.xianView.frame))];
        _nameYhLable.text = [CommenUtil LocalizedString:@"Draw.ToBank"];
        _nameYhLable.font = FT(16);
        _nameYhLable.alpha = 0.5;
    }
    return _nameYhLable;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameYhLable.frame)+10, CGRectGetMaxY(self.xianView.frame)+(heights/4-11)/2, 11, 11)];
        _img.image = [UIImage imageNamed:@"woyaotixian"];
        _img.clipsToBounds = YES;
    }
    return _img;
}

- (UILabel *)yhLable
{
    if (!_yhLable) {
        _yhLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.img.frame)+10, CGRectGetMaxY(self.xianView.frame), widths-CGRectGetMaxX(self.img.frame)-10, heights/4)];
        _yhLable.font = FT(16);
        
        _yhLable.contentMode = UIViewContentModeScaleAspectFill;
        _yhLable.adjustsFontSizeToFitWidth = YES;
    }
    return _yhLable;
}

#pragma mark - UITextView delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.allBut.alpha = 1.0;
//    if (textField == self.textField) {
//        if (string.length == 0) return YES;
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 16) {
//            [[MBProgressHUD shareInstance] ShowMessage:@"不能超过16个文字" showView:nil];
//            return NO;
//        }
//    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.moneyTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}


@end














