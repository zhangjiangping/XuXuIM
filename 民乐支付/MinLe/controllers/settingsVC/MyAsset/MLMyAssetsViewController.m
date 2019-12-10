//
//  MLMyAssetsViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyAssetsViewController.h"
#import "MLWithdrawalViewController.h"
#import "MLAssetsDetailViewController.h"

@interface MLMyAssetsViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *rightBut;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UIButton *xiaBut;
@end

@implementation MLMyAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    self.view.backgroundColor = RGB(239, 239, 245);
    [self.view addSubview:self.naView];
    [self.view addSubview:self.img];
    [self.view addSubview:self.nameLable];
    [self.view addSubview:self.moneyLable];
    //[self.view addSubview:self.xiaBut];
    [self moneyReuest];
}

- (void)moneyReuest
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:moneyURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            if ([responseObject[@"data"][0][@"money"] isEqual:[NSNull null]]) {
                self.moneyLable.text = [NSString stringWithFormat:@"￥0.00"];
            } else {
                self.moneyLable.text = [NSString stringWithFormat:@"￥%@",responseObject[@"data"][0][@"money"]];
            }
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Home.MyAssets"]];
        [_naView addSubview:self.rightBut];
    }
    return _naView;
}

- (UIButton *)rightBut
{
    if (!_rightBut) {
        _rightBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-100, 16, 100, 48);
        [_rightBut setTitle:[CommenUtil LocalizedString:@"Asset.Record"] forState:UIControlStateNormal];
        [_rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBut addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        _rightBut.titleLabel.font = FT(17);
    }
    return _rightBut;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake((widthss-105)/2, 224, 105, 105)];
        _img.layer.cornerRadius = 52.5;
        _img.clipsToBounds = YES;
        _img.image = [UIImage imageNamed:@"wodezichan_03"];
    }
    return _img;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.img.frame)+20, widthss, 20)];
        _nameLable.text = [CommenUtil LocalizedString:@"Home.MyAssets"];
        _nameLable.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLable;
}

- (UILabel *)moneyLable
{
    if (!_moneyLable) {
        _moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLable.frame)+20, widthss, 50)];
        _moneyLable.textAlignment = NSTextAlignmentCenter;
        _moneyLable.font = FT(40);
    }
    return _moneyLable;
}

- (UIButton *)xiaBut
{
    if (!_xiaBut) {
        _xiaBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _xiaBut.frame = CGRectMake(0, heightss-55, widthss, 55);
        [_xiaBut setTitle:[CommenUtil LocalizedString:@"Asset.Withdrawal"] forState:UIControlStateNormal];
        [_xiaBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _xiaBut.backgroundColor = RGB(2, 138, 218);
        [_xiaBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _xiaBut.titleLabel.font = FT(19);
    }
    return _xiaBut;
}

- (void)onAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[[MLWithdrawalViewController alloc] init] animated:YES];
}

- (void)pushAction
{
    [self.navigationController pushViewController:[[MLAssetsDetailViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
