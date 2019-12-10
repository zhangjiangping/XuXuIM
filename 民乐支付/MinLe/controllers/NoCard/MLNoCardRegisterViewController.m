//
//  MLNoCardRegisterViewController.m
//  minlePay
//
//  Created by JP on 2017/10/16.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLNoCardRegisterViewController.h"
#import "BasePostWebViewController.h"
#import "BaseWebViewController.h"
#import "MLNoCardRegisterView.h"
#import "MLHomeViewController.h"

@interface MLNoCardRegisterViewController ()
{
    MBProgressHUD *hud;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *backBut;//返回按钮
@property (nonatomic, strong) UIButton *registerbut;//交易按钮
@property (nonatomic, strong) MLNoCardRegisterView *noCardregisterView;

@end

@implementation MLNoCardRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.naView];
    [self.view addSubview:self.noCardregisterView];
    [self.view addSubview:self.registerbut];
    
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
                          @"type":@"1_1"};
    [SharedApp.netWorking createPostWithUrlString:getUserCardInfoURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSArray *dataArray = responseObject[@"data"];
            if (dataArray && dataArray.count > 0) {
                /*
                 mobile : 手机号,
                 */
                NSDictionary *dic = dataArray[0];
                self.noCardregisterView.phoneNumberTextField.text = dic[@"mobile"];
            }
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
    if (self.noCardregisterView.openCardNumberTextField.text.length == 0) {
        [self.noCardregisterView.openCardNumberTextField becomeFirstResponder];
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"NoCard.DebitCARDSMsg"] showView:nil];
    } else {
        hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Loading..."] showView:nil];
        NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                              @"cardno":self.noCardregisterView.openCardNumberTextField.text,
                              @"mobile":self.noCardregisterView.phoneNumberTextField.text};
        [SharedApp.netWorking myPostWithUrlString:cardPayOpenURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                [self htmlRequest:responseObject[@"msg"]];
            } else {
                [hud hide:YES];
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [hud hide:YES];
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

- (void)htmlRequest:(NSString *)parameter
{
    [SharedApp.netWorking htmlPostWithUrlString:regJumpURL withParameter:@{@"html":parameter} withComplection:^(NSDictionary *responseObject) {
        if (responseObject[@"html"]) {
            BaseWebViewController *webVc = [[BaseWebViewController alloc] init];
            webVc.isHtml = YES;
            webVc.htmlDataString = responseObject[@"html"];
            webVc.titleStr = [CommenUtil LocalizedString:@"NoCard.NotCardRegisterOpen"];
            [self.navigationController pushViewController:webVc animated:YES];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
        [hud hide:YES];
    } withFailure:^(NSError *error) {
        [hud hide:YES];
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark - getter

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"NoCard.NoCardRegister"]];
        _naView.but.alpha = 0;
        [_naView addSubview:self.backBut];
    }
    return _naView;
}

- (MLNoCardRegisterView *)noCardregisterView
{
    if (!_noCardregisterView) {
        _noCardregisterView = [[MLNoCardRegisterView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 240)];
    }
    return _noCardregisterView;
}

- (UIButton *)registerbut
{
    if (!_registerbut) {
        _registerbut = [UIButton buttonWithType:UIButtonTypeSystem];
        _registerbut.frame = CGRectMake(0, heightss-50, widthss, 50);
        _registerbut.backgroundColor = RGB(2, 138, 218);
        [_registerbut setTitle:[CommenUtil LocalizedString:@"Register"] forState:UIControlStateNormal];
        [_registerbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerbut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _registerbut.titleLabel.font = FT(20);
    }
    return _registerbut;
}

- (UIButton *)backBut
{
    if (!_backBut) {
        _backBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _backBut.frame = CGRectMake(0, 0, 64, 64);
        [_backBut addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 12, 20)];
        img.image = [UIImage imageNamed:@"Back"];
        img.clipsToBounds = YES;
        [_backBut addSubview:img];
    }
    return _backBut;
}

- (void)popAction
{
    if (self.isPopRoot) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MLHomeViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
