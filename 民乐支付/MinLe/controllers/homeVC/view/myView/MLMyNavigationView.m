//
//  MLMyNavigationView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/20.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyNavigationView.h"
#import "UIView+Responder.h"

@interface MLMyNavigationView ()
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIImageView *img;
@end

@implementation MLMyNavigationView

- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor *)color withTitle:(NSString *)title;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(0, 134, 219);
        [self addSubview:self.lable];
        _lable.textColor = color;
        _lable.text = title;
        [self addSubview:self.but];
    }
    return self;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(64, 14, widths-128, 50)];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.font = FT(18);
    }
    return _lable;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, 0, 64, 64);
        [_but addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_but addSubview:self.img];
    }
    return _but;
}

- (void)backAction
{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 12, 20)];
        _img.image = [UIImage imageNamed:@"Back"];
        _img.clipsToBounds = YES;
    }
    return _img;
}

@end












