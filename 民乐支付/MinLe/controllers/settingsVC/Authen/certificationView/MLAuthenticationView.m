//
//  MLAuthenticationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLAuthenticationView.h"
#import "UIView+Responder.h"
#import "MLNameAuthenticationViewController.h"
#import "MLYHKCertificationViewController.h"
#import "MLPeopleCertificationViewController.h"

#define WW   widths-30
#define HH   (heights-100-2*25)/3

@interface MLAuthenticationView ()
@property (nonatomic, strong) UILabel *myLable1;
@property (nonatomic, strong) UILabel *myLable2;
@property (nonatomic, strong) UILabel *myLable3;
@end

@implementation MLAuthenticationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.but1];
        [self addSubview:self.but2];
        [self addSubview:self.but3];
    }
    return self;
}

#pragma mark - getter

- (UIButton *)but1
{
    if (!_but1) {
        _but1 = [UIButton  buttonWithType:UIButtonTypeSystem];
        _but1.frame = CGRectMake(15, 50, WW, HH);
        _but1.backgroundColor = RGB(241, 241, 241);
        _but1.layer.cornerRadius = 5;
        _but1.tag = 1;
        [_but1 addSubview:self.img1];
        [_but1 addSubview:self.nameLable1];
        [_but1 addSubview:self.myLable1];
    }
    return _but1;
}

- (UIImageView *)img1
{
    if (!_img1) {
        _img1 = [[UIImageView alloc] initWithFrame:CGRectMake(WW-91.5, (HH-25)/2, 76.5, 25)];
        _img1.clipsToBounds = YES;
    }
    return _img1;
}

- (UILabel *)nameLable1
{
    if (!_nameLable1) {
        _nameLable1 = [[UILabel alloc] initWithFrame:CGRectMake(WW-91.5, (HH-25)/2, 76.5, 25)];
        _nameLable1.alpha = 0.6;
        _nameLable1.font = FT(14);
        _nameLable1.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLable1;
}

- (UILabel *)myLable1
{
    if (!_myLable1) {
        _myLable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, HH)];
        _myLable1.text = [CommenUtil LocalizedString:@"Authen.Name"];
    }
    return _myLable1;
}

- (UIButton *)but2
{
    if (!_but2) {
        _but2 = [UIButton  buttonWithType:UIButtonTypeSystem];
        _but2.frame = CGRectMake(15, 50+HH+25, WW, HH);
        _but2.backgroundColor = RGB(241, 241, 241);
        _but2.layer.cornerRadius = 5;
        _but2.tag = 2;
        [_but2 addSubview:self.img2];
        [_but2 addSubview:self.nameLable2];
        [_but2 addSubview:self.myLable2];
    }
    return _but2;
}

- (UIImageView *)img2
{
    if (!_img2) {
        _img2 = [[UIImageView alloc] initWithFrame:CGRectMake(WW-91.5, (HH-25)/2, 76.5, 25)];
        _img2.clipsToBounds = YES;
    }
    return _img2;
}

- (UILabel *)nameLable2
{
    if (!_nameLable2) {
        _nameLable2 = [[UILabel alloc] initWithFrame:CGRectMake(WW-91.5, (HH-25)/2, 76.5, 25)];
        _nameLable2.alpha = 0.6;
        _nameLable2.font = FT(14);
        _nameLable2.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLable2;
}

- (UILabel *)myLable2
{
    if (!_myLable2) {
        _myLable2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, HH)];
        _myLable2.text = [CommenUtil LocalizedString:@"Authen.Qualification"];
    }
    return _myLable2;
}

- (UIButton *)but3
{
    if (!_but3) {
        _but3 = [UIButton  buttonWithType:UIButtonTypeSystem];
        _but3.frame = CGRectMake(15, 50+(HH+25)*2, WW, HH);
        _but3.backgroundColor = RGB(241, 241, 241);
        _but3.layer.cornerRadius = 5;
        _but3.tag = 3;
        [_but3 addSubview:self.img3];
        [_but3 addSubview:self.nameLable3];
        [_but3 addSubview:self.myLable3];
    }
    return _but3;
}

- (UIImageView *)img3
{
    if (!_img3) {
        _img3 = [[UIImageView alloc] initWithFrame:CGRectMake(WW-91.5, (HH-25)/2, 76.5, 25)];
        _img3.clipsToBounds = YES;
    }
    return _img3;
}

- (UILabel *)nameLable3
{
    if (!_nameLable3) {
        _nameLable3 = [[UILabel alloc] initWithFrame:CGRectMake(WW-91.5, (HH-25)/2, 76.5, 25)];
        _nameLable3.alpha = 0.6;
        _nameLable3.font = FT(14);
        _nameLable3.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLable3;
}

- (UILabel *)myLable3
{
    if (!_myLable3) {
        _myLable3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, HH)];
        _myLable3.text = [CommenUtil LocalizedString:@"Authen.Bank"];
    }
    return _myLable3;
}

@end
