//
//  MLWithdrawalViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLWithdrawalViewController.h"
#import "MLWithdrawalView.h"
#import "MLDrawAuditViewController.h"
#import "BaseWebViewController.h"
#import "NSString+MyString.h"

@interface MLWithdrawalViewController ()
{
    NSString *moneyStr;//提现总金额
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLWithdrawalView *drawView;
@property (nonatomic, strong) UIButton *xiaBut;
@property (nonatomic, strong) UIButton *instructionsBut;
@end

@implementation MLWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    [self request];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.xiaBut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)request
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:withdrawalsURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            moneyStr = responseObject[@"data"][0][@"money"];
            self.drawView.balanceLable.text = [NSString stringWithFormat:@"%@￥%@", [CommenUtil LocalizedString:@"Draw.CurrentBalance"],moneyStr];
            self.drawView.yhLable.text = [NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"bank_name"]];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@", error);
    }];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Draw.AmountWithdrawal"]];
        [_naView addSubview:self.instructionsBut];
    }
    return _naView;
}

- (MLWithdrawalView *)drawView
{
    if (!_drawView) {
        _drawView = [[MLWithdrawalView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, heightss/2.22)];
        [_drawView.allBut addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
        [_drawView.moneyTextField.tureBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _drawView;
}

- (UIButton *)instructionsBut
{
    if (!_instructionsBut) {
        _instructionsBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _instructionsBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-50, 14, 50, 50);
        [_instructionsBut addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        img.image = [UIImage imageNamed:@"bangzhuzhongxin"];
        img.clipsToBounds = YES;
        [_instructionsBut addSubview:img];
    }
    return _instructionsBut;
}

- (UIButton *)xiaBut
{
    if (!_xiaBut) {
        _xiaBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _xiaBut.frame = CGRectMake(0, heightss-55, widthss, 55);
        [_xiaBut setTitle:[CommenUtil LocalizedString:@"Draw.Withdrawal"] forState:UIControlStateNormal];
        [_xiaBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _xiaBut.backgroundColor = RGB(2, 138, 218);
        [_xiaBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _xiaBut.titleLabel.font = FT(19);
    }
    return _xiaBut;
}

- (void)onAction:(UIButton *)sender
{
    if (self.drawView.moneyTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Draw.MoneyNotEmpty"] showView:nil];
    } else if (![NSString isTwoPoint:self.drawView.moneyTextField.text]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Draw.AmountWrong"] showView:nil];
    } else if ([self.drawView.moneyTextField.text floatValue] - 0.009 < 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Draw.MoneyNotBelow0.01"] showView:nil];
    } else if ([self.drawView.moneyTextField.text floatValue] - 50000 >= 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Draw.MoneyNotAbove5Wan"] showView:nil];
    } else if ([self.drawView.moneyTextField.text floatValue] - [moneyStr floatValue] > 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Draw.AboveMsg"] showView:nil];
    } else {
        [[MCNetWorking sharedInstance] createPostWithUrlString:withdrawals_doURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"money":self.drawView.moneyTextField.text} withComplection:^(id responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                MLDrawAuditViewController *auditVC = [[MLDrawAuditViewController alloc] init];
                auditVC.timeStr = responseObject[@"data"][0][@"create_time"];
                [self.navigationController pushViewController:auditVC animated:YES];
            } else {
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

- (void)allAction:(UIButton *)sender
{
    self.drawView.moneyTextField.text = moneyStr;
    [self.drawView.moneyTextField becomeFirstResponder];
    sender.alpha = 0.0;
}

- (void)pushAction
{
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.titleStr = [CommenUtil LocalizedString:@"Draw.WithdrawalNotice"];
    webVC.urlStr = [NSString stringWithFormat:@"%@3",ApiH5URL];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.drawView.moneyTextField resignFirstResponder];
}

//当视图完全显示 让输入框成为第一响应者
- (void)viewDidAppear:(BOOL)animated
{
    [_drawView.moneyTextField becomeFirstResponder];
}

@end





