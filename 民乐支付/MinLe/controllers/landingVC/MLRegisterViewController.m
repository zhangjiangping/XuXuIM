//
//  MLRegisterViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLRegisterViewController.h"
#import "MLLandingViewController.h"
#import "NSString+MyString.h"
#import "MLRegisterView.h"
#import "MLNameAuthenticationViewController.h"

@interface MLRegisterViewController ()
{
    NSTimer *time;
    NSInteger myTime;
}
@property (nonatomic, strong) MLRegisterView *registerView;
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *nextBut;
@end

@implementation MLRegisterViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [time invalidate];
    time = nil;
    myTime = 120;
    self.registerView.lable.text = [CommenUtil LocalizedString:@"Register.GetCode"];
    self.registerView.lable.textColor = RGB(2, 138, 218);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myTime = 120;
}
- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.nextBut];
    [self.view addSubview:self.registerView];
    [self.registerView.but addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
}

//注册
- (void)nextAction:(UIButton *)sender
{
    if (self.registerView.phoneTextField.text.length == 0        ||
        self.registerView.verificationTextField.text.length == 0 ||
        self.registerView.textField_DLS.text.length == 0         ||
        self.registerView.textField_DLMM.text.length == 0        ||
        self.registerView.textField_TMM.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Register.RegistrationInformationComplete"] showView:nil];
    } else if (![NSString isMobile:self.registerView.phoneTextField.text] && [self.registerView.countryCode isEqualToString:@"86"]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.PhoneFormatNotCorrect"] showView:nil];
    } else if (![CommenUtil isMobileWithPhone:self.registerView.phoneTextField.text withCode:self.registerView.countryIcon]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.DetectsNotMatch"] showView:nil];
    } else if (self.registerView.textField_DLMM.text.length < 6  ||
          self.registerView.textField_DLMM.text.length > 12 ||
          self.registerView.textField_TMM.text.length  < 6  ||
          self.registerView.textField_TMM.text.length  > 12) {
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"Register.PasswordSetupMsg"] showView:nil];
    } else if (![self.registerView.textField_DLMM.text isEqualToString:self.registerView.textField_TMM.text]) {
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"Register.TwoPasswordNotSame"] showView:nil];
    } else if (self.registerView.gouBut.selected) {
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"Register.CheckAgreement"] showView:nil];
    } else {
        NSString *countryCode = self.registerView.countryCode;
        NSMutableDictionary *dic = [@{@"phone":self.registerView.phoneTextField.text,
                                      @"prefix":countryCode,
                                      @"code":self.registerView.verificationTextField.text,
                                      @"number":self.registerView.textField_DLS.text,
                                      @"login_pass":self.registerView.textField_DLMM.text,
                                      @"confirm_pass":self.registerView.textField_TMM.text} mutableCopy];
        if (self.openID) {
            [dic setObject:self.openID forKey:@"openid"];
        }
        [[MCNetWorking sharedInstance] myPostWithUrlString:registerURL withParameter:dic withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                [self saveInformationUserDefaults:responseObject withIsLogin:NO];
                
                MLNameAuthenticationViewController *nameVC = [[MLNameAuthenticationViewController alloc] init];
                nameVC.isRegister = YES;
                [self.navigationController pushViewController:nameVC animated:YES];
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
    if (self.registerView.phoneTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Register.PhoneNotEmpty"] showView:nil];
    } else if (![NSString isMobile:self.registerView.phoneTextField.text] && [self.registerView.countryCode isEqualToString:@"86"]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.PhoneFormatNotCorrect"] showView:nil];
    } else if (![CommenUtil isMobileWithPhone:self.registerView.phoneTextField.text withCode:self.registerView.countryIcon]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.DetectsNotMatch"] showView:nil];
    } else {
        self.registerView.lable.textColor = [UIColor lightGrayColor];
        NSString *countryCode = self.registerView.countryCode;
        NSDictionary *registerDic = @{@"prefix":countryCode,
                                      @"phone":self.registerView.phoneTextField.text};
        [[MCNetWorking sharedInstance] myPostWithUrlString:register_sendURL withParameter:registerDic withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                self.registerView.but.enabled = NO;
                //开启计时器
                time = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timefireMethod) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
                self.registerView.lable.text = [CommenUtil LocalizedString:@"120Resend"];
            } else {
                self.registerView.but.enabled = YES;
                self.registerView.lable.text = [CommenUtil LocalizedString:@"Register.ClickToGet"];
                self.registerView.lable.textColor = RGB(2, 138, 218);
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
    self.registerView.lable.text = [NSString stringWithFormat:@"%ld%@", myTime,[CommenUtil LocalizedString:@"Register.AfterSeconds"]];
    if (myTime == 0) {
        self.registerView.but.enabled = YES;
        self.registerView.lable.text = [CommenUtil LocalizedString:@"Register.ClickToGet"];
        self.registerView.lable.textColor = RGB(2, 138, 218);
        [time invalidate];
        time = nil;
        myTime = 120;
    }
    NSLog(@"%ld", myTime);
}

#pragma mark - getter

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Register"]];
    }
    return _naView;
}

- (MLRegisterView *)registerView
{
    if (!_registerView) {
        _registerView = [[MLRegisterView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64-50)];
        [_registerView.textField_TMM.tureBut addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerView;
}

- (UIButton *)nextBut
{
    if (!_nextBut) {
        _nextBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextBut.frame = CGRectMake(0, heightss-50, widthss, 50);
        _nextBut.backgroundColor = RGB(2, 138, 218);
        [_nextBut setTitle:[CommenUtil LocalizedString:@"Register"] forState:UIControlStateNormal];
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
