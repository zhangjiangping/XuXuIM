//
//  MLCardOrderViewController.m
//  minlePay
//
//  Created by JP on 2017/10/17.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLCardOrderViewController.h"
#import "MLNoCardRegisterViewController.h"
#import "DataModel.h"
#import "MLCardOrderView.h"

@interface MLCardOrderViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLCardOrderView *cardOrderView;
@property (nonatomic, strong) UIButton *addRegisterbut;//交易按钮
@end

@implementation MLCardOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.naView];
    [self.view addSubview:self.cardOrderView];
    [self.view addSubview:self.addRegisterbut];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取注册列表
- (void)request
{
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                          @"type":@"1_3"};
    [SharedApp.netWorking createPostWithUrlString:getUserCardInfoURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            DataModel *datModel = [DataModel modelWithDictionary:responseObject];
            [_cardOrderView updata:datModel.dataArray];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark - Action

- (void)pushAction:(UIButton *)sender
{
    MLNoCardRegisterViewController *cardRegisterVC = [[MLNoCardRegisterViewController alloc] init];
    [self.navigationController pushViewController:cardRegisterVC animated:YES];
}

#pragma mark - getter

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"NoCard.OrderNumber"]];
    }
    return _naView;
}

- (MLCardOrderView *)cardOrderView
{
    if (!_cardOrderView) {
        _cardOrderView = [[MLCardOrderView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64)];
    }
    return _cardOrderView;
}

- (UIButton *)addRegisterbut
{
    if (!_addRegisterbut) {
        _addRegisterbut = [UIButton buttonWithType:UIButtonTypeSystem];
        _addRegisterbut.frame = CGRectMake(0, heightss-50, widthss, 50);
        _addRegisterbut.backgroundColor = RGB(2, 138, 218);
        [_addRegisterbut setTitle:[CommenUtil LocalizedString:@"NoCard.AddRegister"] forState:UIControlStateNormal];
        [_addRegisterbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addRegisterbut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _addRegisterbut.titleLabel.font = FT(20);
    }
    return _addRegisterbut;
}

@end
