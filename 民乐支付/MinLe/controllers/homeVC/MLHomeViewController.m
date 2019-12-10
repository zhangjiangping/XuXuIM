//
//  MLHomeViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLHomeNavigationView.h"
#import "MLLandingViewController.h"
#import "MLHomeTopview.h"
#import "MLHomeXiaView.h"
#import "MLHomeLeftView.h"
#import "MLNameAuthenticationViewController.h"
#import "MLValidationAuditsViewController.h"
#import "MLPeopleCertificationViewController.h"
#import "MLYHKCertificationViewController.h"
#import "HomeNewShowView.h"
#import "MLHomeViewController+Voip.h"

@interface MLHomeViewController ()
{
    BOOL isTransForm;
    NSNumber *statusNum;
}
@property (nonatomic, strong) MLHomeNavigationView *naView;
@property (nonatomic, strong) MLHomeTopview *topView;
@property (nonatomic, strong) MLHomeXiaView *xiaView;
@property (nonatomic, strong) MLHomeLeftView *leftView;
@property (nonatomic, strong) UIButton *imageBut;

@property (nonatomic, strong) HomeNewShowView *newView;//公告更新通知弹出视图

@end

@implementation MLHomeViewController

- (void)dealloc
{
    [self.xiaView.accountScrollView removeTimer];    
    [self homeDealloc];
    NSLog(@"MLHomeViewController界面释放成功");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.xiaView.accountScrollView start];
    [self moneyReuest];//金额总数接口
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.xiaView.accountScrollView pause];
    _leftView.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        [SharedApp setupRootViewController:[[MLLandingViewController alloc] init]];
    } else {
        [self loginVoip];
    }
}

- (void)setUI
{
    [self changebarWhiteStyle:YES];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.xiaView];
    [self.view addSubview:self.leftView];
    [self.view addSubview:self.newView];
}

//个人中心
- (void)onAction:(UIButton *)sender
{
    if (self.leftView.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.leftView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.leftView.alpha = 0;
        }];
    }
}

- (void)moneyReuest
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        [SharedApp.netWorking myPostWithUrlString:moneyURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                //弹窗部分
                if ([responseObject[@"alert"] isKindOfClass:[NSArray class]]) {
                    NSArray *alertArray = responseObject[@"alert"];
                    if (alertArray.count > 0) {
                        NSDictionary *newdic = alertArray[0];
                        [_newView updataView:newdic];
                    }
                }
                //公告部分
                if ([responseObject[@"notice"] isKindOfClass:[NSArray class]]) {
                    NSArray *alertArray = responseObject[@"notice"];
                    [_xiaView updataView:alertArray];
                }
                if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                    //积分部分
                    [self updataBalance:responseObject];
                    //金额部分
                    [self updataMoney:responseObject];
                    //新闻数量部分
                    [self updataNewMessage:responseObject];
                }
            } else {
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

//积分部分
- (void)updataBalance:(NSDictionary *)responseObject
{
    NSString *balanceStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"balance"]];
    if ([[CommenUtil sharedInstance] isNull:balanceStr]) {
        self.topView.integralLable.text = @"0";
    } else {
        self.topView.integralLable.text = balanceStr;
    }
}

//金额部分
- (void)updataMoney:(NSDictionary *)responseObject
{
    NSString *moneyStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"money"]];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"money"]) {
        [[NSUserDefaults standardUserDefaults] setObject:moneyStr forKey:@"money"];
    }
    CGFloat countFromMoney = [[[NSUserDefaults standardUserDefaults] objectForKey:@"money"] floatValue];
    CGFloat toMoney = [moneyStr floatValue];
    //设置变化范围及动画时间
    [self.topView.moneyLable countFrom:countFromMoney
                                    to:toMoney
                          withDuration:2.0f];
    [[NSUserDefaults standardUserDefaults] setObject:moneyStr forKey:@"money"];
}

//新闻数量部分
- (void)updataNewMessage:(NSDictionary *)responseObject
{
    NSNumber *allNumber = responseObject[@"data"][0][@"allNumber"];
    if ([allNumber isEqual:@0]) {
        if (isTransForm) {
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/180.0);
            [self.naView.img setTransform:transform];
        }
        self.naView.palyBut.frame = CGRectMake(widthss-55, 20, 44, 44);
        self.naView.allNumberLable.alpha = 0;
    } else {
        self.naView.allNumberLable.alpha = 1;
        self.naView.palyBut.frame = CGRectMake(widthss-55, 15, 44, 44);
        CGAffineTransform transform = CGAffineTransformMakeRotation(45.0 * M_PI/180.0);
        [self.naView.img setTransform:transform];
        isTransForm = YES;
        self.naView.allNumberLable.backgroundColor = [UIColor redColor];
        self.naView.allNumberLable.text = [NSString stringWithFormat:@"%@",allNumber];
    }
}


#pragma mark - getter

- (MLHomeLeftView *)leftView
{
    if (!_leftView) {
        _leftView = [[MLHomeLeftView alloc] initWithFrame:CGRectMake(8, 60, 135, 278)];
        _leftView.alpha = 0;
    }
    return _leftView;
}


- (MLHomeNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLHomeNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64)];
        [_naView.myBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naView;
}

- (MLHomeTopview *)topView
{
    if (!_topView) {
        _topView = [[MLHomeTopview alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss/3.51)];
    }
    return _topView;
}

- (MLHomeXiaView *)xiaView
{
    if (!_xiaView) {
        _xiaView = [[MLHomeXiaView alloc] initWithFrame:CGRectMake(0, heightss/3.51+64, widthss, heightss-heightss/3.51-64)];
    }
    return _xiaView;
}

- (HomeNewShowView *)newView
{
    if (!_newView) {
        _newView = [[HomeNewShowView alloc] initWithFrame:CGRectMake(0, -heightss, widthss, heightss)];
    }
    return _newView;
}

// 点击空白处隐藏弹出视图
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.leftView.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
