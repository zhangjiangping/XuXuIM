//
//  MLErWeiMaViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/7.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLErWeiMaViewController.h"
#import "HYScanningView.h"
#import "BaseWebViewController.h"
#import <AVFoundation/AVFoundation.h>

#if !TARGET_IPHONE_SIMULATOR
#define HAS_AVFF 1
#endif

@interface MLErWeiMaViewController () <HYScanningViewDelegate>
@property (strong, nonatomic) HYScanningView *scanningView;
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIView *navigationView;//自定义导航栏背景视图
@property (nonatomic, strong) UIButton *dengBut;
@end

@implementation MLErWeiMaViewController

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
    [self.scanningView stopScanning];
}

- (void)setUI
{
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.scanningView];
    [self.scanningView startScanning];
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
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"QR.ScanQR"]];
        _naView.backgroundColor = [UIColor clearColor];
        [_naView addSubview:self.dengBut];
    }
    return _naView;
}

- (HYScanningView *)scanningView
{
    if (!_scanningView) {
        _scanningView = [[HYScanningView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64)];
        _scanningView.boxFrame = CGRectMake((widthss-260)/2, (heightss-260-128)/2, 260, 260);//扫描框大小
        _scanningView.coverColor = RGB(60, 60, 60);//扫描框外部颜色
        _scanningView.cornerColor = RGB(116, 248, 252);//边角颜色
        _scanningView.delegate = self;
        _scanningView.vc = self;
        _scanningView.type = HYScanningViewTypeQRBar;//设置扫描类型 支持扫描二维码和条形码
    }
    return _scanningView;
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
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.titleStr = [CommenUtil LocalizedString:@"QR.Detail"];
    webVC.urlStr = [NSString stringWithFormat:@"%@/token/%@",content,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    webVC.isRoot = self.isAuthen;
    [self.navigationController pushViewController:webVC animated:YES];
}

//相机权限
- (void)camerPermission:(BOOL)isPermission
{
    if (!isPermission) {
        NSString *photoType = [CommenUtil LocalizedString:@"Permission.Camera"];
        [self showPermission:photoType];
    }
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
