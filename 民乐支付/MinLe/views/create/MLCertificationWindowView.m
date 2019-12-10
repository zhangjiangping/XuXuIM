//
//  MLCertificationWindowView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLCertificationWindowView.h"
#import "BaseLayerView.h"

@interface MLCertificationWindowView ()
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, strong) UIView *xianView;
@property (nonatomic, strong) BaseLayerView *layerView;
@end

@implementation MLCertificationWindowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withButtonTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonTitle = title;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.layerView];
    [self addSubview:self.cancelBut];
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(20, 220, widths-40, 150)];
        [_layerView addSubview:self.lable];
        [_layerView addSubview:self.xianView];
        [_layerView addSubview:self.certificationBut];
    }
    return _layerView;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.layerView.frame), 75)];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.font = FT(18);
    }
    return _lable;
}
- (UIView *)xianView
{
    if (!_xianView) {
        _xianView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lable.frame), CGRectGetWidth(self.layerView.frame), 0.5)];
        _xianView.backgroundColor = [UIColor lightGrayColor];
        _xianView.alpha = 0.5;
    }
    return _xianView;
}
- (UIButton *)certificationBut
{
    if (!_certificationBut) {
        _certificationBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _certificationBut.frame = CGRectMake(0, CGRectGetMaxY(self.xianView.frame), CGRectGetWidth(self.layerView.frame), 75);
        if (_buttonTitle) {
            [_certificationBut setTitle:_buttonTitle forState:UIControlStateNormal];
        } else {
            [_certificationBut setTitle:[CommenUtil LocalizedString:@"NoCard.GoCertification"] forState:UIControlStateNormal];
        }
        [_certificationBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _certificationBut.titleLabel.font = FT(17);
    }
    return _certificationBut;
}

- (UIButton *)cancelBut
{
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.frame = CGRectMake((widths-42)/2, CGRectGetMaxY(self.layerView.frame)+50, 42, 42);
        [_cancelBut setImage:[UIImage imageNamed:@"zhifuquxiao"] forState:UIControlStateNormal];
        _cancelBut.hidden = YES;
    }
    return _cancelBut;
}

//个人信息弹出视图更新
- (void)setAuthCerWindowViewState:(NSNumber *)statusNum
{
    /*
     0 = 未提交实名认证
     2 = 实名认证失败
     3 = 实名认证审核中
     4 = 你未提交资质认证
     5 = 资质认证失败
     6 = 资质认证审核中
     7 = 你未提交银行卡认证
     8 = 银行卡认证失败
     9 = 银行卡认证审核中
     10 = 没有提交进件信息
     */
    if ([statusNum isEqual:@0]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.NotNameCertification"];
    } else if ([statusNum isEqual:@2]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.NameCertificationFaile"];
    } else if ([statusNum isEqual:@3]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.NameCerReview"];
        [self.certificationBut setTitle:[CommenUtil LocalizedString:@"NoCard.ToSee"] forState:UIControlStateNormal];
    } else if ([statusNum isEqual:@4]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.NotQualificationCer"];
    } else if ([statusNum isEqual:@5]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.QualificationFaile"];
    } else if ([statusNum isEqual:@6]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.QualificationCerReview"];
        [self.certificationBut setTitle:[CommenUtil LocalizedString:@"NoCard.ToSee"] forState:UIControlStateNormal];
    } else if ([statusNum isEqual:@7]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.NotBankCer"];
    } else if ([statusNum isEqual:@8]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.BankCardCerFaile"];
    } else if ([statusNum isEqual:@9]) {
        self.lable.text = [CommenUtil LocalizedString:@"NoCard.BankCardCerReview"];
        [self.certificationBut setTitle:[CommenUtil LocalizedString:@"NoCard.ToSee"] forState:UIControlStateNormal];
    }
}

//无卡注册弹出视图更新
- (void)setNoCardCerWindowViewState
{
    self.lable.text = [CommenUtil LocalizedString:@"NoCard.YourNotRegister"];
    [self.certificationBut setTitle:[CommenUtil LocalizedString:@"NoCard.GoRegister"] forState:UIControlStateNormal];
}


- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }];
}

- (void)hiden
{
    self.cancelBut.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -1000;
        self.frame = frame;
    }];
}

@end

