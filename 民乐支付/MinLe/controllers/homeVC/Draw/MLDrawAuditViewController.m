//
//  MLDrawAuditViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLDrawAuditViewController.h"

@interface MLDrawAuditViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *tureBut;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *timeLable;
@end

@implementation MLDrawAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    self.view.backgroundColor = RGB(241, 242, 243);
    [self.view addSubview:self.naView];
    [self.view addSubview:self.img];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Draw.WithdrawalFeedback"]];
        _naView.but.alpha = 0;
        [_naView addSubview:self.tureBut];
    }
    return _naView;
}

- (UIButton *)tureBut
{
    if (!_tureBut) {
        _tureBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _tureBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-60, 14, 50, 50);
        [_tureBut setTitle:[CommenUtil LocalizedString:@"Common.Ture"] forState:UIControlStateNormal];
        [_tureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tureBut addTarget:self action:@selector(tureAction) forControlEvents:UIControlEventTouchUpInside];
        _tureBut.titleLabel.font = FT(17);
    }
    return _tureBut;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, widthss, 150)];
        _img.image = [UIImage imageNamed:@"tixiandengdai"];
        _img.clipsToBounds = YES;
        
        [_img addSubview:self.timeLable];
    }
    return _img;
}

- (UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(56, 55, widthss-56, 15)];
        _timeLable.alpha = 0.5;
        _timeLable.font = FT(11);
        _timeLable.text = self.timeStr;
    }
    return _timeLable;
}

- (void)tureAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
