//
//  MLSettingsViewController.m
//  民乐支付
//  设置
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLSettingsViewController.h"
#import "MLSettingsView.h"
#import "MLLandingViewController.h"

@interface MLSettingsViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLSettingsView *settingView;
@property (nonatomic, strong) UIButton *exitBut;
@end

@implementation MLSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.exitBut];
    [self.view addSubview:self.settingView];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Common.Setup"]];
    }
    return _naView;
}

- (MLSettingsView *)settingView
{
    if (!_settingView) {
        _settingView = [[MLSettingsView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, heightss/2+50)];
    }
    return _settingView;
}

- (UIButton *)exitBut
{
    if (!_exitBut) {
        _exitBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _exitBut.frame = CGRectMake(0, heightss-50, widthss, 50);
        [_exitBut setTitle:[CommenUtil LocalizedString:@"Setting.Logout"] forState:UIControlStateNormal];
        [_exitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exitBut.backgroundColor = [UIColor redColor];
        [_exitBut addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        _exitBut.titleLabel.font = FT(19);
    }
    return _exitBut;
}

- (void)pushAction
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:outURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            [self logout];
        }
        [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
    } withFailure:^(NSError *error) {
        NSLog(@"%@", error);
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
