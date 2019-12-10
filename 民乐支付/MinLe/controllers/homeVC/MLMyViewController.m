//
//  MLMyViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/20.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyViewController.h"
#import "MLMyXiaView.h"
#import "UIButton+MyButton.h"
#import "MLSettingsViewController.h"

@interface MLMyViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;//导航栏
@property (nonatomic, strong) MLMyXiaView *xiaView;
@property (nonatomic, strong) UIButton *rightBut;
@end

@implementation MLMyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUI
{
    self.view.backgroundColor = RGB(245, 246, 249);
    [self.view addSubview:self.naView];
    [self.view addSubview:self.xiaView];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Me"]];
        
        [_naView addSubview:self.rightBut];
    }
    return _naView;
}

- (UIButton *)rightBut
{
    if (!_rightBut) {
        _rightBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-100, 16, 100, 46);
        [_rightBut setTitle:[CommenUtil LocalizedString:@"Common.Setup"] forState:UIControlStateNormal];
        [_rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightBut.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [_rightBut addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        _rightBut.titleLabel.font = FT(17);
    }
    return _rightBut;
}

- (MLMyXiaView *)xiaView
{
    if (!_xiaView) {
        _xiaView = [[MLMyXiaView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64)];
    }
    return _xiaView;
}

- (void)pushAction
{
    MLSettingsViewController *settingVC = [[MLSettingsViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)request
{
    [SharedApp.netWorking myPostWithUrlString:re_head_picURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            if (![responseObject[@"data"][0][@"path_img"] isEqualToString:@""] || [responseObject[@"data"][0][@"path_img"] isEqual:[NSNull null]]) {
                NSString *imgeStr = [NSString stringWithFormat:@"%@%@",MLMLJK,responseObject[@"data"][0][@"path_img"]];
                [self.xiaView.shangView.headPortraitBut setImageWithString:imgeStr withDefalutImage:[UIImage imageNamed:@"photo"]];
            }
            NSString *nameStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"username"]];
            NSString *phoneStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"phone"]];
            if ([nameStr isEqualToString:phoneStr]) {
                nameStr = [CommenUtil LocalizedString:@"Me.SetupNick"];
            }
            self.xiaView.shangView.nameLable.text = nameStr;
            self.xiaView.shangView.phoneLable.text = phoneStr;
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark - 个人信息返回刷新头像图片

- (void)backActionWithImage:(UIImage *)img
{
    [self.xiaView.shangView.headPortraitBut setImage:img forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
