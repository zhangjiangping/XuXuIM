//
//  MLSettingsPhoneViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLSettingsPhoneViewController.h"
#import "MLMinLeTextField.h"
#import "MLSettingsPhoneViewController.h"
#import "MLLandingViewController.h"
#import "VETCountryViewController.h"
#import "NSString+MyString.h"
#import "BaseLayerView.h"

#define YZM_WW  (widthss-30-30-20)/2
#define TextFieldHeight 44

@interface MLSettingsPhoneViewController ()
{
    NSTimer *time;
    int myTime;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLMinLeTextField *yzmTextField;
@property (nonatomic, strong) UIButton *yzmBut;
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) MLMinLeTextField *newsPassTextField;
@property (nonatomic, strong) UIButton *but;
@property (nonatomic, strong) BaseLayerView *layerView;

@property (nonatomic, strong) UIButton *countryBut;
@property (nonatomic, strong) UIImageView *countryRightImg;
@property (nonatomic, strong) UILabel *countryLable;

@property (nonatomic, strong) NSString *countryName;//国家名字
@property (nonatomic, strong) NSString *countryCode;//国家区号
@property (nonatomic, strong) NSString *countryIcon;//国家code

@end

@implementation MLSettingsPhoneViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [time invalidate];
    time = nil;
    myTime = 120;
    self.lable.text = [CommenUtil LocalizedString:@"Register.GetCode"];
    self.lable.textColor = blueRGB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myTime = 120;
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.layerView];
    [self.view addSubview:self.but];
    
    [self setupCountry];
}

- (void)setupCountry
{
    if (!SharedApp.currentCountry) {
        [SharedApp setupDefaultAccount];
    }
    _countryName = SharedApp.currentCountry.countryChineseName;
    _countryCode = SharedApp.currentCountry.code;
    _countryIcon = SharedApp.currentCountry.icon;
    _countryLable.text = [NSString stringWithFormat:@"%@ (+%@)",_countryName,_countryCode];
}

//选择国家
- (void)tapCountryButton:(UIButton *)sender
{
    VETCountryViewController *countryVC = [VETCountryViewController new];
    countryVC.countryBlock = ^(VETCountry *country) {
        _countryName = country.countryChineseName;
        _countryCode = country.code;
        _countryIcon = country.icon;
        _countryLable.text = [NSString stringWithFormat:@"%@ (+%@)",_countryName,_countryCode];
    };
    [self.navigationController pushViewController:countryVC animated:YES];
}

#pragma mark - getter

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 260)];
        [_layerView addSubview:self.countryBut];
        [_layerView addSubview:self.newsPassTextField];
        [_layerView addSubview:self.yzmTextField];
        [_layerView addSubview:self.yzmBut];
    }
    return _layerView;
}

- (UIButton *)countryBut
{
    if (!_countryBut) {
        _countryBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _countryBut.frame = CGRectMake(15, 30, CGRectGetWidth(self.layerView.frame)-30, TextFieldHeight);
        _countryBut.backgroundColor = RGB(241, 241, 241);
        _countryBut.layer.cornerRadius = 10;
        [_countryBut addTarget:self action:@selector(tapCountryButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_countryBut addSubview:self.countryLable];
        [_countryBut addSubview:self.countryRightImg];
    }
    return _countryBut;
}

- (UILabel *)countryLable
{
    if (!_countryLable) {
        _countryLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.countryBut.frame)-10*2-15-18, CGRectGetHeight(self.countryBut.frame))];
    }
    return _countryLable;
}

- (UIImageView *)countryRightImg
{
    if (!_countryRightImg) {
        _countryRightImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryLable.frame)+10, (CGRectGetHeight(self.countryBut.frame)-18)/2, 18, 18)];
        _countryRightImg.image = [UIImage imageNamed:@"icon--more"];
        _countryRightImg.clipsToBounds = YES;
    }
    return _countryRightImg;
}

- (MLMinLeTextField *)newsPassTextField
{
    if (!_newsPassTextField) {
        _newsPassTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.countryBut.frame)+30, CGRectGetWidth(self.layerView.frame)-30, TextFieldHeight)];
        _newsPassTextField.placeholder = [CommenUtil LocalizedString:@"Setting.EnterNewPhone"];
    }
    return _newsPassTextField;
}

- (MLMinLeTextField *)yzmTextField
{
    if (!_yzmTextField) {
        _yzmTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.newsPassTextField.frame)+30, YZM_WW, TextFieldHeight)];
        _yzmTextField.placeholder = [CommenUtil LocalizedString:@"NoCard.InputCode"];
        _yzmTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        [_yzmTextField.tureBut addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside ];
    }
    return _yzmTextField;
}

- (UIButton *)yzmBut
{
    if (!_yzmBut) {
        _yzmBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _yzmBut.frame = CGRectMake(CGRectGetWidth(self.layerView.frame)-YZM_WW-15, CGRectGetMaxY(self.newsPassTextField.frame)+30, YZM_WW, TextFieldHeight);
        _yzmBut.layer.borderColor = LayerRGB(2, 138, 218);
        _yzmBut.layer.borderWidth = 1;
        _yzmBut.layer.cornerRadius = 5;
        [_yzmBut addSubview:self.lable];
        [_yzmBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yzmBut;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:self.yzmBut.bounds];
        _lable.text = [CommenUtil LocalizedString:@"Register.GetCode"];
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.textColor = RGB(2, 138, 218);
    }
    return _lable;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        [_but setTitle:[CommenUtil LocalizedString:@"Common.Submit"] forState:UIControlStateNormal];
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _but.backgroundColor = RGB(2, 138, 218);
        _but.titleLabel.font = FT(19);
        [_but addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _but;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 264) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Setting.NewPhoneNumber"]];
    }
    return _naView;
}

//提交
- (void)playAction:(UIButton *)sender
{
    if (self.yzmTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Setting.CodeNotEmpty"] showView:nil];
    } else if (![NSString isMobile:self.newsPassTextField.text] && [_countryCode isEqualToString:@"86"]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.PhoneFormatNotCorrect"] showView:nil];
    } else if (![CommenUtil isMobileWithPhone:_newsPassTextField.text withCode:_countryIcon]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.DetectsNotMatch"] showView:nil];
    } else {
        NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                              @"code":self.yzmTextField.text,
                              @"prefix":_countryCode,
                              @"new_phone":self.newsPassTextField.text};
        [[MCNetWorking sharedInstance] myPostWithUrlString:update_phoneURL withParameter:dic withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.newsPassTextField.text forKey:@"phone"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][0][@"part_phone"] forKey:@"part_phone"];
                [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Setting.PhoneChangeSuccess"] showView:nil];
                [SharedApp setupRootViewController:[[MLLandingViewController alloc] init]];
            } else {
                self.yzmBut.enabled = YES;
                self.lable.text = [CommenUtil LocalizedString:@"Register.ClickToGet"];
                self.lable.textColor = blueRGB;
                [time invalidate];
                time = nil;
                myTime = 120;
            }
        } withFailure:^(NSError *error) {
            NSLog(@"%@", error);
            self.lable.textColor = blueRGB;
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        }];
    }
}

//获取验证码
- (void)onAction:(UIButton *)sender
{
    if (self.newsPassTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Setting.NewPhoneNotEmpty"] showView:nil];
    } else if (![NSString isMobile:self.newsPassTextField.text] && [_countryCode isEqualToString:@"86"]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.PhoneFormatNotCorrect"] showView:nil];
    } else if (![CommenUtil isMobileWithPhone:_newsPassTextField.text withCode:_countryIcon]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.DetectsNotMatch"] showView:nil];
    }  else {
        self.lable.textColor = [UIColor lightGrayColor];
        NSDictionary *codeDic = @{@"new_phone":self.newsPassTextField.text,
                                  @"prefix":_countryCode};
        [[MCNetWorking sharedInstance] myPostWithUrlString:update_phone_sendURL withParameter:codeDic withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                self.yzmBut.enabled = NO;
                //开启计时器
                time = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timefireMethod) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
            } else {
                self.lable.textColor = blueRGB;
            }
        } withFailure:^(NSError *error) {
            NSLog(@"%@", error);
            self.lable.textColor = blueRGB;
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        }];
    }
}

//倒计时
- (void)timefireMethod
{
    self.lable.text = [NSString stringWithFormat:@"%d%@", myTime,[CommenUtil LocalizedString:@"Register.AfterSeconds"]];
    myTime--;
    if (myTime == 0) {
        self.yzmBut.enabled = YES;
        self.lable.text = [CommenUtil LocalizedString:@"Register.ClickToGet"];
        self.lable.textColor = blueRGB;
        [time invalidate];
        time = nil;
        myTime = 120;
    }
    NSLog(@"%d", myTime);
}

- (void)pushAction
{
    [self.navigationController pushViewController:[[MLSettingsPhoneViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
