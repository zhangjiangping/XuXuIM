//
//  SaomiaoViewController.m
//  民乐支付
//
//  Created by JP on 2017/4/10.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "SaomiaoViewController.h"
#import "HYScanningView.h"
#import "BaseWebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MLQrDetailViewController.h"
#import "MBProgressHUD.h"
#import "SoundUtil.h"

#if !TARGET_IPHONE_SIMULATOR
#define HAS_AVFF 1
#endif

@interface SaomiaoViewController () <HYScanningViewDelegate>
{
    UIImageView *qrImg;
    UIImageView *barImg;
    NSString *timeStr;//外部订单号
    int mark;
    MBProgressHUD *hud;
}
@property (strong, nonatomic) HYScanningView *scanningView;
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIView *navigationView;//自定义导航栏背景视图
@property (nonatomic, strong) UIButton *dengBut;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *backBottomView;
@end

@implementation SaomiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scanningView startScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _dengBut.selected = NO;
    mark = 1;
    [self.scanningView stopScanning];
}

- (void)setUI
{
    mark = 1;
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.backBottomView];
    [self.view addSubview:self.bottomView];
    [self.scanningView startScanning];
}

#pragma mark - Action

- (void)barAction:(UIButton *)sender
{
    UIButton *qrBut = [self.bottomView viewWithTag:1];
    UIButton *barBut = [self.bottomView viewWithTag:2];
    if (sender.tag == 1) {
        if (!sender.selected) {
            qrBut.selected = YES;
            barBut.selected = NO;
            qrImg.image = [UIImage imageNamed:@"qr"];
            barImg.image = [UIImage imageNamed:@"bar-code"];
            _scanningView.type = HYScanningViewTypeQR;
            [_scanningView setBarFrame:CGRectMake((widthss-260)/2, 100, 260, 260)];
        }
    } else if (sender.tag == 2) {
        if (!sender.selected) {
            barBut.selected = YES;
            qrBut.selected = NO;
            barImg.image = [UIImage imageNamed:@"bar"];
            qrImg.image = [UIImage imageNamed:@"qr-code"];
            _scanningView.type = HYScanningViewTypeBar;
            [_scanningView setBarFrame:CGRectMake((widthss-260)/2, 150, 260, 90)];
        }
    }
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64)];
        _navigationView.backgroundColor = RGB(60, 60, 60);
    }
    return _navigationView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Collection.QRCodeAndBarcode"]];
        _naView.backgroundColor = [UIColor clearColor];
        [_naView addSubview:self.dengBut];
    }
    return _naView;
}

- (HYScanningView *)scanningView
{
    if (!_scanningView) {
        _scanningView = [[HYScanningView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64-82)];
        _scanningView.boxFrame = CGRectMake((widthss-260)/2, 100, 260, 260);//扫描框大小
        _scanningView.coverColor = RGB(60, 60, 60);//扫描框外部颜色
        _scanningView.cornerColor = RGB(116, 248, 252);//边角颜色
        _scanningView.delegate = self;
        _scanningView.type = HYScanningViewTypeQR;//设置扫描类型 默认支持扫描二维码
    }
    return _scanningView;
}

- (UIView *)backBottomView
{
    if (!_backBottomView) {
        _backBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-82, screenWidth, 82)];
        _backBottomView.backgroundColor = RGB(60, 60, 60);
    }
    return _backBottomView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-82, screenWidth, 82)];
        _bottomView.backgroundColor = [UIColor clearColor];
        
        UIButton *qrBut = [UIButton buttonWithType:UIButtonTypeCustom];
        qrBut.frame = CGRectMake(0, 0, screenWidth/2, 82);
        qrBut.tag = 1;
        qrBut.selected = YES;
        [qrBut addTarget:self action:@selector(barAction:) forControlEvents:UIControlEventTouchUpInside];
        qrImg = [[UIImageView alloc] initWithFrame:CGRectMake((widthss-260)/2, (82-30)/2, 30, 30)];
        qrImg.image = [UIImage imageNamed:@"qr"];
        qrImg.clipsToBounds = YES;
        [qrBut addSubview:qrImg];
        
        UIButton *tiaomaBut = [UIButton buttonWithType:UIButtonTypeCustom];
        tiaomaBut.frame = CGRectMake(screenWidth/2, 0, screenWidth/2, 82);
        tiaomaBut.tag = 2;
        tiaomaBut.selected = NO;
        [tiaomaBut addTarget:self action:@selector(barAction:) forControlEvents:UIControlEventTouchUpInside];
        barImg = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth/2-(widthss-260)/2-30), (82-30)/2, 30, 30)];
        barImg.image = [UIImage imageNamed:@"bar-code"];
        barImg.clipsToBounds = YES;
        [tiaomaBut addSubview:barImg];
        
        [_bottomView addSubview:qrBut];
        [_bottomView addSubview:tiaomaBut];
    }
    return _bottomView;
}

- (UIButton *)dengBut
{
    if (!_dengBut) {
        _dengBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _dengBut.frame = CGRectMake(widthss-41, 24, 31, 31);
        [_dengBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dengBut setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _dengBut.titleLabel.font= [UIFont systemFontOfSize:16];
        [_dengBut setBackgroundImage:[UIImage imageNamed:@"light_scan"] forState:UIControlStateNormal];
        [_dengBut setBackgroundImage:[UIImage imageNamed:@"selected_light_scan"] forState:UIControlStateSelected];
        [_dengBut addTarget:self action:@selector(openShanGuangDeng:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dengBut;
}

- (void)openShanGuangDeng:(UIButton *)s
{
    if (s.selected) {
        s.selected = NO;
        [self setTorch:NO];
    } else {
        s.selected = YES;
        [self setTorch:YES];
    }
}

#pragma mark - Torch
//闪光灯
- (void)setTorch:(BOOL)status {
#if HAS_AVFF
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [captureDeviceClass defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        if ( [device hasTorch] ) {
            if ( status ) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
        [device unlockForConfiguration];
    }
#endif
}

#pragma mark - HYScanningViewDelegate

- (void)scanningView:(HYScanningView *)scanningView didFinishScanCode:(NSString *)content
{
    [_scanningView stopScanning];
    timeStr = [CommenUtil getOut_order_number];
    NSDictionary *dic = @{@"cmbcmchntid":self.shanghuhao,@"out_order_number":timeStr,@"callback":@"#",@"amount":self.amount,@"remark":content};
    hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"order..."] showView:nil];
    [SharedApp.netWorking myPostWithUrlString:reverse_scanURL withParameter:dic withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            [hud hide:YES];
            hud = [[MBProgressHUD shareInstance] showLoding:[CommenUtil LocalizedString:@"WaitingPay..."] showView:nil];
            [self getQuery];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            [_scanningView startScanning];
            [hud hide:YES];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        [hud hide:YES];
        [_scanningView startScanning];
        NSLog(@"%@",error);
    }];
}

//订单查询
- (void)getQuery
{
    [SharedApp.netWorking myPostWithUrlString:reverse_scan_checkURL withParameter:@{@"out_order_number":timeStr} withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSString *tradeStatus = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"tradeStatus"]];
            if ([tradeStatus isEqualToString:@"S"]) {
                [[SoundUtil sharedInstance] playSound];
                [hud hide:YES];
                mark = 0;
                MLQrDetailViewController *detailVC = [[MLQrDetailViewController alloc] init];
                detailVC.order_num = timeStr;
                detailVC.money = self.amount;
                detailVC.isSaomiao = YES;
                detailVC.detailDataDic = responseObject[@"detail"][0];
                [self.navigationController pushViewController:detailVC animated:YES];
            } else {
                if (mark == 1) {
                    [self getQuery];//如果不匹配继续请求
                }
            }
        } else {
            [hud hide:YES];
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.OrderFailed"] showView:nil];
            [_scanningView startScanning];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        [hud hide:YES];
        [_scanningView startScanning];
        NSLog(@"%@",error);
    }];
}

- (void)dealloc {
    [_scanningView stopScanning];
}

//工具条背景颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
