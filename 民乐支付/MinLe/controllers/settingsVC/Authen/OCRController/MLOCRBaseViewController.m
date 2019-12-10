//
//  MLOCRBaseViewController.m
//  民乐支付
//
//  Created by JP on 2017/7/27.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "MLOCRBaseViewController.h"

@interface MLOCRBaseViewController ()

@end

@implementation MLOCRBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cameraManager = [[XLScanManager alloc] init];
    if (self.type == BankCardTypePositive) {
        self.cameraManager.sessionPreset = AVCaptureSessionPreset1280x720;
    } else {
        self.cameraManager.sessionPreset = AVCaptureSessionPresetHigh;
    }
}

#pragma mark - 打开／关闭手电筒
- (void)turnOnOrOffTorch:(AVCaptureDevice *)device
{
    self.torchOn = !self.isTorchOn;
    if ([device hasTorch]){ // 判断是否有闪光灯
        [device lockForConfiguration:nil];// 请求独占访问硬件设备
        
        if (self.isTorchOn) {
            _touchImage.image = [UIImage imageNamed:@"flash-on"];
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            _touchImage.image = [UIImage imageNamed:@"flash-close"];
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];// 请求解除独占访问硬件设备
    } else {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Ture"] style:UIAlertActionStyleDefault handler:nil];
        [self alertControllerWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Face.NotFlashlightMsg"] okAction:okAction cancelAction:nil];
    }
}

#pragma mark - Action

- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - view即将出现时
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.torchOn = NO;
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - view即将消失时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - UI

- (UIView *)naView
{
    if (!_naView) {
        _naView = [[UIView alloc] initWithFrame:CGRectMake(widthss-64, 0, 64, heightss)];
        _naView.backgroundColor = [UIColor clearColor];
        [_naView addSubview:self.backBut];
        [_naView addSubview:self.dengBut];
    }
    return _naView;
}

- (UIButton *)backBut
{
    if (!_backBut) {
        _backBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBut.frame = CGRectMake(0, 0, 64, 64);
        [_backBut addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        _backBut.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(64-leftJianxi-dengWH, topJianxi, dengWH, dengWH)];
        backImage.image = [UIImage imageNamed:@"ocr_back"];
        backImage.clipsToBounds = YES;
        [_backBut addSubview:backImage];
    }
    return _backBut;
}

- (UIButton *)dengBut
{
    if (!_dengBut) {
        _dengBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _dengBut.frame = CGRectMake(0, heightss-64, 64, 64);
        _dengBut.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        
        [_dengBut addSubview:self.touchImage];
    }
    return _dengBut;
}

- (UIImageView *)touchImage
{
    if (!_touchImage) {
        _touchImage = [[UIImageView alloc] initWithFrame:CGRectMake(64-leftJianxi-dengWH, topJianxi, dengWH, dengWH)];
        _touchImage.image = [UIImage imageNamed:@"flash-close"];
        _touchImage.clipsToBounds = YES;
    }
    return _touchImage;
}


#pragma mark queue
- (dispatch_queue_t)queue {
    if (_queue == nil) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _queue;
}

#pragma mark 使用相机设备受限
-(void)showAuthorizationRestricted
{
    NSString *title = [CommenUtil LocalizedString:@"Face.CameraParmpt"];
    NSString *message = [CommenUtil LocalizedString:@"Face.CheckPhoneAndSetup"];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Ture"] style:UIAlertActionStyleDefault handler:nil];
    [self alertControllerWithTitle:title message:message okAction:okAction cancelAction:nil];
}

#pragma mark - 展示UIAlertController
-(void)alertControllerWithTitle:(NSString *)title message:(NSString *)message okAction:(UIAlertAction *)okAction cancelAction:(UIAlertAction *)cancelAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message okAction:okAction cancelAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 未被授权使用相机
-(void)showAuthorizationDenied {
    NSString *title = [CommenUtil LocalizedString:@"Face.CameraNotAuth"];
    NSString *message = [CommenUtil LocalizedString:@"Face.CameraSetupMsg"];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Face.GoSetup"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 跳转到该应用的隐私设授权置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Cancle"] style:UIAlertActionStyleDefault handler:nil];
    
    [self alertControllerWithTitle:title message:message okAction:okAction cancelAction:cancelAction];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
