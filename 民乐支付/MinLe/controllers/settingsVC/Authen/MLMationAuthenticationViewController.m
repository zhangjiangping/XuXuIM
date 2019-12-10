//
//  MLMationAuthenticationViewController.m
//  民乐支付
//  信息认证
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMationAuthenticationViewController.h"
#import "MLAuthenticationView.h"
#import "MLNameAuthenticationViewController.h"
#import "MLYHKCertificationViewController.h"
#import "MLPeopleCertificationViewController.h"
#import "MLValidationAuditsViewController.h"

@interface MLMationAuthenticationViewController ()
{
    NSString *statusStr1;
    NSString *statusStr2;
    NSString *statusStr3;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLAuthenticationView *authView;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *statusArray;
@end

@implementation MLMationAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    _nameArray = [NSArray array];
    _statusArray = [NSArray array];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.authView];
    [self request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:@"MationLoad" object:nil];
}

- (MLAuthenticationView *)authView
{
    if (!_authView) {
        _authView = [[MLAuthenticationView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, heightss/2.22)];
        [_authView.but1 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        [_authView.but2 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        [_authView.but3 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _authView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Home.InformationAuthentication"]];
    }
    return _naView;
}

- (void)request
//payapi.php/Home/Api/check_actauthen
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:authen_statusURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"info_status"] isEqual:@1]) {
            for (int i = 0; i < 3; i++) {
                NSLog(@"%@",responseObject[@"data"][i][@"status"]);
                if (i == 0) {
                    statusStr1 = responseObject[@"data"][0][@"status"];//认证状态
                    self.authView.nameLable1.text = @"";//先清空lable显示的文字
                    self.authView.img1.alpha = 0;
                    if ([statusStr1 isEqualToString:@"0"]) {
                        self.authView.nameLable1.text = [CommenUtil LocalizedString:@"Asset.Review"];
                    } else if ([statusStr1 isEqualToString:@"1"]) {
                        self.authView.img1.alpha = 1;
                        self.authView.img1.image = [UIImage imageNamed:@"yirenzheng"];
                    } else if ([statusStr1 isEqualToString:@"2"]) {
                        self.authView.img1.alpha = 1;
                        self.authView.img1.image = [UIImage imageNamed:@"renzhengshibai"];
                    } else {
                        self.authView.nameLable1.text = [CommenUtil LocalizedString:@"Authen.Not"];
                    }
                } else if (i == 1) {
                    statusStr2 = responseObject[@"data"][1][@"status"];//认证状态
                    self.authView.nameLable2.text = @"";//先清空lable显示的文字
                    self.authView.img2.alpha = 0;
                    if ([statusStr2 isEqualToString:@"0"]) {
                        self.authView.nameLable2.text = [CommenUtil LocalizedString:@"Asset.Review"];
                    } else if ([statusStr2 isEqualToString:@"1"]) {
                        self.authView.img2.alpha = 1;
                        self.authView.img2.image = [UIImage imageNamed:@"yirenzheng"];
                    } else if ([statusStr2 isEqualToString:@"2"]) {
                        self.authView.img2.alpha = 1;
                        self.authView.img2.image = [UIImage imageNamed:@"renzhengshibai"];
                    } else {
                        self.authView.nameLable2.text = [CommenUtil LocalizedString:@"Authen.Not"];
                    }
                } else {
                    statusStr3 = responseObject[@"data"][2][@"status"];//认证状态
                    self.authView.nameLable3.text = @"";//先清空lable显示的文字
                    self.authView.img3.alpha = 0;
                    if ([statusStr3 isEqualToString:@"0"]) {
                        self.authView.nameLable3.text = [CommenUtil LocalizedString:@"Asset.Review"];
                    } else if ([statusStr3 isEqualToString:@"1"]) {
                        self.authView.img3.alpha = 1;
                        self.authView.img3.image = [UIImage imageNamed:@"yirenzheng"];
                    } else if ([statusStr3 isEqualToString:@"2"]) {
                        self.authView.img3.alpha = 1;
                        self.authView.img3.image = [UIImage imageNamed:@"renzhengshibai"];
                    } else {
                        self.authView.nameLable3.text = [CommenUtil LocalizedString:@"Authen.Not"];
                    }
                }
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@", error);
    }];
}

- (void)pushAction:(UIButton *)sender
{
    if (sender.tag == 1) {
        if ([statusStr1 isEqualToString:@"2"] || [statusStr1 isEqualToString:@"3"]) {
            MLNameAuthenticationViewController *nameVC = [[MLNameAuthenticationViewController alloc] init];
            nameVC.isPopRoot = @"0";
            [self.navigationController pushViewController:nameVC animated:YES];
        } else {
            MLValidationAuditsViewController *vaVC = [[MLValidationAuditsViewController alloc] init];
            vaVC.isPopRoot = @"0";
            vaVC.statusStr = statusStr1;
            vaVC.status = @"1";
            [self.navigationController pushViewController:vaVC animated:YES];
        }
    } else if (sender.tag == 2) {
        if ([statusStr2 isEqualToString:@"2"] || [statusStr2 isEqualToString:@"3"]) {
            MLPeopleCertificationViewController *peopleVC = [[MLPeopleCertificationViewController alloc] init];
            peopleVC.isPopRoot = @"0";
            [self.navigationController pushViewController:peopleVC animated:YES];
        } else {
            MLValidationAuditsViewController *vaVC = [[MLValidationAuditsViewController alloc] init];
            vaVC.statusStr = statusStr2;
            vaVC.isPopRoot = @"0";
            vaVC.status = @"2";
            [self.navigationController pushViewController:vaVC animated:YES];
        }
    } else {
        if ([statusStr3 isEqualToString:@"2"] || [statusStr3 isEqualToString:@"3"]) {
            MLYHKCertificationViewController *yhkVC = [[MLYHKCertificationViewController alloc] init];
            yhkVC.isPopRoot = @"0";
            [self.navigationController pushViewController:yhkVC animated:YES];
        } else {
            MLValidationAuditsViewController *vaVC = [[MLValidationAuditsViewController alloc] init];
            vaVC.statusStr = statusStr3;
            vaVC.isPopRoot = @"0";
            vaVC.status = @"3";
            [self.navigationController pushViewController:vaVC animated:YES];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MationLoad" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
