//
//  InternationalViewController.m
//  民乐支付
//
//  Created by JP on 2017/4/11.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "InternationalViewController.h"
#import "InternationalScrollView.h"
#import "NSString+MyString.h"
#import "InternationalWebViewController.h"

@interface InternationalViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) InternationalScrollView *interScrollView;
@property (nonatomic, strong) UIButton *but;
@end

@implementation InternationalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_interScrollView.moneyField becomeFirstResponder];
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.interScrollView];
    [self.view addSubview:self.but];
}

//点击确定
- (void)tureAction
{
    if (self.interScrollView.moneyField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.EnterNotEmpty"] showView:nil];
    } else if (![NSString isTwoPoint:self.interScrollView.moneyField.text]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.MoneyWrong"] showView:nil];
    } else if ([self.interScrollView.moneyField.text floatValue] - 0.009 < 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.EnterMoneyMsg"] showView:nil];
    } else {
        NSString *orderRef = [CommenUtil getOut_order_number];
        NSString *amount = self.interScrollView.moneyField.text;
        NSString *code = @"344";
        NSString *lang = @"X";
        NSString *merchantId = @"560212832";
        NSString *payMethod = @"CHINAPAY";
        NSString *payType = @"N";
        NSString *remark = @"民乐在线支付";
        remark = [remark stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *urlStr = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",jspURL,
                            @"orderRef",orderRef,
                            @"amount",amount,
                            @"currCode",code,
                            @"lang",lang,
                            @"merchantId",merchantId,
                            @"payMethod",payMethod,
                            @"payType",payType,
                            @"remark",remark];
        
        InternationalWebViewController *interWebVc = [[InternationalWebViewController alloc] init];
        interWebVc.urlStr = urlStr;
        [self.navigationController pushViewController:interWebVc animated:YES];
    }
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Me.InternationalCreditCard"]];
    }
    return _naView;
}

- (InternationalScrollView *)interScrollView
{
    if (!_interScrollView) {
        _interScrollView = [[InternationalScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64-50)];
    }
    return _interScrollView;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        [_but setTitle:[CommenUtil LocalizedString:@"Common.Ture"] forState:UIControlStateNormal];
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _but.backgroundColor = RGB(2, 138, 218);
        _but.titleLabel.font = FT(19);
        [_but addTarget:self action:@selector(tureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _but;
}



@end
