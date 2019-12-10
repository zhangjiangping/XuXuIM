//
//  MLOCRBaseViewController.h
//  民乐支付
//
//  Created by JP on 2017/7/27.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDInfo.h"
#import "LHSIDCardScaningView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "excards.h"
#import "exbankcard.h"
#import "BankCardSearch.h"
#import "UIImage+Extend.h"
#import "RectManager.h"
#import "XLScanManager.h"
#import "UIAlertController+Extend.h"

#define dengWH 26
#define dengJianxi 30
#define leftJianxi 22
#define topJianxi  20

typedef void(^InfoBlock)(IDInfo *info);

@interface MLOCRBaseViewController : UIViewController

@property (nonatomic, copy) InfoBlock block;
@property (nonatomic, assign) IDCardType type;

// 是否打开手电筒
@property (nonatomic,assign,getter = isTorchOn) BOOL torchOn;
// 人脸检测框区域
@property (nonatomic,assign) CGRect faceDetectionFrame;
//扫描识别对象
@property (nonatomic, strong) XLScanManager *cameraManager;
// 队列
@property (nonatomic,strong) dispatch_queue_t queue;

//自定义导航视图
@property (nonatomic, strong) UIView *naView;
@property (nonatomic, strong) UIButton *dengBut;
@property (nonatomic, strong) UIButton *backBut;
@property (nonatomic, strong) UIImageView *touchImage;


#pragma mark - 打开／关闭手电筒
- (void)turnOnOrOffTorch:(AVCaptureDevice *)device;

#pragma mark 使用相机设备受限
-(void)showAuthorizationRestricted;

#pragma mark 未被授权使用相机
-(void)showAuthorizationDenied;

-(void)alertControllerWithTitle:(NSString *)title message:(NSString *)message okAction:(UIAlertAction *)okAction cancelAction:(UIAlertAction *)cancelAction;

- (void)close;

@end
