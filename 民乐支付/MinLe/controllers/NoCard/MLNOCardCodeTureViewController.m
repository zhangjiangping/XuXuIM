//
//  MLNOCardCodeTureViewController.m
//  minlePay
//
//  Created by JP on 2017/11/9.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLNOCardCodeTureViewController.h"
#import "MLNoCardCodeView.h"
#import "MLNOCardViewController.h"

#define timeMaxCount 5

@interface MLNOCardCodeTureViewController ()
{
    NSTimer *time;
    int myTime;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *but;//确认按钮

@property (nonatomic, strong) UIScrollView *noCardSrcollView;
@property (nonatomic, strong) MLNoCardCodeView *codeView;
@property (nonatomic, strong) NSString *myOrder;//订单号

@end

@implementation MLNOCardCodeTureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clearTimerAction];
}

- (void)setUI
{
    myTime = timeMaxCount;
    _myOrder = self.orderStr;
    [self.view addSubview:self.naView];
    [self.view addSubview:self.noCardSrcollView];
    [self.view addSubview:self.but];
    //显示数据
    [self setCurrentData];
    //添加计时器
    [self addTimer];
}

- (void)setCurrentData
{
    self.codeView.phoneNumberTextField.text = self.dataDic[@"mobile"];
    self.codeView.haomaTextField.text = self.dataDic[@"id_card"];
    self.codeView.cardNameTextField.text = self.dataDic[@"bank_user_name"];
    self.codeView.settlementBorrowTextField.text = self.dataDic[@"bank"];
    self.codeView.orderTradingMoneyTextField.text = self.dataDic[@"money"];
}

#pragma mark - Timer

//开启计时器
- (void)addTimer
{
    if (time) [self clearTimerAction];
    self.codeView.smsCodeBut.enabled = NO;
    self.codeView.smsCodeLable.text = [NSString stringWithFormat:@"%d%@",timeMaxCount,[CommenUtil LocalizedString:@"Register.AfterSeconds"]];
    self.codeView.smsCodeLable.textColor = [UIColor lightGrayColor];
    time = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timefireMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
}

//倒计时
- (void)timefireMethod
{
    myTime--;
    self.codeView.smsCodeLable.text = [NSString stringWithFormat:@"%d%@", myTime,[CommenUtil LocalizedString:@"Register.AfterSeconds"]];
    if (myTime == 0) {
        [self clearTimerAction];
    }
}

//计时器重置
- (void)clearTimerAction
{
    [time invalidate];
    time = nil;
    myTime = timeMaxCount;
    self.codeView.smsCodeBut.enabled = YES;
    self.codeView.smsCodeLable.text = [CommenUtil LocalizedString:@"Register.ClickToGet"];
    self.codeView.smsCodeLable.textColor = [UIColor whiteColor];
}

#pragma mark - Action

//点击重新获取
- (void)codeAction
{
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                          @"type":@"2",
                          @"order_num":_myOrder};
    [SharedApp.netWorking createPostWithLoading:[CommenUtil LocalizedString:@"TextSend..."] withUrlString:cardPayURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            //更新订单号
            _myOrder = responseObject[@"msg"];
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"NoCard.SMSSendSuccess"] showView:nil];
            [self addTimer];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//点击确认
- (void)pushAction:(UIButton *)sender
{
    if (self.codeView.smsCodeTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"NoCard.ReciveInpudCode"] showView:nil];
        [self.codeView.smsCodeTextField becomeFirstResponder];
    } else {
        NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                              @"code":self.codeView.smsCodeTextField.text,
                              @"order_num":_myOrder};
        [SharedApp.netWorking myPostWithUrlString:cardPayConfirmURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"NoCard.PaySuccess"] showView:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - getter

- (UIScrollView *)noCardSrcollView
{
    if (!_noCardSrcollView) {
        _noCardSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64-50)];
        _noCardSrcollView.contentSize = CGSizeMake(0, 600);
        _noCardSrcollView.showsVerticalScrollIndicator = NO;
        _noCardSrcollView.showsHorizontalScrollIndicator = NO;
        [_noCardSrcollView addSubview:self.codeView];
    }
    return _noCardSrcollView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"NoCard.TurePay"]];
    }
    return _naView;
}

- (MLNoCardCodeView *)codeView
{
    if (!_codeView) {
        _codeView = [[MLNoCardCodeView alloc] initWithFrame:CGRectMake(15, 0, widthss-30, 560)];
        [_codeView.smsCodeBut addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeView;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        _but.backgroundColor = RGB(2, 138, 218);
        [_but setTitle:[CommenUtil LocalizedString:@"Common.Confirm"] forState:UIControlStateNormal];
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_but addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but.titleLabel.font = FT(20);
    }
    return _but;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
