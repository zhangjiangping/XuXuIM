//
//  MLHomeNavigationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLHomeNavigationView.h"
#import "UIView+Responder.h"
#import "MLCenterViewController.h"

@interface MLHomeNavigationView ()
@property (nonatomic, strong) UILabel *myLable;
@end

@implementation MLHomeNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(0, 134, 219);
        [self addSubview:self.myBut];
        [self addSubview:self.myLable];
        [self addSubview:self.palyBut];
    }
    return self;
}

- (void)playAction:(UIButton *)sender
{
    [self.viewController.navigationController pushViewController:[[MLCenterViewController alloc] init] animated:YES];
}

- (UIButton *)myBut
{
    if (!_myBut) {
        _myBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _myBut.frame = CGRectMake(5, 20, 44, 44);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 12, 25, 20)];
        img.image = [UIImage imageNamed:@"Menu"];
        [_myBut addSubview:img];
    }
    return _myBut;
}

- (UILabel *)myLable
{
    if (!_myLable) {
        _myLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.myBut.frame), 20, CGRectGetMinX(self.palyBut.frame)-CGRectGetMaxX(self.myBut.frame), 44)];
        _myLable.text = [CommenUtil LocalizedString:@"Home.Title"];
        _myLable.textAlignment = NSTextAlignmentCenter;
        _myLable.textColor = [UIColor whiteColor];
        _myLable.font = FT(20);
    }
    return _myLable;
}

- (UIButton *)palyBut
{
    if (!_palyBut) {
        _palyBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _palyBut.frame = CGRectMake(widths-55, 20, 55, 44);
        [_palyBut addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        [_palyBut addSubview:self.img];
        [_palyBut addSubview:self.allNumberLable];
    }
    return _palyBut;
}

- (UILabel *)allNumberLable
{
    if (!_allNumberLable) {
        _allNumberLable = [[UILabel alloc] initWithFrame:CGRectMake(32, 5, 14, 14)];
        _allNumberLable.layer.cornerRadius = 7;
        _allNumberLable.font = FT(10);
        _allNumberLable.clipsToBounds = YES;
        _allNumberLable.textAlignment = NSTextAlignmentCenter;
        _allNumberLable.textColor = [UIColor whiteColor];
        _allNumberLable.adjustsFontSizeToFitWidth = YES;
        _allNumberLable.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _allNumberLable;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(18, 11, 22, 22)];
        _img.image = [UIImage imageNamed:@"Alert"];
        _img.clipsToBounds = YES;
    }
    return _img;
}

@end





