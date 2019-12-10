//
//  MLSetUpPassWordViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/18.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLSetUpPassWordViewController.h"
#import "MLMyTextField.h"
#import "MLLandingViewController.h"
#import "MLMinLeTextField.h"

@interface MLSetUpPassWordViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) MLMinLeTextField *passTextField;
@property (nonatomic, strong) MLMinLeTextField *tureTextField;
@property (nonatomic, strong) UIButton *onBut;
@property (nonatomic, strong) MLMyNavigationView *naView;
@end

@implementation MLSetUpPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.passTextField];
    [self.view addSubview:self.tureTextField];
    [self.view addSubview:self.onBut];
}

- (void)onAction:(UIButton *)sender
{
    if (self.passTextField.text.length == 0 || self.tureTextField.text.length == 0) {
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"SetupPassword.ContentNotEmpty"] showView:nil];
    } else if (![self.passTextField.text isEqualToString:self.tureTextField.text]) {
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"SetupPassword.TwoPasswordNotSame"] showView:nil];
    } else {
        NSDictionary *dic = @{@"phone":self.phoneStr,@"frist_pass":self.passTextField.text,@"confirm_pass":self.tureTextField.text};
        [[MCNetWorking sharedInstance] createPostWithUrlString:changePassURL withParameter:dic withComplection:^(id responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pass"];
                [[NSUserDefaults standardUserDefaults] setObject:self.tureTextField.text forKey:@"pass"];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneStr forKey:@"phone"];
                
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MLLandingViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            } else {
                [[MBProgressHUD shareManager] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - getter

- (MLMinLeTextField *)passTextField
{
    if (!_passTextField) {
        _passTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(40, 150, widthss-80, 50)];
        _passTextField.placeholder = [CommenUtil LocalizedString:@"SetupPassword.SetupLoginPassword"];
        _passTextField.secureTextEntry = YES;
        _passTextField.delegate = self;
    }
    return _passTextField;
}

- (MLMinLeTextField *)tureTextField
{
    if (!_tureTextField) {
        _tureTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.passTextField.frame)+20, widthss-80, 50)];
        _tureTextField.placeholder = [CommenUtil LocalizedString:@"SetupPassword.ConfirmPasswordAgain"];
        _tureTextField.secureTextEntry = YES;
        _tureTextField.delegate = self;
        
        [_tureTextField.tureBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tureTextField;
}

- (UIButton *)onBut
{
    if (!_onBut) {
        _onBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _onBut.backgroundColor = RGB(2, 138, 218);
        _onBut.frame = CGRectMake(0, heightss-60, widthss, 60);
        [_onBut setTitle:[CommenUtil LocalizedString:@"Common.Submit"] forState:UIControlStateNormal];
        [_onBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_onBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _onBut.titleLabel.font = FT(20);
    }
    return _onBut;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"SetupPassword"]];
    }
    return _naView;
}

#pragma mark - textField 代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
