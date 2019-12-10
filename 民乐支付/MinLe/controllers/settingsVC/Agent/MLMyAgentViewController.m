//
//  MLMyAgentViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyAgentViewController.h"
#import "MLMyAgentDetailView.h"
#import "UIImageView+MyImageView.h"

@interface MLMyAgentViewController ()
{
    NSString *phoneStr;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLMyAgentDetailView *agentDetailView;
@property (nonatomic, strong) UIView *shuomingView;
@end

@implementation MLMyAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.agentDetailView];
    [self.view addSubview:self.shuomingView];
    [self agentReuest];
}

- (void)agentReuest
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:dailiURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            self.agentDetailView.nameLable.text = [NSString stringWithFormat:@"%@    %@",[CommenUtil LocalizedString:@"Me.AgentSerialNumber"],responseObject[@"data"][0][@"number"]];
            phoneStr = responseObject[@"data"][0][@"phone"];
            self.agentDetailView.phoneLable.text = [NSString stringWithFormat:@"%@    %@",[CommenUtil LocalizedString:@"Login.PhoneNumber"],phoneStr];
            if (![responseObject[@"data"][0][@"path_img"] isEqualToString:@""]) {
                //NSString *imgStr = [NSString stringWithFormat:@"%@%@",MLMLJK,responseObject[@"data"][0][@"path_img"]];
                //[self.agentDetailView.img setImageWithString:imgStr];
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
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Me.Agent"]];
    }
    return _naView;
}

- (MLMyAgentDetailView *)agentDetailView
{
    if (!_agentDetailView) {
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _agentDetailView = [[MLMyAgentDetailView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 220)];
        } else {
            _agentDetailView = [[MLMyAgentDetailView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 330)];
        }
        [_agentDetailView.but addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agentDetailView;
}

- (UIView *)shuomingView
{
    if (!_shuomingView) {
        _shuomingView = [[UIView alloc] init];
        UILabel *lable1 = [[UILabel alloc] init];
        lable1.text = [NSString stringWithFormat:@"%@：",[CommenUtil LocalizedString:@"Common.Instructions"]];
        lable1.font = FT(15);
        lable1.alpha = 0.5;
        [_shuomingView addSubview:lable1];
        UILabel *lable2 = [[UILabel alloc] init];
        lable2.text = [CommenUtil LocalizedString:@"Me.AgentMsg1"];
        lable2.font = FT(15);
        lable2.alpha = 0.5;
        [_shuomingView addSubview:lable2];
        UILabel *lable3 = [[UILabel alloc] init];
        lable3.text = [CommenUtil LocalizedString:@"Me.AgentMsg2"];
        lable3.font = FT(15);
        lable3.alpha = 0.5;
        [_shuomingView addSubview:lable3];
        
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _shuomingView.frame = CGRectMake(15, CGRectGetMaxY(self.agentDetailView.frame)+10, widthss-30, 80);
            lable1.frame = CGRectMake(0, 0, 50, 20);
            lable2.frame = CGRectMake(0, 20, CGRectGetWidth(self.shuomingView.frame), 20);
            lable3.frame = CGRectMake(0, 40, CGRectGetWidth(self.shuomingView.frame), 20);
        } else {
            _shuomingView.frame = CGRectMake(15, CGRectGetMaxY(self.agentDetailView.frame)+heightss/9.52, widthss-30, 80);
            lable1.frame = CGRectMake(0, 0, 50, 20);
            lable2.frame = CGRectMake(0, 30, CGRectGetWidth(self.shuomingView.frame), 20);
            lable3.frame = CGRectMake(0, 60, CGRectGetWidth(self.shuomingView.frame), 20);
        }
    }
    return _shuomingView;
}

//联系我的代理商
- (void)phoneAction
{
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@", phoneStr];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
