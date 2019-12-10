//
//  MLQrDetailViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLQrDetailViewController.h"
#import "BaseLayerView.h"
#import "MLCollectionViewController.h"
#import "MLSpeechSynthesizer.h"

@interface MLQrDetailViewController ()
{
    MLSpeechSynthesizer *speech;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *tureBut;
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *lable1;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UILabel *lable3;
@property (nonatomic, strong) UILabel *lable4;
@property (nonatomic, strong) UILabel *lable5;
@property (nonatomic, strong) UILabel *lable6;
@property (nonatomic, strong) UILabel *lable7;
@property (nonatomic, strong) UILabel *lable8;
@property (nonatomic, strong) UIView *xianView1;
@property (nonatomic, strong) UIView *xianView2;
@end

@implementation MLQrDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [speech clearSpeech];
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.layerView];
    if (_isSaomiao) {
        [self setLableTextWithDic:self.detailDataDic];
    } else {
        [self request];
    }
    //播放收到款项的声音
    speech = [[MLSpeechSynthesizer alloc] initWithText:[NSString stringWithFormat:@"%@%@%@",[CommenUtil LocalizedString:@"Collection.Received"],self.money,[CommenUtil LocalizedString:@"Common.Yuan"]]];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Collection.PaymentDetails"]];
        _naView.backgroundColor = RGB(0, 193, 91);
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
        [_tureBut setTitle:[CommenUtil LocalizedString:@"Common.Done"] forState:UIControlStateNormal];
        [_tureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tureBut addTarget:self action:@selector(tureAction) forControlEvents:UIControlEventTouchUpInside];
        _tureBut.titleLabel.font = FT(17);
    }
    return _tureBut;
}

- (void)request
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:order_detailURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"order_num":self.order_num} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            [self setLableTextWithDic:responseObject[@"data"][0]];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

- (void)setLableTextWithDic:(NSDictionary *)dic
{
    self.lable1.text = [NSString stringWithFormat:@"%@：  %@", [CommenUtil LocalizedString:@"Collection.MerchantCode"],dic[@"number"]];
    self.lable2.text = [NSString stringWithFormat:@"%@：  %@", [CommenUtil LocalizedString:@"Collection.OrderCode"],dic[@"order_num"]];
    self.lable3.text = [NSString stringWithFormat:@"%@：  %@", [CommenUtil LocalizedString:@"Collection.TradingHours"],dic[@"create_time"]];
    NSString *type = [NSString stringWithFormat:@"%@",dic[@"pay_method"]];
    if ([type isEqualToString:@"API_ZFBQRCODE"] || [type isEqualToString:@"02"]) {
        self.lable4.text = [NSString stringWithFormat:@"%@：  %@",[CommenUtil LocalizedString:@"Collection.MethodPayment"],[CommenUtil LocalizedString:@"Collection.ZFBPay"]];
    } else if ([type isEqualToString:@"API_WXQRCODE"] || [type isEqualToString:@"01"]) {
        self.lable4.text = [NSString stringWithFormat:@"%@：  %@",[CommenUtil LocalizedString:@"Collection.MethodPayment"],[CommenUtil LocalizedString:@"Collection.WXPay"]];
    } else if ([type isEqualToString:@"API_QQQRCODE"]) {
        self.lable4.text = [NSString stringWithFormat:@"%@：  %@",[CommenUtil LocalizedString:@"Collection.MethodPayment"],[CommenUtil LocalizedString:@"Collection.QQPay"]];
    } else if ([type isEqualToString:@"API_JDQRCODE"]) {
        self.lable4.text = [NSString stringWithFormat:@"%@：  %@",[CommenUtil LocalizedString:@"Collection.MethodPayment"],[CommenUtil LocalizedString:@"Collection.JDPay"]];
    } else if ([type isEqualToString:@"API_BDQRCODE"]) {
        self.lable4.text = [NSString stringWithFormat:@"%@：  %@",[CommenUtil LocalizedString:@"Collection.MethodPayment"],[CommenUtil LocalizedString:@"Collection.BDPay"]];
    } else {
        self.lable4.text = [NSString stringWithFormat:@"%@：  %@",[CommenUtil LocalizedString:@"Collection.MethodPayment"],[CommenUtil LocalizedString:@"Collection.SweepCodeCollection"]];
    }
}

- (void)tureAction
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MLCollectionViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark  - getter

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 320.5)];
        [_layerView addSubview:self.nameLable];
        [_layerView addSubview:self.xianView1];
        [_layerView addSubview:self.lable1];
        [_layerView addSubview:self.lable2];
        [_layerView addSubview:self.lable3];
        [_layerView addSubview:self.lable4];
        [_layerView addSubview:self.lable5];
        [_layerView addSubview:self.xianView2];
        [_layerView addSubview:self.lable6];
        [_layerView addSubview:self.lable7];
    }
    return _layerView;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.layerView.frame) - 120)/2, 25, 120, 30)];
        _nameLable.text = [CommenUtil LocalizedString:@"Collection.PaymentSuccess"];
        _nameLable.textAlignment = NSTextAlignmentRight;
        _nameLable.font = FT(20);
        _nameLable.textColor = RGB(0, 193, 91);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 24, 24)];
        img.image = [UIImage imageNamed:@"success"];
        img.clipsToBounds = YES;
        [_nameLable addSubview:img];
    }
    return _nameLable;
}

- (UIView *)xianView1
{
    if (!_xianView1) {
        _xianView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.layerView.frame), 0.5)];
        _xianView1.backgroundColor = [UIColor lightGrayColor];
        _xianView1.alpha = 0.5;
    }
    return _xianView1;
}

- (UILabel *)lable1
{
    if (!_lable1) {
        _lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.layerView.frame)-40, 30)];
        _lable1.font = FT(15);
        _lable1.alpha = 0.5;
    }
    return _lable1;
}

- (UILabel *)lable2
{
    if (!_lable2) {
        _lable2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, CGRectGetWidth(self.layerView.frame)-40, 30)];
        _lable2.font = FT(15);
        _lable2.alpha = 0.5;
    }
    return _lable2;
}

- (UILabel *)lable3
{
    if (!_lable3) {
        _lable3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, CGRectGetWidth(self.layerView.frame)-40, 30)];
        _lable3.font = FT(15);
        _lable3.alpha = 0.5;
    }
    return _lable3;
}

- (UILabel *)lable4
{
    if (!_lable4) {
        _lable4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, CGRectGetWidth(self.layerView.frame)-40, 30)];
        _lable4.font = FT(15);
        _lable4.alpha = 0.5;
    }
    return _lable4;
}

- (UILabel *)lable5
{
    if (!_lable5) {
        _lable5 = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, CGRectGetWidth(self.layerView.frame)-40, 30)];
        _lable5.text = [CommenUtil LocalizedString:@"Collection.StateSuccess"];
        _lable5.font = FT(15);
        _lable5.alpha = 0.5;
    }
    return _lable5;
}

- (UIView *)xianView2
{
    if (!_xianView2) {
        _xianView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 270, CGRectGetWidth(self.layerView.frame), 0.5)];
        _xianView2.backgroundColor = [UIColor lightGrayColor];
        _xianView2.alpha = 0.5;
    }
    return _xianView2;
}

- (UILabel *)lable6
{
    if (!_lable6) {
        _lable6 = [[UILabel alloc] initWithFrame:CGRectMake(20, 270.5, 100, 50)];
        _lable6.font = FT(15);
        _lable6.alpha = 0.5;
        _lable6.text = [CommenUtil LocalizedString:@"Collection.CollectionMoney"];
    }
    return _lable6;
}

- (UILabel *)lable7
{
    if (!_lable7) {
        _lable7 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.layerView.frame)-120, 270.5, 100, 50)];
        _lable7.font = FT(15);
        _lable7.textColor = RGB(0, 193, 91);
        _lable7.text = [NSString stringWithFormat:@"￥%@",self.money];
        _lable7.textAlignment = NSTextAlignmentRight;
    }
    return _lable7;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
