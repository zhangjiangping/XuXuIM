//
//  MLAccountInformationViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/21.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLAccountInformationViewController.h"
#import "MLForMoreDetailsViewController.h"
#import "MLDetailsView.h"

@interface MLAccountInformationViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLDetailsView *detailsView;
@property (nonatomic, strong) UIButton *but;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MLAccountInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUI
{
    _dataArray = [NSArray array];
    [self.view addSubview:self.naView];
    [self request];
    [self.view addSubview:self.detailsView];
    [self.view addSubview:self.but];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Home.AccountDetails"]];
    }
    return _naView;
}

- (MLDetailsView *)detailsView
{
    if (!_detailsView) {
        _detailsView = [[MLDetailsView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, heightss/1.6675)];
    }
    return _detailsView;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        [_but setTitle:[CommenUtil LocalizedString:@"Account.KnowMore"] forState:UIControlStateNormal];
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _but.backgroundColor = RGB(2, 138, 218);
        [_but addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but.titleLabel.font = FT(19);
    }
    return _but;
}

- (void)pushAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[[MLForMoreDetailsViewController alloc] init] animated:YES];
}

- (void)request
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:zhanghuURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"type":@"1"} withComplection:^(id responseObject) {
        _dataArray = @[[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"short_name"]],
                       [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"name"]],
                       [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"corporate_name"]],
                       [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"contract_rate"]],
                       [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"contract_number"]],
                       [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"contract_time"]],
                       [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"contract_end_time"]]];
        self.detailsView.array = _dataArray;
        [self.detailsView.table reloadData];
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
