//
//  MLValidationAuditsViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/26.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLValidationAuditsViewController.h"
#import "MLMationAuthenticationViewController.h"
#import "MLNameAuthenticationViewController.h"
#import "MLPeopleCertificationViewController.h"
#import "MLYHKCertificationViewController.h"

#define successColor [ColorsUtil colorWithHexString:@"#22ac38"]
#define waitColor [ColorsUtil colorWithHexString:@"#77777a"]

@interface MLValidationAuditsViewController ()
{
    NSString *nameStr;
    NSString *peopleStr;
    NSString *yhkStr;
    BOOL isAuth;
}
@property (nonatomic, strong) MLMyNavigationView *naView;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *topLable;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *authStateView;

@property (nonatomic, strong) UIButton *tureBut;
@property (nonatomic, strong) UIView *authView;
@end

@implementation MLValidationAuditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    isAuth =  [self.statusStr isEqualToString:@"1"] ? YES : NO;
    [self.view addSubview:self.naView];
    [self.view addSubview:self.mainView];
    [self request];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Authen.AuthPrompt"]];
        _naView.but.alpha = 0;
        [_naView addSubview:self.tureBut];
    }
    return _naView;
}

- (UIButton *)tureBut
{
    if (!_tureBut) {
        _tureBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _tureBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-60, 14, 50, 50);
        [_tureBut setTitle:[CommenUtil LocalizedString:@"Common.Ture"] forState:UIControlStateNormal];
        [_tureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tureBut addTarget:self action:@selector(tureAction) forControlEvents:UIControlEventTouchUpInside];
        _tureBut.titleLabel.font = FT(17);
    }
    return _tureBut;
}

- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64)];
        _mainView.backgroundColor = [ColorsUtil colorWithHexString:@"#efeff4"];
        [_mainView addSubview:self.topImageView];
        [_mainView addSubview:self.topLable];
        [_mainView addSubview:self.avatarImageView];
        [_mainView addSubview:self.authStateView];
    }
    return _mainView;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        float imageHeight = (screenHeight > 568.0f) ? 200 : 130;
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthss, imageHeight)];
        _topImageView.image = [UIImage imageNamed:@"dengdairenzheng_02"];
        _topImageView.clipsToBounds = YES;
    }
    return _topImageView;
}

- (UILabel *)topLable
{
    if (!_topLable) {
        NSString *stateStr = isAuth ? [CommenUtil LocalizedString:@"Authen.ValidationSuccessMsg"] : [CommenUtil LocalizedString:@"Authen.ValidationWaitingMsg"];
        _topLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mainView.frame), 100)];
        _topLable.text = stateStr;
        _topLable.font = [UIFont systemFontOfSize:18];
        _topLable.textAlignment = NSTextAlignmentCenter;
        _topLable.numberOfLines = 2;
    }
    return _topLable;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_mainView.frame)-113)/2.f, CGRectGetMaxY(_topImageView.frame)-113/2.f, 113, 113)];
        _avatarImageView.image = isAuth ? [UIImage imageNamed:@"ico_photo_success"] : [UIImage imageNamed:@"ico_photo_wait"];
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UIView *)authStateView
{
    if (!_authStateView) {
        float hh = 35;
        float leftPadd = 15;
        UIFont *authStateFont = [UIFont systemFontOfSize:16];
        _authStateView = [[UIView alloc] initWithFrame:CGRectMake(leftPadd, CGRectGetMaxY(_avatarImageView.frame)+25, CGRectGetWidth(_mainView.frame)-leftPadd*2, hh)];
        NSArray *arr = @[[CommenUtil LocalizedString:@"Authen.ValidationSubmit"],
                         [CommenUtil LocalizedString:@"Authen.ValidationWait"],
                         [CommenUtil LocalizedString:@"Authen.ValidationSuccess"]];
        float oneWidth = [CommenUtil getWidthWithContent:arr[0] withHeight:hh withFont:authStateFont] + hh/2.f;
        float twoWidth = [CommenUtil getWidthWithContent:arr[1] withHeight:hh withFont:authStateFont] + hh/2.f;
        float threeWidth = [CommenUtil getWidthWithContent:arr[2] withHeight:hh withFont:authStateFont] + hh/2.f;
        NSArray *widthArr = @[@(oneWidth),@(twoWidth),@(threeWidth)];
        float padding = (CGRectGetWidth(_authStateView.frame)-oneWidth-twoWidth-threeWidth)/2.f;
        float beginX = 0;
        
        for (int i = 0; i < arr.count; i++) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            float currentWidth = [widthArr[i] floatValue];
            but.frame = CGRectMake(beginX, 0, currentWidth, hh);
            [but setTitle:arr[i] forState:UIControlStateNormal];
            but.titleLabel.font = authStateFont;
            but.layer.cornerRadius = hh/2.f;
            but.layer.borderWidth = 1;
            [_authStateView addSubview:but];
            
            beginX = CGRectGetMaxX(but.frame)+padding;
            
            if (i < 2) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(but.frame), (hh-1)/2.f, padding, 1)];
                if (isAuth) {
                    lineView.backgroundColor = successColor;
                } else {
                    lineView.backgroundColor = (i == 0) ? successColor : waitColor;
                }
                [_authStateView addSubview:lineView];
            }
            
            if (isAuth) {
                but.layer.borderColor = successColor.CGColor;
                [but setTitleColor:successColor forState:UIControlStateNormal];
            } else {
                if (i > 1) {
                    but.layer.borderColor = waitColor.CGColor;
                    [but setTitleColor:waitColor forState:UIControlStateNormal];
                } else {
                    but.layer.borderColor = successColor.CGColor;
                    [but setTitleColor:successColor forState:UIControlStateNormal];
                }
            }
        }
    }
    return _authStateView;
}

- (void)request
//payapi.php/Home/Api/check_actauthen
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:authen_statusURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"info_status"] isEqual:@1]) {
            NSArray *arr = responseObject[@"data"];
            if (arr.count) {
                nameStr = responseObject[@"data"][0][@"status"];
                peopleStr = responseObject[@"data"][1][@"status"];
                yhkStr = responseObject[@"data"][2][@"status"];
                
                if (_authView) {
                    [_authView removeFromSuperview];
                    _authView = nil;
                }
                [self addAuthViews];
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@", error);
    }];
}

- (void)addAuthViews
{
    //BOOL one = ([nameStr isEqualToString:@"1"] && [peopleStr isEqualToString:@"1"] && [yhkStr isEqualToString:@"1"]);
    //BOOL two = ([nameStr isEqualToString:@"0"] && [peopleStr isEqualToString:@"0"] && [yhkStr isEqualToString:@"0"]);
    BOOL isAuth = (([nameStr isEqualToString:@"0"] || [nameStr isEqualToString:@"1"]) &&
                  ([peopleStr isEqualToString:@"0"] || [peopleStr isEqualToString:@"1"]) &&
                  ([yhkStr isEqualToString:@"0"] || [yhkStr isEqualToString:@"1"]));
    if (!isAuth) {
        
        if (screenHeight > 568.0f) {
            _authView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_authStateView.frame)+65, screenWidth, screenHeight-(CGRectGetMaxY(_authStateView.frame)+45))];
        } else {
            _authView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_authStateView.frame)+25, screenWidth, screenHeight-(CGRectGetMaxY(_authStateView.frame)+20))];
        }
        
        NSString *messageStr = [CommenUtil LocalizedString:@"Authen.ContinueAuthMsg"];
        CGFloat messageWidth = [CommenUtil getWidthWithContent:messageStr height:20 font:14];
        
        UILabel *messageLable = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-messageWidth)/2, 0, messageWidth, 20)];
        messageLable.text = messageStr;
        messageLable.font = FT(14);
        messageLable.textAlignment = NSTextAlignmentCenter;
        [_authView addSubview:messageLable];
        
        CGFloat lineWidth = (CGRectGetWidth(_authView.frame)-15*4-messageWidth)/2;
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, (20-0.5)/2, lineWidth, 0.5)];
        lineView1.backgroundColor = [ColorsUtil colorWithHexString:@"#d3d3d3"];
        [_authView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15+CGRectGetMaxX(messageLable.frame), (20-0.5)/2, lineWidth, 0.5)];
        lineView2.backgroundColor = [ColorsUtil colorWithHexString:@"#d3d3d3"];
        [_authView addSubview:lineView2];
        
        UIButton *nameBut;
        UIButton *peopleBut;
        UIButton *yhkBut;
        if ([self.status isEqualToString:@"1"]) {
            //代表实名认证
            if ([peopleStr isEqualToString:@"2"] || [peopleStr isEqualToString:@"3"]) {
                peopleBut = [self getBut:[CommenUtil LocalizedString:@"Authen.Qualification"] withY:CGRectGetMaxY(messageLable.frame)+30];
                [_authView addSubview:peopleBut];
            }
            if ([yhkStr isEqualToString:@"2"] || [yhkStr isEqualToString:@"3"]) {
                CGFloat y;
                if (peopleBut) {
                    y = CGRectGetMaxY(peopleBut.frame)+20;
                } else {
                    y = CGRectGetMaxY(messageLable.frame)+30;
                }
                yhkBut = [self getBut:[CommenUtil LocalizedString:@"Authen.Bank"] withY:y];
                [_authView addSubview:yhkBut];
            }
            
        } else if ([self.status isEqualToString:@"2"]) {
            //代表资质认证
            if ([nameStr isEqualToString:@"2"] || [nameStr isEqualToString:@"3"]) {
                nameBut = [self getBut:[CommenUtil LocalizedString:@"Authen.Name"] withY:CGRectGetMaxY(messageLable.frame)+30];
                [_authView addSubview:nameBut];
            }
            if ([yhkStr isEqualToString:@"2"] || [yhkStr isEqualToString:@"3"]) {
                CGFloat y;
                if (nameBut) {
                    y = CGRectGetMaxY(nameBut.frame)+20;
                } else {
                    y = CGRectGetMaxY(messageLable.frame)+30;
                }
                yhkBut = [self getBut:[CommenUtil LocalizedString:@"Authen.Bank"] withY:y];
                [_authView addSubview:yhkBut];
            }
        } else if ([self.status isEqualToString:@"3"]) {
            //代表银行卡认证
            if ([nameStr isEqualToString:@"2"] || [nameStr isEqualToString:@"3"]) {
                nameBut = [self getBut:[CommenUtil LocalizedString:@"Authen.Name"] withY:CGRectGetMaxY(messageLable.frame)+30];
                [_authView addSubview:nameBut];
            }
            if ([peopleStr isEqualToString:@"2"] || [peopleStr isEqualToString:@"3"]) {
                CGFloat y;
                if (nameBut) {
                    y = CGRectGetMaxY(nameBut.frame)+20;
                } else {
                    y = CGRectGetMaxY(messageLable.frame)+30;
                }
                peopleBut = [self getBut:[CommenUtil LocalizedString:@"Authen.Qualification"] withY:y];
                [_authView addSubview:peopleBut];
            }
        }
        if (nameBut) {
            [nameBut addTarget:self action:@selector(nameAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (peopleBut) {
            [peopleBut addTarget:self action:@selector(peopleAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (yhkBut) {
            [yhkBut addTarget:self action:@selector(yhkAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_mainView addSubview:_authView];
    }
}

- (void)nameAction:(UIButton *)sender
{
    MLNameAuthenticationViewController *nameVC = [[MLNameAuthenticationViewController alloc] init];
    [self.navigationController pushViewController:nameVC animated:YES];
}

- (void)peopleAction:(UIButton *)sender
{
    MLPeopleCertificationViewController *peopleVC = [[MLPeopleCertificationViewController alloc] init];
    [self.navigationController pushViewController:peopleVC animated:YES];
}

- (void)yhkAction:(UIButton *)sender
{
    MLYHKCertificationViewController *yhkVC = [[MLYHKCertificationViewController alloc] init];
    [self.navigationController pushViewController:yhkVC animated:YES];
}

- (UIButton *)getBut:(NSString *)title withY:(CGFloat)y;
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(30, y, screenWidth-60, 40);
    but.layer.cornerRadius = 20;
    but.backgroundColor = blueRGB;
    [but setTitle:title forState:UIControlStateNormal];
    return but;
}

- (void)tureAction
{
    if ([self.isPopRoot isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if ([self.isPopRoot isEqualToString:@"0"]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MLMationAuthenticationViewController class]]) {
                //发出返回刷新的广播
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MationLoad" object:nil];
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
