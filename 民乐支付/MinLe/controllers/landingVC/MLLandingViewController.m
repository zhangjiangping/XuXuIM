//
//  MLLandingViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLLandingViewController.h"
#import "BaseNavigationController.h"
#import "MLRegisterViewController.h"
#import "MLHomeViewController.h"
#import "MLForgetPSViewController.h"
#import "VETCountryViewController.h"
#import "NSString+MyString.h"
#import "MLMinLeTextField.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "UIAlertView+WX.h"
#import "WeiXinBinding.h"
#import "WXApi.h"

@interface MLLandingViewController () <UITextFieldDelegate,WXApiManagerDelegate,BindingDelegate>
{
    MBProgressHUD *hud;
    BOOL isWeiXinLogin;//是否是用微信第三方登录
}
@property (nonatomic, strong) MLMinLeTextField *phoneTextField;
@property (nonatomic, strong) MLMinLeTextField *passWordTextField;
@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UIImageView *phoneImg;
@property (nonatomic, strong) UIView *passView;
@property (nonatomic, strong) UIImageView *passImg;
@property (nonatomic, strong) UIButton *countryBut;
@property (nonatomic, strong) UIImageView *countryRightImg;
@property (nonatomic, strong) UILabel *countryLable;

@property (nonatomic, strong) UIButton *passBut;
@property (nonatomic, strong) UIButton *landingBut;
@property (nonatomic, strong) UIButton *regisBut;

@property (nonatomic, strong) UILabel *copyrightlable;

@property (nonatomic, strong) UIView *threeView;//第三方登录视图
@property (nonatomic, strong) UIButton *wechatButton;//微信第三方登录按钮

@property (nonatomic, strong) WeiXinBinding *bindingView;//是否绑定界面

@property (nonatomic, strong) NSString *countryName;//国家名字
@property (nonatomic, strong) NSString *countryCode;//国家区号
@property (nonatomic, strong) NSString *countryIcon;//国家code
@property (nonatomic, strong) VETCountry *currentCountry;

@end

@implementation MLLandingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.phoneTextField.text.length == 0 && self.passWordTextField.text.length == 0) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]) {
            
        } else {
            self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        }
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"pass"]) {
            
        } else {
            self.passWordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pass"];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [hud hide:YES];
    [self hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //更改状态栏颜色
    [self changebarWhiteStyle:NO];
    //设置微信授权登录代理
    [WXApiManager sharedManager].delegate = self;
}

//UI显示
- (void)setUI
{
    if (!SharedApp.currentCountry) {
        [SharedApp setupDefaultAccount];
    }
    _currentCountry = SharedApp.currentCountry;
    _countryName = SharedApp.currentCountry.countryChineseName;
    _countryCode = SharedApp.currentCountry.code;
    _countryIcon = SharedApp.currentCountry.icon;
    
    [self.view addSubview:self.img];
    [self.view addSubview:self.countryBut];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.passView];
    [self.view addSubview:self.passBut];
    [self.view addSubview:self.landingBut];
    [self.view addSubview:self.regisBut];
    [self.view addSubview:self.copyrightlable];
    
    if ([WXApi isWXAppInstalled]) {
        _regisBut.titleLabel.font = FT(15);
        _regisBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _regisBut.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _regisBut.frame = CGRectMake(30, CGRectGetMaxY(self.passView.frame)+5, 100, 25);
        } else {
            _regisBut.frame = CGRectMake(30, CGRectGetMaxY(self.passView.frame)+15, 100, 30);
        }
        [self.view addSubview:self.threeView];
    } else {
        _regisBut.titleLabel.font = FT(20);
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _regisBut.frame = CGRectMake((screenWidth-100)/2, CGRectGetMaxY(self.landingBut.frame)+20, 100, 20);
        } else {
            _regisBut.frame = CGRectMake((screenWidth-100)/2, CGRectGetMaxY(self.landingBut.frame)+50, 100, 20);
        }
    }
    if (SharedApp.isLandingFailure) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.ReconnectMsg"] showView:nil];
        SharedApp.isLandingFailure = NO;
    }
}

#pragma mark - 懒加载

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] init];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _img.frame = CGRectMake((widthss-248)/2, 50, 248, 71);
        } else {
            _img.frame = CGRectMake((widthss-248)/2, 80, 248, 71);
        }
        _img.image = [UIImage imageNamed:@"logo"];
        _img.clipsToBounds = YES;
    }
    return _img;
}

- (UIButton *)countryBut
{
    if (!_countryBut) {
        _countryBut = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _countryBut.frame = CGRectMake(30, CGRectGetMaxY(self.img.frame)+20, widthss-60, 40);
        } else {
            _countryBut.frame = CGRectMake(30, CGRectGetMaxY(self.img.frame)+40, widthss-60, 44);
        }
        _countryBut.layer.borderWidth = 0.5;
        _countryBut.layer.borderColor = LayerRGB(0, 134, 219);
        _countryBut.layer.cornerRadius = 5;
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
        _countryLable.text = [NSString stringWithFormat:@"%@ (+%@)",_countryName,_countryCode];
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

- (UIView *)phoneView
{
    if (!_phoneView) {
        _phoneView = [[UIView alloc] init];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _phoneView.frame = CGRectMake(30, CGRectGetMaxY(self.countryBut.frame)+10, widthss-60, 40);
        } else {
            _phoneView.frame = CGRectMake(30, CGRectGetMaxY(self.countryBut.frame)+20, widthss-60, 44);
        }
        _phoneView.layer.borderWidth = 0.5;
        _phoneView.layer.borderColor = LayerRGB(0, 134, 219);
        _phoneView.layer.cornerRadius = 5;
        [_phoneView addSubview:self.phoneImg];
        [_phoneView addSubview:self.phoneTextField];
    }
    return _phoneView;
}

- (UIImageView *)phoneImg
{
    if (!_phoneImg) {
        _phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CGRectGetHeight(self.phoneView.frame)-30)/2, 30, 30)];
        _phoneImg.image = [UIImage imageNamed:@"denglu_03"];
    }
    return _phoneImg;
}

- (MLMinLeTextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.phoneImg.frame)+5, (CGRectGetHeight(self.phoneView.frame)-30)/2, CGRectGetWidth(self.phoneView.frame)-70, 30)];
        _phoneTextField.backgroundColor = [UIColor clearColor];
        _phoneTextField.placeholder = [CommenUtil LocalizedString:@"Login.PhoneNumber"];
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;//数字带小数点键盘
    }
    return _phoneTextField;
}

- (UIView *)passView
{
    if (!_passView) {
        _passView = [[UIView alloc] init];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _passView.frame = CGRectMake(30, CGRectGetMaxY(self.phoneView.frame)+10, widthss-60, 40);
        } else {
            _passView.frame = CGRectMake(30, CGRectGetMaxY(self.phoneView.frame)+20, widthss-60, 44);
        }
        _passView.layer.borderWidth = 0.5;
        _passView.layer.borderColor = LayerRGB(0, 134, 219);
        _passView.layer.cornerRadius = 5;
        [_passView addSubview:self.passImg];
        [_passView addSubview:self.passWordTextField];
    }
    return _passView;
}

- (UIImageView *)passImg
{
    if (!_passImg) {
        _passImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CGRectGetHeight(self.passView.frame)-30)/2, 30, 30)];
        _passImg.image = [UIImage imageNamed:@"denglu_07"];
    }
    return _passImg;
}

- (MLMinLeTextField *)passWordTextField
{
    if (!_passWordTextField) {
        _passWordTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.passImg.frame)+5, (CGRectGetHeight(self.passView.frame)-30)/2, CGRectGetWidth(self.passView.frame)-70, 30)];
        _passWordTextField.placeholder = [CommenUtil LocalizedString:@"Login.Password"];
        _passWordTextField.backgroundColor = [UIColor clearColor];
        _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        _passWordTextField.secureTextEntry = YES;//密码形式
        _passWordTextField.delegate = self;
    }
    return _passWordTextField;
}

- (UIButton *)passBut
{
    if (!_passBut) {
        _passBut = [UIButton buttonWithType:UIButtonTypeSystem];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _passBut.frame = CGRectMake(widthss-130, CGRectGetMaxY(self.passView.frame)+5, 100, 25);
        } else {
            _passBut.frame = CGRectMake(widthss-130, CGRectGetMaxY(self.passView.frame)+15, 100, 30);
        }
        [_passBut setTitle:[CommenUtil LocalizedString:@"Login.ForgetPassword"] forState:UIControlStateNormal];
        [_passBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _passBut.titleLabel.font = FT(15);
        _passBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _passBut.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        [_passBut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passBut;
}

- (UIButton *)regisBut
{
    if (!_regisBut) {
        _regisBut = [UIButton buttonWithType:UIButtonTypeSystem];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _regisBut.frame = CGRectMake(30, CGRectGetMaxY(self.passView.frame)+5, 100, 25);
        } else {
            _regisBut.frame = CGRectMake(30, CGRectGetMaxY(self.passView.frame)+15, 100, 30);
        }
        
        [_regisBut setTitle:[CommenUtil LocalizedString:@"Login.PleaseRegister"] forState:UIControlStateNormal];
        UIColor *color = RGB(42, 176, 91);
        [_regisBut setTitleColor:color forState:UIControlStateNormal];
        [_regisBut addTarget:self action:@selector(pushRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _regisBut;
}

- (UIButton *)landingBut
{
    if (!_landingBut) {
        _landingBut = [UIButton buttonWithType:UIButtonTypeSystem];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _landingBut.frame = CGRectMake(30, CGRectGetMaxY(self.passBut.frame)+10, widthss-60, 40);
        } else {
            _landingBut.frame = CGRectMake(30, CGRectGetMaxY(self.passBut.frame)+10, widthss-60, 44);
        }
        [_landingBut setTitle:[CommenUtil LocalizedString:@"Login"] forState:UIControlStateNormal];
        [_landingBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _landingBut.titleLabel.font = FT(20);
        _landingBut.layer.cornerRadius = 5;
        _landingBut.backgroundColor = RGB(2, 145, 255);
        [_landingBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _landingBut;
}

- (UIView *)threeView
{
    if (!_threeView) {
        float ww = CGRectGetWidth(self.landingBut.frame);
        float msgWidth = [CommenUtil getWidthWithContent:[CommenUtil LocalizedString:@"Login.LogInUsingAThirdParty"] height:30 font:14];
        float lineWidth = (ww-msgWidth-5*2)/2;
        float lineY = (30-0.5)/2;
        _threeView = [[UIView alloc] init];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _threeView.frame = CGRectMake(30, CGRectGetMaxY(self.landingBut.frame)+10, ww, 110);
        } else {
            _threeView.frame = CGRectMake(30, CGRectGetMaxY(self.landingBut.frame)+20, ww, 110);
        }
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, lineWidth, 0.5)];
        lineView1.backgroundColor = [UIColor lightGrayColor];
        lineView1.alpha = 0.4;
        [_threeView addSubview:lineView1];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame)+5, 0, msgWidth, 30)];
        lable.text = [CommenUtil LocalizedString:@"Login.LogInUsingAThirdParty"];
        lable.textColor = [UIColor lightGrayColor];
        lable.alpha = 0.7;
        lable.font = FT(14);
        lable.textAlignment = NSTextAlignmentCenter;
        [_threeView addSubview:lable];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame)+5, lineY, lineWidth, 0.5)];
        lineView2.backgroundColor = [UIColor lightGrayColor];
        lineView2.alpha = 0.4;
        [_threeView addSubview:lineView2];
        
        _wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _wechatButton.frame = CGRectMake((ww-40)/2, CGRectGetMaxY(lable.frame), 40, 40);
            _wechatButton.layer.cornerRadius = 20;
        } else {
            _wechatButton.frame = CGRectMake((ww-50)/2, CGRectGetMaxY(lable.frame)+30, 50, 50);
            _wechatButton.layer.cornerRadius = 25;
        }
        [_wechatButton setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [_wechatButton addTarget:self action:@selector(weChatLogin:) forControlEvents:UIControlEventTouchUpInside];
        [_threeView addSubview:_wechatButton];
    }
    return _threeView;
}

- (UILabel *)copyrightlable
{
    if (!_copyrightlable) {
        float hh = [CommenUtil getTxtHeight:[CommenUtil LocalizedString:@"Setting.MinleCopyright"] forContentWidth:screenWidth-60 fotFontSize:14];
        _copyrightlable = [[UILabel alloc] initWithFrame:CGRectMake(30, screenHeight-hh-10, screenWidth-60, hh)];
        _copyrightlable.font = FT(14);
        _copyrightlable.text = [CommenUtil LocalizedString:@"Setting.MinleCopyright"];
        _copyrightlable.textAlignment = NSTextAlignmentCenter;
        _copyrightlable.textColor = [UIColor lightGrayColor];
    }
    return _copyrightlable;
}

- (void)addBindingViewWithDic:(NSDictionary *)dic
{
    _bindingView = [[WeiXinBinding alloc] initWithFrame:self.view.bounds withDic:dic];
    _bindingView.alpha = 0;
    _bindingView.delegate = self;
    [UIView animateWithDuration:0.3 animations:^{
        _bindingView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.view addSubview:_bindingView];
    }];
}

#pragma mark - BindingDelegate

- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^{
        self.bindingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bindingView removeFromSuperview];
        self.bindingView = nil;
    }];
}

//点击民乐账号按钮
- (void)bindingLogin
{
    [self hide];
    
    _phoneTextField.text = @"";
    _passWordTextField.text = @"";
    [_landingBut setTitle:[CommenUtil LocalizedString:@"Login.BindingAccount"] forState:UIControlStateNormal];
    _passBut.hidden = YES;
    _threeView.hidden = YES;
    _regisBut.frame = CGRectMake((widthss-100)/2, CGRectGetMaxY(self.landingBut.frame)+50, 100, 20);
    _regisBut.titleLabel.font = FT(18);
    _regisBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _regisBut.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - WXApiManagerDelegate

//登录授权回调
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response
{
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    NSLog(@"回调数据：%@", strMsg);
    
    if (response.code && response.state) {
        hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"Login..."] showView:nil];
        [[WXApiManager sharedManager] getOpenID:response];
    }
}

//获取openID成功回调
- (void)managerDidReciveOpenID:(NSString *)openId withIsSuccess:(BOOL)isSuccess
{
    NSLog(@"openId:%@",openId);
    if (isSuccess) {
        //获取手机型号
        NSString *phoneStr = [NSString iphoneType];
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        NSDictionary *dic = @{@"openid":openId,@"type":@"2",@"phone_type":phoneStr,@"deviceID":identifierForVendor};
        [SharedApp.netWorking myPostWithUrlString:detectionOpenIDURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                [hud hide:YES];
                [self pushHomeViewController:responseObject];
            } else if ([responseObject[@"status"] isEqual:@2]) {
                [[WXApiManager sharedManager] wechatLoginByRequestForUserInfoWithAccessToken:nil withOpenID:openId];
            } else {
                [hud hide:YES];
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [hud hide:YES];
            [UIAlertView showWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Login.ServerErrorMsg"] sure:nil];
            NSLog(@"%@",error);
        }];
    } else {
        [hud hide:YES];
        [UIAlertView showWithTitle:@"Common.Prompt" message:[CommenUtil LocalizedString:@"Login.LoginErrorMsg"] sure:nil];
    }
}

//获取个人信息成功回调
- (void)managerDidReciveInfo:(NSDictionary *)dic withIsSuccess:(BOOL)isSuccess
{
    [hud hide:YES];
    
    if (isSuccess) {
        //记录使用微信第三登录成功
        isWeiXinLogin = YES;
        //添加绑定弹出框视图
        [self addBindingViewWithDic:dic];
    } else {
        if (dic) {
            [UIAlertView showWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Login.LoginErrorMsg"] sure:nil];
        } else {
            [UIAlertView showWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Login.ServerErrorMsg"] sure:nil];
        }
    }
}


#pragma mark - button action

//微信登录
- (void)weChatLogin:(UIButton *)sender
{
    [WXApiRequestHandler wechatLoginInViewController:self];
}

//忘记密码
- (void)pushAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[[MLForgetPSViewController alloc] init] animated:YES];
}

//登录
- (void)onAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (_phoneTextField.text.length == 0 || _passWordTextField.text.length == 0) {
        [[MBProgressHUD shareManager] ShowMessage:[CommenUtil LocalizedString:@"Login.AccountAndPasswordNotEmpty"] showView:nil];
    } else if (![NSString isMobile:_phoneTextField.text] && [_countryCode isEqualToString:@"86"]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.PhoneFormatNotCorrect"] showView:nil];
    } else if (![CommenUtil isMobileWithPhone:_phoneTextField.text withCode:_countryIcon]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Login.DetectsNotMatch"] showView:nil];
    } else {
        NSString *phoneStr = [NSString iphoneType];//获取手机型号
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        NSMutableDictionary *dic = [@{@"phone":_phoneTextField.text,
                                      @"password":_passWordTextField.text,
                                      @"type":@"2",
                                      @"prefix":_countryCode,
                                      @"phone_type":phoneStr,
                                      @"deviceID":identifierForVendor} mutableCopy];
        if (isWeiXinLogin) {
            NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
            [dic setObject:openId forKey:WX_OPEN_ID];
        }
        NSLog(@"%@",dic);
        [[MCNetWorking sharedInstance] createPostWithUrlString:LandingURL withParameter:dic withComplection:^(id responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                SharedApp.currentCountry = _currentCountry;
                [[VETUserManager sharedInstance] settingCountry:_currentCountry];
                [self pushHomeViewController:responseObject];
            } else {
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

//跳转首页公用方法
- (void)pushHomeViewController:(NSDictionary *)responseObject
{
    //登录成功将token、用户名、用户id保存在本地
    if (responseObject &&
        [responseObject isKindOfClass:[NSDictionary class]] &&
        [responseObject[@"data"] count] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:_passWordTextField.text forKey:@"pass"];
        [self saveInformationUserDefaults:responseObject withIsLogin:YES];
    }
    MLHomeViewController *homeVC = [[MLHomeViewController alloc] init];
    [SharedApp setupRootViewController:homeVC];
}

//密码形式的时候点击return取消键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _passWordTextField || textField == _phoneTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

//注册
- (void)pushRegister:(UIButton *)sender
{
    MLRegisterViewController *registerVc = [[MLRegisterViewController alloc] init];
    if (isWeiXinLogin) {
        registerVc.openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    }
    [self.navigationController pushViewController:registerVc animated:YES];
}

//选择国家
- (void)tapCountryButton:(UIButton *)sender
{
    VETCountryViewController *countryVC = [VETCountryViewController new];
    countryVC.countryBlock = ^(VETCountry *country) {
        _currentCountry = country;
        _countryName = country.countryChineseName;
        _countryCode = country.code;
        _countryIcon = country.icon;
        _countryLable.text = [NSString stringWithFormat:@"%@ (+%@)",_countryName,_countryCode];
    };
    [self.navigationController pushViewController:countryVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
