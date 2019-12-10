//
//  WeiXinBinding.m
//  民乐支付
//
//  Created by JP on 2017/8/23.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "WeiXinBinding.h"
#import "UIImageView+MyImageView.h"
#import "MLRegisterViewController.h"

@interface WeiXinBinding ()
{
    NSDictionary *_dic;
    float btnWidth;
}
@property (nonatomic, strong) UIView *bindingView;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *nickLable;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bindingBottomView;
@property (nonatomic, strong) UIButton *minleBut;
@property (nonatomic, strong) UIButton *registerBut;
@property (nonatomic, strong) UILabel *minleLable;
@property (nonatomic, strong) UILabel *registerLable;
@end

@implementation WeiXinBinding

- (instancetype)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        _dic = dic;
        btnWidth = (CGRectGetWidth(self.frame)-15*2-35*2-90)/2.f;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.bindingView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Action

- (void)hideAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(hide)]) {
        [_delegate hide];
    }
}

- (void)minleAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(bindingLogin)]) {
        [_delegate bindingLogin];
    }
}

- (void)registerAction:(UIButton *)sender
{
    MLRegisterViewController *registerVc = [[MLRegisterViewController alloc] init];
    NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    registerVc.openID = openId;
    [self.viewController.navigationController pushViewController:registerVc animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(hide)]) {
        [_delegate hide];
    }
}

#pragma mark - UI

- (UIView *)bindingView
{
    if (!_bindingView) {
        _bindingView = [[UIView alloc] initWithFrame:CGRectMake(15, 210, CGRectGetWidth(self.frame)-30, 227)];
        _bindingView.backgroundColor = [UIColor whiteColor];
        _bindingView.layer.cornerRadius = 5;
        
        [_bindingView addSubview:self.photoImageView];
        [_bindingView addSubview:self.nickLable];
        [_bindingView addSubview:self.lineView];
        [_bindingView addSubview:self.bindingBottomView];
    }
    return _bindingView;
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (46-31)/2, 31, 31)];
        _photoImageView.clipsToBounds = YES;
        [_photoImageView setImageWithString:_dic[@"headimgurl"] withDefalutImage:[UIImage imageNamed:@"touxiang"]];
        _photoImageView.layer.cornerRadius = 3;
    }
    return _photoImageView;
}

- (UILabel *)nickLable
{
    if (!_nickLable) {
        _nickLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoImageView.frame)+10, 0, 200, 46)];
        _nickLable.font = [UIFont boldSystemFontOfSize:12];
        _nickLable.text = _dic[@"nickname"];
    }
    return _nickLable;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, CGRectGetWidth(self.bindingView.frame), 0.5)];
        _lineView.backgroundColor = [UIColor grayColor];
        _lineView.alpha = 0.5;
    }
    return _lineView;
}

- (UIView *)bindingBottomView
{
    if (!_bindingBottomView) {
        _bindingBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), CGRectGetWidth(self.bindingView.frame), (CGRectGetHeight(self.bindingView.frame)-CGRectGetMaxY(self.lineView.frame)))];
        [_bindingBottomView addSubview:self.minleBut];
        [_bindingBottomView addSubview:self.minleLable];
        [_bindingBottomView addSubview:self.registerBut];
        [_bindingBottomView addSubview:self.registerLable];
    }
    return _bindingBottomView;
}

- (UIButton *)minleBut
{
    if (!_minleBut) {
        _minleBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _minleBut.frame = CGRectMake(35, 20, btnWidth, btnWidth);
        _minleBut.layer.cornerRadius = btnWidth/2.f;
        [_minleBut setBackgroundImage:[UIImage imageNamed:@"Button-minle"] forState:UIControlStateNormal];
        [_minleBut addTarget:self action:@selector(minleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, btnWidth-20, btnWidth)];
        lable.text = [CommenUtil LocalizedString:@"Login.MinleAcoount"];
        lable.textColor = [UIColor whiteColor];
        lable.font = FT(18);
        lable.layer.cornerRadius = btnWidth/2.f;
        lable.adjustsFontSizeToFitWidth = YES;
        lable.contentMode = UIViewContentModeScaleAspectFill;
        lable.textAlignment = NSTextAlignmentCenter;
        [_minleBut addSubview:lable];
    }
    return _minleBut;
}

- (UILabel *)minleLable
{
    if (!_minleLable) {
        _minleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.minleBut.frame), CGRectGetMaxY(self.minleBut.frame), btnWidth, CGRectGetHeight(self.bindingBottomView.frame)-CGRectGetMaxY(self.minleBut.frame))];
        _minleLable.text = [CommenUtil LocalizedString:@"Login.BindingForAccount"];
        _minleLable.alpha = 0.8;
        _minleLable.font = FT(12);
        _minleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _minleLable;
}

- (UIButton *)registerBut
{
    if (!_registerBut) {
        _registerBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBut.frame = CGRectMake(CGRectGetWidth(self.bindingBottomView.frame)-btnWidth-35, 20, btnWidth, btnWidth);
        _registerBut.layer.cornerRadius = btnWidth/2.f;
        [_registerBut setBackgroundImage:[UIImage imageNamed:@"Button-none"] forState:UIControlStateNormal];
        [_registerBut addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, btnWidth-20, btnWidth)];
        lable.text = [CommenUtil LocalizedString:@"Login.NotRegister"];
        lable.textColor = [UIColor whiteColor];
        lable.font = FT(18);
        lable.layer.cornerRadius = btnWidth/2.f;
        lable.adjustsFontSizeToFitWidth = YES;
        lable.contentMode = UIViewContentModeScaleAspectFill;
        lable.textAlignment = NSTextAlignmentCenter;
        [_registerBut addSubview:lable];
        
    }
    return _registerBut;
}

- (UILabel *)registerLable
{
    if (!_registerLable) {
        _registerLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.registerBut.frame), CGRectGetMaxY(self.registerBut.frame), btnWidth, CGRectGetHeight(self.bindingBottomView.frame)-CGRectGetMaxY(self.registerBut.frame))];
        _registerLable.text = [CommenUtil LocalizedString:@"Login.NowGoToRegister"];
        _registerLable.alpha = 0.8;
        _registerLable.font = FT(12);
        _registerLable.textAlignment = NSTextAlignmentCenter;
    }
    return _registerLable;
}



@end
