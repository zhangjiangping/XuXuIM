//
//  MLPeopleCertificationViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLPeopleCertificationViewController.h"
#import "MLPeopleAuthenticationView.h"
#import "MLHomeViewController.h"
#import "MLValidationAuditsViewController.h"
#import "MLYHKCertificationViewController.h"

@interface MLPeopleCertificationViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLPeopleAuthenticationView *peopleAuthView;
@property (nonatomic, strong) UIButton *but;
@property (nonatomic, strong) UIButton *backBut;
@end

@implementation MLPeopleCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.peopleSrcollView];
    [self.view addSubview:self.but];
    
    [self request];
}

//获取实名认证返回来的数据
- (void)request
{
    NSDictionary *dic = @{@"token":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]};
    [SharedApp.netWorking myPostWithUrlString:getRealNameURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSDictionary *dataDic = responseObject[@"data"][0];
            self.peopleAuthView.phoneTextField.text = [NSString stringWithFormat:@"%@",dataDic[@"phone"]];
            self.peopleAuthView.nameTextField.text = [NSString stringWithFormat:@"%@",dataDic[@"actual_name"]];
            self.peopleAuthView.haomaTextField.text = [NSString stringWithFormat:@"%@",dataDic[@"id_card"]];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark - getter

- (UIScrollView *)peopleSrcollView
{
    if (!_peopleSrcollView) {
        _peopleSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64-50)];
        _peopleSrcollView.contentSize = CGSizeMake(0, 990);
        _peopleSrcollView.showsVerticalScrollIndicator = NO;
        _peopleSrcollView.showsHorizontalScrollIndicator = NO;
        [_peopleSrcollView addSubview:self.peopleAuthView];
    }
    return _peopleSrcollView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Authen.Qualification"]];
        _naView.but.alpha = 0;
        if (!self.isNameCertification) {
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
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(25, 30, 12, 20)];
        img.image = [UIImage imageNamed:@"Back"];
        img.clipsToBounds = YES;
        [_backBut addSubview:img];
    }
    return _backBut;
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

- (MLPeopleAuthenticationView *)peopleAuthView
{
    if (!_peopleAuthView) {
        _peopleAuthView = [[MLPeopleAuthenticationView alloc] initWithFrame:CGRectMake(15, 0, widthss-30, 910)];
    }
    return _peopleAuthView;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        _but.backgroundColor = RGB(2, 138, 218);
        if (self.isNameCertification) {
            [_but setTitle:[CommenUtil LocalizedString:@"Common.Next"] forState:UIControlStateNormal];
        } else {
            [_but setTitle:[CommenUtil LocalizedString:@"Authen.Submit"] forState:UIControlStateNormal];
        }
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_but addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but.titleLabel.font = FT(20);
    }
    return _but;
}

- (void)pushAction:(UIButton *)sender
{
    if (self.peopleAuthView.jcTextField.text.length == 0) {
        [self.peopleAuthView.jcTextField becomeFirstResponder];
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"Authen.PushReferredMsg"] showView:nil];
    } else if (self.peopleAuthView.qcTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.PushAllNameMsg"] showView:nil];
        [self.peopleAuthView.qcTextField becomeFirstResponder];
    } else if (self.peopleAuthView.dzTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.PushAddressMsg"] showView:nil];
        [self.peopleAuthView.dzTextField becomeFirstResponder];
    } else if (self.peopleAuthView.nameTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.PushLegalNameMsg"] showView:nil];
        [self.peopleAuthView.nameTextField becomeFirstResponder];
    } else if (self.peopleAuthView.phoneTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.PushLegalPhoneMsg"] showView:nil];
        [self.peopleAuthView.phoneTextField becomeFirstResponder];
    } else if (self.peopleAuthView.haomaTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.PushLegalIDMsg"] showView:nil];
        [self.peopleAuthView.haomaTextField becomeFirstResponder];
    } else if (self.peopleAuthView.yingYeTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.PushBusinessLicenseMsg"] showView:nil];
        [self.peopleAuthView.yingYeTextField becomeFirstResponder];
    } else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"token":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]],
                                                                                    @"type":@"2",
                                                                                    @"short_name":self.peopleAuthView.jcTextField.text,
                                                                                    @"name":self.peopleAuthView.qcTextField.text,
                                                                                    @"legal":self.peopleAuthView.nameTextField.text,
                                                                                    @"corporate_phone":self.peopleAuthView.phoneTextField.text,
                                                                                    @"legal_id_card":self.peopleAuthView.haomaTextField.text,
                                                                                    @"detailed_address":self.peopleAuthView.dzTextField.text,
                                                                                    @"business_number":self.peopleAuthView.yingYeTextField.text}];
        NSLog(@"参数：%@",dic);
        NSArray *imgArray = [NSArray array];
        if ([self.peopleAuthView.but1.imageView.image isEqual:[UIImage imageNamed:@"shangchuantupian"]]) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.UploadBusinessLicensePhotoMsg"] showView:nil];
        } else if ([self.peopleAuthView.but2.imageView.image isEqual:[UIImage imageNamed:@"shangchuantupian"]]) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.UploadMerchantsDealPhotoMsg"] showView:nil];
        } else if ([self.peopleAuthView.but3.imageView.image isEqual:[UIImage imageNamed:@"shangchuantupian"]]) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.UploadDoorFirstPhotoMsg"] showView:nil];
        } else if ([self.peopleAuthView.but4.imageView.image isEqual:[UIImage imageNamed:@"shangchuantupian"]]) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.UploadStorePhotoMsg"] showView:nil];
        } else if ([self.peopleAuthView.but5.imageView.image isEqual:[UIImage imageNamed:@"shangchuantupian"]]) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.UploadCheckstandPhotoMsg"] showView:nil];
        } else {
            imgArray = @[self.peopleAuthView.but1.imageView.image,self.peopleAuthView.but2.imageView.image,self.peopleAuthView.but3.imageView.image,self.peopleAuthView.but4.imageView.image,self.peopleAuthView.but5.imageView.image];
            [[MCNetWorking sharedInstance] myImageRequestWithUrlString:autoAddAuthen_yhk_URL withParameter:dic withKey:@"legal_poster" withImageArray:imgArray withComplection:^(id responseObject) {
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
                if ([responseObject[@"status"] isEqual:@1]) {
                    [self pushVc];
                }
            } withFailure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        }
   }
}

- (void)pushVc
{
    if (self.isNameCertification) {
        MLYHKCertificationViewController *yhkVc = [[MLYHKCertificationViewController alloc] init];
        yhkVc.isPeopleCertification = YES;
        [self.navigationController pushViewController:yhkVc animated:YES];
    } else {
        MLValidationAuditsViewController *vaVC = [[MLValidationAuditsViewController alloc] init];
        vaVC.statusStr = @"0";
        vaVC.isPopRoot = self.isPopRoot;
        vaVC.status = @"2";
        [self.navigationController pushViewController:vaVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
