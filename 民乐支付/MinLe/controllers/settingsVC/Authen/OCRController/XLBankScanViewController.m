//
//  XLBankScanViewController.m
//  IDAndBankCard
//
//  Created by mxl on 2017/3/28.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "XLBankScanViewController.h"

@interface XLBankScanViewController ()
{
    LHSIDCardScaningView *IDCardScaningView;
}
@end

@implementation XLBankScanViewController

#pragma mark - view即将出现时
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - view即将消失时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cameraManager stopSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == IDCardTypeReverse) {
        //身份证国徽面识别
        if ([self.cameraManager configIDScanManager]) {
            [self initCVCamera];
        } else {
            NSLog(@"打开相机失败");
            [self noCamera];
        }
        [self.cameraManager.idCardScanSuccess subscribeNext:^(id x) {
            [self showResult:x];
        }];
    } else {
        //银行卡识别
        if ([self.cameraManager configBankScanManager]) {
            [self initCVCamera];
        } else {
            NSLog(@"打开相机失败");
            [self noCamera];
        }
        [self.cameraManager.bankScanSuccess subscribeNext:^(id x) {
            [self showResult:x];
        }];
    }
    [self.cameraManager.scanError subscribeNext:^(id x) {
    }];
}

//没有相机权限提示框
- (void)noCamera
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Face.CheckNotCameraPer"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Setup"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Cancle"] style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

//初始化识别对象
- (void)initCVCamera
{
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraManager.captureSession];
    preLayer.frame = self.view.frame;
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:preLayer];
    
    //添加自定义的扫描界面（中间有一个镂空窗口和来回移动的扫描线）
    IDCardScaningView = [[LHSIDCardScaningView alloc] initWithFrame:self.view.frame withType:self.type];
    self.faceDetectionFrame = IDCardScaningView.facePathRect;
    [self.view addSubview:IDCardScaningView];
    [IDCardScaningView addSubview:self.naView];
    
    [self.dengBut addTarget:self action:@selector(turnOnOrOffTorch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cameraManager startSession];
}

//扫描回调
- (void)showResult:(id)result
{
    [self clearSession];
    
    IDInfo *model = (IDInfo *)result;
    
    BOOL a = NO;
    if (self.type == IDCardTypeReverse) {
        a = (model && model.issue && model.valid);
    } else {
        a = (model && model.bankNumber && model.bankName);
    }
    if (a) {
        // 播放一下“拍照”的声音，模拟拍照
        AudioServicesPlaySystemSound(1108);
        if (self.block) {
            self.block(model);
        }
        [self close];
    } else {
        //震动一下
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[CommenUtil LocalizedString:@"Face.ScanFaileAgain"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Ture"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self beginSession];
            [alertC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark - 打开／关闭手电筒

- (void)turnOnOrOffTorch
{
    self.torchOn = !self.isTorchOn;
    if ([self.cameraManager cameraHasTorch]) {
        [[self.cameraManager activeCamera] lockForConfiguration:nil];// 请求独占访问硬件设备
        
        if (self.isTorchOn) {
            self.touchImage.image = [UIImage imageNamed:@"flash-on"];
            [[self.cameraManager activeCamera] setTorchMode:AVCaptureTorchModeOn];
        } else {
            self.touchImage.image = [UIImage imageNamed:@"flash-close"];
            [[self.cameraManager activeCamera] setTorchMode:AVCaptureTorchModeOff];
        }
        [[self.cameraManager activeCamera] unlockForConfiguration];// 请求解除独占访问硬件设备
    } else {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Ture"] style:UIAlertActionStyleDefault handler:nil];
        [self alertControllerWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Face.NotFlashlightMsg"] okAction:okAction cancelAction:nil];
    }
}

- (void)dealloc
{
    [self clearSession];
}

- (void)clearSession
{
    [IDCardScaningView clearTimer];
    [self.cameraManager.captureSession stopRunning];
}

- (void)beginSession
{
    [IDCardScaningView addTimer];
    [self.cameraManager startSession];
}

@end
