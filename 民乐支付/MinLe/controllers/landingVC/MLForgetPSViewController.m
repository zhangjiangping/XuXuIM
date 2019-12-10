//
//  MLForgetPSViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLForgetPSViewController.h"
#import "MLVerificationView.h"
#import "NSString+MyString.h"
#import "MLSetUpPassWordViewController.h"

@interface MLForgetPSViewController ()
{
    NSTimer *time;
    NSInteger myTime;
}
@property (nonatomic, strong) MLVerificationView *verificationView;
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *nextBut;
@end

@implementation MLForgetPSViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [time invalidate];
    time = nil;
    myTime = 120;
    self.verificationView.lable.text = [CommenUtil LocalizedString:@"Register.GetCode"];
    self.verificationView.lable.textColor = RGB(2, 138, 218);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myTime = 120;
}
- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.nextBut];
    [self.view addSubview:self.verificationView];
    [self.verificationView.but addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.verificationView.verificationTextField.tureBut addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
}

//下一步
- (void)nextAction:(UIButton *)sender
{
    if (self.verificationView.phoneTextField.text.length == 0 || self.verificationView.verificationTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"ForgetPassword.PhoneAndCodeNotEmpty"] showView:nil];
    } else if (![NSString isMobile:self.verificationView.phoneTextField.text] && [self.verificationView.countryCode isEqualToString:@"86"]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.PhoneFormatNotCorrect"] showView:nil];
    } else if (![CommenUtil isMobileWithPhone:self.verificationView.phoneTextField.text withCode:self.verificationView.countryIcon]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.DetectsNotMatch"] showView:nil];
    } else {
        NSDictionary *dic = @{@"phone":self.verificationView.phoneTextField.text,
                              @"code":self.verificationView.verificationTextField.text,
                              @"prefix":self.verificationView.countryCode};
        [[MCNetWorking sharedInstance] myPostWithUrlString:passPhoneURL withParameter:dic withComplection:^(id responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                MLSetUpPassWordViewController *myPassVC = [[MLSetUpPassWordViewController alloc] init];
                myPassVC.phoneStr = self.verificationView.phoneTextField.text;
                [self.navigationController pushViewController:myPassVC animated:YES];
            } else {
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
            NSLog(@"%@",responseObject);
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - Action

//获取验证码
- (void)onAction:(UIButton *)sender
{
    if (self.verificationView.phoneTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Register.PhoneNotEmpty"] showView:nil];
    } else if (![NSString isMobile:self.verificationView.phoneTextField.text] && [self.verificationView.countryCode isEqualToString:@"86"]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.PhoneFormatNotCorrect"] showView:nil];
    } else if (![CommenUtil isMobileWithPhone:self.verificationView.phoneTextField.text withCode:self.verificationView.countryIcon]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.DetectsNotMatch"] showView:nil];
    } else {
        self.verificationView.lable.textColor = [UIColor lightGrayColor];
        [[MCNetWorking sharedInstance] myPostWithUrlString:forgetPassURL withParameter:@{@"phone":self.verificationView.phoneTextField.text,@"prefix":_verificationView.countryCode} withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                self.verificationView.but.enabled = NO;
                //开启计时器
                time = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timefireMethod) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
                self.verificationView.lable.text = [CommenUtil LocalizedString:@"Register.120Resend"];
            } else {
                self.verificationView.but.enabled = YES;
                self.verificationView.lable.text = [CommenUtil LocalizedString:@"Register.ClickToGet"];
                self.verificationView.lable.textColor = RGB(2, 138, 218);
                [time invalidate];
                time = nil;
                myTime = 120;
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

//倒计时
- (void)timefireMethod
{
    myTime--;
    self.verificationView.lable.text = [NSString stringWithFormat:@"%ld%@", myTime,[CommenUtil LocalizedString:@"Register.AfterSeconds"]];
    if (myTime == 0) {
        self.verificationView.but.enabled = YES;
        self.verificationView.lable.text = [CommenUtil LocalizedString:@"Register.ClickToGet"];
        self.verificationView.lable.textColor = RGB(2, 138, 218);
        [time invalidate];
        time = nil;
        myTime = 120;
    }
}

#pragma mark - getter

- (MLVerificationView *)verificationView
{
    if (!_verificationView) {
        _verificationView = [[MLVerificationView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64-50)];
    }
    return _verificationView;
}


- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"ForgetPassword.RetrievePassword"]];
    }
    return _naView;
}

- (UIButton *)nextBut
{
    if (!_nextBut) {
        _nextBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextBut.frame = CGRectMake(0, heightss-50, widthss, 50);
        _nextBut.backgroundColor = RGB(2, 138, 218);
        [_nextBut setTitle:[CommenUtil LocalizedString:@"Common.Next"] forState:UIControlStateNormal];
        [_nextBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBut.titleLabel.font = FT(19);
        [_nextBut addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBut;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
