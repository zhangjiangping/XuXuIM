//
//  MLMyShangView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/20.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyShangView.h"
#import "UIView+Responder.h"
#import "MLInformationViewController.h"
#import "MLMyViewController.h"
#import "BaseWebViewController.h"

@interface MLMyShangView ()
@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) UIImageView *rightImg;
@end

@implementation MLMyShangView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //[self addSubview:self.layerView];
        [self addSubview:self.headPortraitBut];
        [self addSubview:self.nameLable];
        [self addSubview:self.phoneLable];
        [self addSubview:self.rightImg];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)layerView
{
    if (!_layerView) {
        _layerView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, 70, 70)];
        _layerView.layer.cornerRadius = 6;
        _layerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _layerView.layer.shadowOffset = CGSizeMake(0, 3); //设置阴影的偏移量
        _layerView.layer.shadowRadius = 1.0;  //设置阴影的半径
        _layerView.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
        _layerView.layer.shadowOpacity = 0.2;
    }
    return _layerView;
}

- (UIButton *)headPortraitBut
{
    if (!_headPortraitBut) {
        _headPortraitBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _headPortraitBut.frame = CGRectMake(15, 11, 70, 70);
        _headPortraitBut.layer.cornerRadius = 6;
        _headPortraitBut.clipsToBounds = YES;
        _headPortraitBut.layer.masksToBounds = YES;
        [_headPortraitBut.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headPortraitBut setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        [_headPortraitBut addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headPortraitBut;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.layerView.frame)+12, 20, widths-CGRectGetMaxX(self.layerView.frame)-12, 20)];
        _nameLable.font = [UIFont boldSystemFontOfSize:16];
    }
    return _nameLable;
}

- (UILabel *)phoneLable
{
    if (!_phoneLable) {
        _phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.layerView.frame)+12, CGRectGetMaxY(self.nameLable.frame)+5, widths-CGRectGetMaxX(self.layerView.frame)-12, 25)];
        _phoneLable.font = FT(14);
        _phoneLable.textColor = [UIColor lightGrayColor];
    }
    return _phoneLable;
}

- (UIImageView *)rightImg
{
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(widths-14-15, (heights-14)/2, 14, 14)];
        _rightImg.image = [UIImage imageNamed:@"settings_03"];
        _rightImg.clipsToBounds = YES;
    }
    return _rightImg;
}


- (void)pushAction
{
    MLInformationViewController *inforVC = [[MLInformationViewController alloc] init];
    inforVC.backDelegate = (MLMyViewController *)self.viewController;
    inforVC.photoImg = self.headPortraitBut.imageView.image;
    [self.viewController.navigationController pushViewController:inforVC animated:YES];
}

@end






