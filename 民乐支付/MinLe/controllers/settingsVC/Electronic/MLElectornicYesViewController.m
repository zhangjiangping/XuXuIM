//
//  MLElectornicYesViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/8.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLElectornicYesViewController.h"
#import "BaseLayerView.h"
#import "XLable.h"

@interface MLElectornicYesViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UIImageView *eleImg;
@property (nonatomic, strong) UIImageView *myImg;
@property (nonatomic, strong) XLable *nameLable;
@property (nonatomic, strong) UIView *xianView;
@end

@implementation MLElectornicYesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.layerView];
}


- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Me.ElectronicAccount"]];
    }
    return _naView;
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, heightss/1.8)];
        [_layerView addSubview:self.eleImg];
        [_layerView addSubview:self.messageLable];
        [_layerView addSubview:self.xianView];
        [_layerView addSubview:self.myImg];
        [_layerView addSubview:self.nameLable];
    }
    return _layerView;
}

- (UIImageView *)eleImg
{
    if (!_eleImg) {
        _eleImg = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.layerView.frame)-36)/2, 30, 36, 36)];
        _eleImg.image = [UIImage imageNamed:@"success"];
        _eleImg.clipsToBounds = YES;
    }
    return _eleImg;
}

- (UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.eleImg.frame)+20, CGRectGetWidth(self.layerView.frame), 20)];
        _messageLable.text = [CommenUtil LocalizedString:@"Electronic.BoundSuccess"];
        _messageLable.textAlignment = NSTextAlignmentCenter;
        _messageLable.font = FT(16);
        _messageLable.alpha = 0.6;
    }
    return _messageLable;
}

- (UIView *)xianView
{
    if (!_xianView) {
        _xianView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.messageLable.frame)+20, CGRectGetWidth(self.layerView.frame)-30, 0.5)];
        _xianView.backgroundColor = [UIColor lightGrayColor];
        _xianView.alpha = 0.5;
    }
    return _xianView;
}

- (UIImageView *)myImg
{
    if (!_myImg) {
        _myImg = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.layerView.frame)-194)/2, CGRectGetMaxY(self.xianView.frame)+40, 194, 120)];
        _myImg.image = [UIImage imageNamed:@"e"];
        _myImg.clipsToBounds = YES;
    }
    return _myImg;
}

- (XLable *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[XLable alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.myImg.frame)+40, CGRectGetWidth(self.layerView.frame)-30, 30)];
        _nameLable.text = [NSString stringWithFormat:@"%@：%@",[CommenUtil LocalizedString:@"Electronic.YourElectronicIs"],self.eleStr];
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.font = FT(16);
        _nameLable.alpha = 0.5;
        _nameLable.adjustsFontSizeToFitWidth = YES;
        _nameLable.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _nameLable;
}



@end












