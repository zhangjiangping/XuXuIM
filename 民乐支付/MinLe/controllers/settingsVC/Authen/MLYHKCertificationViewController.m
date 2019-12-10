//
//  MLYHKCertificationViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLYHKCertificationViewController.h"
#import "MLYHKAuthenticationView.h"
#import "MLValidationAuditsViewController.h"
#import "MLYHKDetectionView.h"
#import "MLZHViewController.h"
#import "MLHomeViewController.h"
#import "MLYHKHistoryViewController.h"
#import "MLLandingViewController.h"

@interface MLYHKCertificationViewController () <UITextFieldDelegate>
{
    BOOL isLhhture;//是否验证了支行
    int offset;//键盘弹起视图的偏移量
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLYHKAuthenticationView *yhkAuthView;
@property (nonatomic, strong) UIButton *but;
@property (nonatomic, strong) MLYHKDetectionView *detectionView;
@property (nonatomic, strong) UIScrollView *yhkSrcollView;
@property (nonatomic, strong) UIButton *backBut;
@end

@implementation MLYHKCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.yhkSrcollView];
    [self.view addSubview:self.but];
}

#pragma mark - textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.yhkAuthView.textField_LHH) {
        if (self.yhkAuthView.textField_LHH.text.length == 0) {
            [self showAleartView:[CommenUtil LocalizedString:@"Authen.BankAleartAgainMsg"]];
        } else {
            [self showAleartView:[CommenUtil LocalizedString:@"Authen.BankAleartNotChangeMsg"]];
        }
    }
}


#pragma mark - 返回
- (void)popAction
{
    if ([self.isPopRoot isEqualToString:@"1"]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MLHomeViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter

- (UIScrollView *)yhkSrcollView
{
    if (!_yhkSrcollView) {
        _yhkSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64-50)];
        _yhkSrcollView.contentSize = CGSizeMake(0, 750);
        _yhkSrcollView.showsVerticalScrollIndicator = NO;
        _yhkSrcollView.showsHorizontalScrollIndicator = NO;
        
        [_yhkSrcollView addSubview:self.yhkAuthView];
    }
    return _yhkSrcollView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Authen.Bank"]];
        
        _naView.but.alpha = 0;
        if (!self.isPeopleCertification) {
            [_naView addSubview:self.backBut];
        }
    }
    return _naView;
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

- (MLYHKAuthenticationView *)yhkAuthView
{
    if (!_yhkAuthView) {
        _yhkAuthView = [[MLYHKAuthenticationView alloc] initWithFrame:CGRectMake(15, 0, widthss-30, 650)];
        _yhkAuthView.textField_LHH.delegate = self;
        
        [_yhkAuthView.yhzhBut addTarget:self action:@selector(yhzhAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yhkAuthView;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        _but.backgroundColor = RGB(2, 138, 218);
        [_but setTitle:[CommenUtil LocalizedString:@"Authen.Submit"] forState:UIControlStateNormal];
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_but addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but.titleLabel.font = FT(20);
    }
    return _but;
}

#pragma mark - action

//获取支行
- (void)yhzhAction
{
    if ([self.yhkAuthView.yinhangNameLable.text isEqualToString:[CommenUtil LocalizedString:@"Authen.PleaseSelectedBank"]] ||
        [self.yhkAuthView.cityNameLable.text isEqualToString:[CommenUtil LocalizedString:@"Authen.PleaseSelectedCity"]]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.PleaseSelectedBankAndCity"] showView:nil];
    } else {
        MLZHViewController *zhVC = [[MLZHViewController alloc] init];
        zhVC.cityName = self.ccStr;
        zhVC.bankName = self.bankStr;
        zhVC.zhihangLable = self.yhkAuthView.zhihangNameLable;
        zhVC.lhhTextField = self.yhkAuthView.textField_LHH;
        [self.navigationController pushViewController:zhVC animated:YES];
    }
}

- (void)pushAction:(UIButton *)sender
{
    NSString *bank_typeStr = [NSString string];
    if (self.yhkAuthView.gerenBut.selected == NO && self.yhkAuthView.gongsiBut.selected == NO) {
        bank_typeStr = @"1";
    } else {
        bank_typeStr = @"2";
    }
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                          @"type":@"3",
                          @"bank_type":bank_typeStr,
                          @"bank_name":self.yhkAuthView.yinhangNameLable.text,
                          @"bank_area":self.yhkAuthView.cityNameLable.text,
                          @"bank_branch":self.yhkAuthView.zhihangNameLable.text,
                          @"bank":self.yhkAuthView.nameTextField.text,
                          @"bank_phone_num":self.yhkAuthView.haomaTextField.text,
                          @"cnaps_code":self.yhkAuthView.textField_LHH.text,
                          @"bank_id_card":self.yhkAuthView.cardNumberTextField.text};
    NSLog(@"%@",dic);
    
    if ([self.yhkChangeType isEqualToString:@"1"]) {
        [self submitWithUrl:addAutoBankURL withParameter:dic];
    } else {
        [self submitWithUrl:autoAddAuthen_yhk_URL withParameter:dic];
    }
}

- (void)submitWithUrl:(NSString *)url withParameter:(NSDictionary *)parameter
{
    if (self.yhkAuthView.nameTextField.text.length  == 0) {
        [self.yhkAuthView.nameTextField becomeFirstResponder];
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.FillNameSubmit"] showView:nil];
    } else if (self.yhkAuthView.haomaTextField.text.length == 0) {
        [self.yhkAuthView.haomaTextField becomeFirstResponder];
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.FillPhoneSubmit"] showView:nil];
    } else if ([self.yhkAuthView.yinhangNameLable.text isEqualToString:[CommenUtil LocalizedString:@"Authen.PleaseSelectedBank"]]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.SelectedBankSubmit"] showView:nil];
    } else if ([self.yhkAuthView.cityNameLable.text isEqualToString:[CommenUtil LocalizedString:@"Authen.PleaseSelectedCity"]]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.SelectedCitySubmit"] showView:nil];
    } else if ([self.yhkAuthView.zhihangNameLable.text isEqualToString:[CommenUtil LocalizedString:@"Authen.PleaseSelectedBranch"]]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.SelectedBranchSubmit"] showView:nil];
    } else if ([self.yhkAuthView.cerYHKView.leftImg.image isEqual:[UIImage imageNamed:@"bank-card"]]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.UploadBankPositivePhoto"] showView:nil];
    } else if (self.yhkAuthView.cardNumberTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.CardInfoIntegrity"] showView:nil];
    } else {
        NSArray *imgArray = @[self.yhkAuthView.cerYHKView.leftImg.image];
        [[MCNetWorking sharedInstance] myImageRequestWithUrlString:url withParameter:parameter withKey:@"bank_poster" withImageArray:imgArray withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                if (self.isPeopleCertification) {
                    MLLandingViewController *langVc = [[MLLandingViewController alloc] init];
                    [self.navigationController pushViewController:langVc animated:YES];
                } else {
                    if ([self.yhkChangeType isEqualToString:@"1"]) {
                        MLYHKHistoryViewController *historyVC = [[MLYHKHistoryViewController alloc] init];
                        [self.navigationController pushViewController:historyVC animated:YES];
                    } else {
                        MLValidationAuditsViewController *vaVC = [[MLValidationAuditsViewController alloc] init];
                        vaVC.statusStr = @"0";
                        vaVC.status = @"3";
                        vaVC.isPopRoot = self.isPopRoot;
                        [self.navigationController pushViewController:vaVC animated:YES];
                    }
                }
            }
        } withFailure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

