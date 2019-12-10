//
//  MLNOCardViewController.m
//  minlePay
//
//  Created by JP on 2017/10/16.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLNOCardViewController.h"
#import "MLCardRegisterViewController.h"
#import "MLNoCardRegisterViewController.h"
#import "MLCardOrderViewController.h"
#import "MLCertificationWindowView.h"
#import "MLNameAuthenticationViewController.h"
#import "MLYHKCertificationViewController.h"
#import "MLPeopleCertificationViewController.h"
#import "MLValidationAuditsViewController.h"
#import "MLNOCardCodeTureViewController.h"
#import "MLNoCardView.h"
#import "Data.h"
#import "MLEnum.h"

@interface MLNOCardViewController ()
{
    NSNumber *statusNum;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *registerBut;//注册按钮
@property (nonatomic, strong) UIButton *but;//交易按钮

@property (nonatomic, strong) UIScrollView *noCardSrcollView;
@property (nonatomic, strong) MLNoCardView *noCardView;

@property (nonatomic, strong) MLCertificationWindowView *cerWindowView;//未注册弹出视图

@property (nonatomic, assign) AuthState authState;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation MLNOCardViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [hud hide:YES];
    [self.cerWindowView hiden];
}

//刚进入界面的时候
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Detection..."] showView:nil];
    [self requestShowAuther];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.naView];
    [self.view addSubview:self.noCardSrcollView];
    [self.view addSubview:self.but];
    [self.view addSubview:self.cerWindowView];
    
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取实时最新数据
- (void)request
{
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                          @"type":@"1_2"};
    [SharedApp.netWorking myPostWithUrlString:getUserCardInfoURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSArray *dataArray = responseObject[@"data"];
            if (dataArray && dataArray.count > 0) {
                /*
                 mobile : 手机号,
                 cardno : 收款借记卡,
                 bank_user_name : 用户名,
                 id_card : 身份证
                 */
                _dataDic = dataArray[0];
                self.noCardView.phoneNumberTextField.text = _dataDic[@"mobile"];
                self.noCardView.haomaTextField.text = _dataDic[@"id_card"];
                self.noCardView.cardNameTextField.text = _dataDic[@"bank_user_name"];
                self.noCardView.settlementBorrowTextField.text = _dataDic[@"cardno"];
            }
        }
    } withFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - Action

//点击交易按钮
- (void)pushAction:(UIButton *)sender
{
    if ([self.noCardView.openOrderLable.text isEqualToString:[CommenUtil LocalizedString:@"NoCard.PleaseSelect"]]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"NoCard.OpenCardNotEmpty"] showView:nil];
    } else if (self.noCardView.orderTradingMoneyTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"NoCard.OrderMoneyNotEmpty"] showView:nil];
        [self.noCardView.orderTradingMoneyTextField becomeFirstResponder];
    } else if (self.noCardView.settlementBorrowTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"NoCard.DebitCardNotEmpty"] showView:nil];
        [self.noCardView.settlementBorrowTextField becomeFirstResponder];
    } else {
        [self tradingRequest];
    }
}

//交易调接口
- (void)tradingRequest
{
    if ([self moneyIsOK]) {
        NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                              @"type":@"1",
                              @"money":_noCardView.orderTradingMoneyTextField.text,
                              @"bank":_noCardView.settlementBorrowTextField.text};
        [SharedApp.netWorking createPostWithLoading:[CommenUtil LocalizedString:@"order..."] withUrlString:cardPayURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                MLNOCardCodeTureViewController *coderTureVc = [[MLNOCardCodeTureViewController alloc] init];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_dataDic];
                [dic setObject:_noCardView.orderTradingMoneyTextField.text forKey:@"money"];
                [dic setObject:_noCardView.settlementBorrowTextField.text forKey:@"bank"];
                coderTureVc.dataDic = dic;
                coderTureVc.orderStr = responseObject[@"msg"];
                [self.navigationController pushViewController:coderTureVc animated:YES];
            } else {
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

//跳转开卡列表
- (void)orderAction:(UIButton *)sender
{
    MLCardRegisterViewController *vc = [[MLCardRegisterViewController alloc] init];
    vc.block = ^(Data *data) {
        self.noCardView.openOrderLable.text = data.cardno;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转订单号列表
- (void)registerAction
{
    MLCardOrderViewController *vc = [[MLCardOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//判断输入金额是否满足要求
- (BOOL)moneyIsOK
{
    NSString *moneyText = self.noCardView.orderTradingMoneyTextField.text;
    float money = [moneyText floatValue];
    if (money - 10 < 0) {
        [self showAleartView:[CommenUtil LocalizedString:@"NoCard.OrderMoneyBelow10Yuan"]];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 接口判断认证

//判断信息认证
- (void)requestShowAuther
{
    [[MCNetWorking sharedInstance] myPostWithUrlString:check_actauthenURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        statusNum = responseObject[@"status"];
        if ([statusNum isEqual:@1] || [statusNum isEqual:@10]) {
            [self requestShowNoCardRegister];
            return ;
        } else {
            [hud hide:YES];
            _authState = AuthStateNoProfile;
            [self.cerWindowView show];
            [self.cerWindowView setAuthCerWindowViewState:statusNum];
        }
    } withFailure:^(NSError *error) {
        [hud hide:YES];
        _authState = AuthStateError;
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

//判断是否注册了无卡支付
- (void)requestShowNoCardRegister
{
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                          @"type":@"1"};
    [SharedApp.netWorking myPostWithUrlString:checkRegisterURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        [hud hide:YES];
        if ([responseObject[@"status"] isEqual:@1]) {
            _authState = AuthStateSuccess;
        } else {
            _authState = AuthStateNoCardNoRegister;
            [self.cerWindowView show];
            //弹出视图更新
            [self.cerWindowView setNoCardCerWindowViewState];
        }
    } withFailure:^(NSError *error) {
        [hud hide:YES];
        _authState = AuthStateError;
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

//去注册按钮
- (void)playAction
{
    if (_authState == AuthStateNoProfile) {
        [self profilePlayAction];
    } else if (_authState == AuthStateNoCardNoRegister) {
        MLNoCardRegisterViewController *vc = [[MLNoCardRegisterViewController alloc] init];
        vc.isPopRoot = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//取消弹出框
- (void)cancelAction
{
    [self.cerWindowView hiden];
}

//信息认证跳转
- (void)profilePlayAction
{
    if (![statusNum isEqual:@1]) {
        if ([statusNum isEqual:@0] || [statusNum isEqual:@2]) {
            MLNameAuthenticationViewController *nameVC = [[MLNameAuthenticationViewController alloc] init];
            nameVC.isPopRoot = @"1";
            [self.navigationController pushViewController:nameVC animated:YES];
        } else if ([statusNum isEqual:@3] || [statusNum isEqual:@6] || [statusNum isEqual:@9]) {
            MLValidationAuditsViewController *vaVC = [[MLValidationAuditsViewController alloc] init];
            vaVC.statusStr = statusNum.description;
            if ([statusNum isEqual:@3]) {
                vaVC.status = @"1";
            } else if ([statusNum isEqual:@6]) {
                vaVC.status = @"2";
            } else if ([statusNum isEqual:@9]) {
                vaVC.status = @"3";
            }
            vaVC.isPopRoot = @"1";
            [self.navigationController pushViewController:vaVC animated:YES];
        } else if ([statusNum isEqual:@7] || [statusNum isEqual:@8]) {
            MLYHKCertificationViewController *yhkVC = [[MLYHKCertificationViewController alloc] init];
            yhkVC.isPopRoot = @"1";
            [self.navigationController pushViewController:yhkVC animated:YES];
        } else if ([statusNum isEqual:@4] || [statusNum isEqual:@5]) {
            MLPeopleCertificationViewController *nameVC = [[MLPeopleCertificationViewController alloc] init];
            nameVC.isPopRoot = @"1";
            [self.navigationController pushViewController:nameVC animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [self.cerWindowView hiden];
}

#pragma mark - getter

- (UIScrollView *)noCardSrcollView
{
    if (!_noCardSrcollView) {
        _noCardSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64-50)];
        _noCardSrcollView.contentSize = CGSizeMake(0, 600);
        _noCardSrcollView.showsVerticalScrollIndicator = NO;
        _noCardSrcollView.showsHorizontalScrollIndicator = NO;
        
        [_noCardSrcollView addSubview:self.noCardView];
    }
    return _noCardSrcollView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"NoCard.NoCardTrading"]];
        [_naView addSubview:self.registerBut];
    }
    return _naView;
}

- (UIButton *)registerBut
{
    if (!_registerBut) {
        _registerBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _registerBut.frame = CGRectMake(screenWidth-64, 20, 64, 44);
        _registerBut.backgroundColor = [UIColor clearColor];
        [_registerBut setTitle:[CommenUtil LocalizedString:@"Register"] forState:UIControlStateNormal];
        [_registerBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBut addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBut;
}

- (MLNoCardView *)noCardView
{
    if (!_noCardView) {
        _noCardView = [[MLNoCardView alloc] initWithFrame:CGRectMake(15, 0, widthss-30, 550)];
        [_noCardView.openOrderBut addTarget:self action:@selector(orderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noCardView;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        _but.backgroundColor = RGB(2, 138, 218);
        [_but setTitle:[CommenUtil LocalizedString:@"NoCard.PlaceOrder"] forState:UIControlStateNormal];
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_but addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but.titleLabel.font = FT(20);
    }
    return _but;
}

- (MLCertificationWindowView *)cerWindowView
{
    if (!_cerWindowView) {
        _cerWindowView = [[MLCertificationWindowView alloc] initWithFrame:CGRectMake(0, -1000, widthss, heightss) withButtonTitle:[CommenUtil LocalizedString:@"NoCard.GoRegister"]];
        [_cerWindowView.certificationBut addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [_cerWindowView.cancelBut addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cerWindowView;
}

@end


