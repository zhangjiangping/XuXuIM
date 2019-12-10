//
//  MLAccountSettlementViewController.m
//  民乐支付
//  账户结算
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLAccountSettlementViewController.h"
#import "MLAccountSettlementView.h"
#import "MLYHKCertificationViewController.h"
#import "MLYHKHistoryViewController.h"

@interface MLAccountSettlementViewController ()
{
    NSMutableString *state;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLAccountSettlementView *asView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *changeBut;
@property (nonatomic, strong) UIButton *rightBut;
@end

@implementation MLAccountSettlementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];
}

- (void)setUI
{
    _dataArray = [NSArray array];
    state = [NSMutableString string];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.changeBut];
}

- (UIButton *)changeBut
{
    if (!_changeBut) {
        _changeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBut.frame = CGRectMake(0, screenHeight-50, screenWidth, 50);
        _changeBut.backgroundColor = blueRGB;
        [_changeBut addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat tempWidth = [CommenUtil getWidthWithContent:[CommenUtil LocalizedString:@"Settle.ChangeInfo"] height:50 font:19];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-tempWidth-26)/2, 14.5, 21, 21)];
        img.clipsToBounds = YES;
        img.image = [UIImage imageNamed:@"edit"];
        [_changeBut addSubview:img];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+5, 0, tempWidth, 50)];
        lable.text = [CommenUtil LocalizedString:@"Settle.ChangeInfo"];
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        [_changeBut addSubview:lable];
    }
    return _changeBut;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Settle.Title"]];
        
        [_naView addSubview:self.rightBut];
    }
    return _naView;
}

- (UIButton *)rightBut
{
    if (!_rightBut) {
        _rightBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-100, 16, 100, 48);
        [_rightBut setTitle:[CommenUtil LocalizedString:@"Settle.ChangeRecord"] forState:UIControlStateNormal];
        [_rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        _rightBut.titleLabel.font = FT(17);
    }
    return _rightBut;
}

- (void)rightAction
{
    MLYHKHistoryViewController *historyVC = [[MLYHKHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

- (void)changeAction
{
    /*
     state = 0 审核中
     state = 1 审核成功
     state = 2 审核失败
     state = 3 未提交
     state = 4 没有提交银行卡认证
     state = 5 银行卡认证审核中
     state = 6 银行卡认证失败
     */
    if ([state isEqualToString:@"4"] || [state isEqualToString:@"5"] || [state isEqualToString:@"6"]) {
        if ([state isEqualToString:@"4"]) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Settle.NotSubmitBankAuth"] showView:nil];
        } else if ([state isEqualToString:@"5"]) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Settle.BankAudit"] showView:nil];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Settle.BankFaileAgainAuth"] showView:nil];
        }
    } else {
        if ([state isEqualToString:@"0"]) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Settle.LastChangeAudit"] showView:nil];
        } else {
            MLYHKCertificationViewController *yhkVC = [[MLYHKCertificationViewController alloc] init];
            yhkVC.yhkChangeType = @"1";
            [self.navigationController pushViewController:yhkVC animated:YES];
        }
    }
}

- (void)request
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:account_settlementURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSArray *dataArray = @[[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"bank_type"]],
                           [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"bank_name"]],
                           [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"bank_area"]],
                           [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"bank_branch"]],
                           [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"bank_user_name"]],
                           [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"bank_num"]]];
            state = [[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"state"]] mutableCopy];
            
            NSArray *myArray = @[[CommenUtil LocalizedString:@"Authen.BankState"],
                                 [CommenUtil LocalizedString:@"Authen.OpenBank"],
                                 [CommenUtil LocalizedString:@"Authen.OpenCity"],
                                 [CommenUtil LocalizedString:@"Authen.OpenBranch"],
                                 [CommenUtil LocalizedString:@"Settle.OpenNick"],
                                 [CommenUtil LocalizedString:@"Settle.BankNumber"]];
            
            _asView = [[MLAccountSettlementView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 330) withDataArray:@[dataArray,myArray]];
            [self.view addSubview:_asView];
        }
 
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
