//
//  MLFaceViewController.m
//  民乐支付
//
//  Created by JP on 2017/7/28.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "MLFaceViewController.h"
#import "FaceRecognitionService.h"
#import "CaptureFaceService.h"
#import "MLPeopleCertificationViewController.h"
#import "MLValidationAuditsViewController.h"
#import "YLRotateCyclic.h"

#define boxWH 245  //内框长宽
#define outsideWH 265  //外框长宽

@interface MLFaceViewController ()
@property (nonatomic, strong) YLRotateCyclic *rotateCyclic;//外框圆
@property (nonatomic, strong) FaceRecognitionService *recognitionService;
@property (nonatomic, strong) CaptureFaceService *captureFaceService;
@property (nonatomic, strong) MLMyNavigationView *faceNaView;
@property (strong, nonatomic) UIView *vidioView;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *messageLable;
@property (strong, nonatomic) UIImageView *manImageView;
@end

@implementation MLFaceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.faceNaView];
    [self.view addSubview:self.vidioView];
    [self.view addSubview:self.rotateCyclic];
    [self.view addSubview:self.messageLable];
    [self.view addSubview:self.manImageView];
}

//开启识别
- (void)startCaptureFace
{
    __weak typeof(self)weakSelf = self;
    [self.captureFaceService startAutoCaptureFaceWithPreView:self.vidioView andCaptureFaceProgressBlock:^(float faceProgress, float eyeProgress, captureFaceStatus captureFaceStatus)
    {
        NSLog(@"识别进度：%f", eyeProgress);
        //[self.rotateCyclic drawRotateCyclic:[NSNumber numberWithFloat:eyeProgress]];
        
        //获取识别回调状态
        [weakSelf changeTipTextWithCaptureFaceStatus:captureFaceStatus];
        
    } andCompleteBlock:^(UIImage *resultImage, NSError *error) {
        if (error) {
            [self showAleartVc:[CommenUtil LocalizedString:@"Face.ParmptForPhone"] withTitle:[CommenUtil LocalizedString:@"Face.ScanFaile"]];
            return;
        }
        [self handleResultImage:resultImage];
    }];
}


//识别成功，获取到回调图片
- (void)handleResultImage:(UIImage *)resultImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"识别成功");
        [self.rotateCyclic removeAnimation];
        NSMutableArray *nameArray = [NSMutableArray arrayWithArray:self.imgArray];
        [nameArray addObject:resultImage];
        [[MCNetWorking sharedInstance] reloadImageRequestWithUrlString:add_nameAuthenURL withParameter:self.dic withKey:@"act_poster" withImageArray:nameArray withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                if (self.isRegister) {
                    MLPeopleCertificationViewController *peopleVc = [[MLPeopleCertificationViewController alloc] init];
                    peopleVc.isNameCertification = YES;
                    [self.navigationController pushViewController:peopleVc animated:YES];
                } else {
                    MLValidationAuditsViewController *vaVC = [[MLValidationAuditsViewController alloc] init];
                    vaVC.statusStr = @"0";
                    vaVC.isPopRoot = self.isPopRoot;
                    vaVC.status = @"1";
                    [self.navigationController pushViewController:vaVC animated:YES];
                }
            } else {
                [self showAleartVc:[CommenUtil LocalizedString:@"Face.ParmptAgentAuth"] withTitle:[CommenUtil LocalizedString:@"Face.AuthFaile"]];
            }
        } withFailure:^(NSError *error) {
            [self showAleartVc:[CommenUtil LocalizedString:@"Face.ParmptNetWorkErrorAgentAuth"] withTitle:[CommenUtil LocalizedString:@"Face.AuthFaile"]];
            NSLog(@"%@", error);
        }];
    });
}

//弹出提示框
- (void)showAleartVc:(NSString *)msg withTitle:(NSString *)title
{
    __weak typeof(self)weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Ture"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf startCaptureFace];
    }]];
    [weakSelf presentViewController:alertController animated:YES completion:nil];
}

//获取识别回调状态
- (void)changeTipTextWithCaptureFaceStatus:(captureFaceStatus)captureFaceStatus
{
    NSString * title = @"";
    switch (captureFaceStatus) {
        case captureFaceStatus_NoFace:
            title = [CommenUtil LocalizedString:@"Face.NotCheckFace"];
            break;
        case captureFaceStatus_MoreFace:
            title = [CommenUtil LocalizedString:@"Face.OneFace"];
            break;
        case captureFaceStatus_NoBlink:
            title = [CommenUtil LocalizedString:@"Face.Blink"];
            break;
        case captureFaceStatus_OK:
            title = [CommenUtil LocalizedString:@"Validation..."];
            break;
        case captureFaceStatus_NoCamare:
            title = [CommenUtil LocalizedString:@"Face.NotCameraPeimission"];
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.messageLable.text = title;
        if (captureFaceStatus == captureFaceStatus_NoCamare) {
            [self.captureFaceService stopCaptureFace];
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Face.CheckNotCameraPer"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Setup"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Cancle"] style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    });
}

#pragma mark - UI

- (YLRotateCyclic *)rotateCyclic
{
    if (!_rotateCyclic) {
        NSArray *colors = @[blueRGB];
        _rotateCyclic = [[YLRotateCyclic alloc] initWithFrame:CGRectMake(0, 0, outsideWH, outsideWH) colors:colors drawDuration:3.0 sapceAngle:20.0];
        _rotateCyclic.center = self.vidioView.center;
    }
    return _rotateCyclic;
}

- (CaptureFaceService *)captureFaceService
{
    if (!_captureFaceService) {
        _captureFaceService = [CaptureFaceService new];
    }
    return _captureFaceService;
}

- (UIView *)vidioView
{
    if (!_vidioView) {
        _vidioView = [[UIView alloc] initWithFrame:CGRectMake((widthss-boxWH)/2, 64+72, boxWH, boxWH)];
        _vidioView.backgroundColor = [UIColor lightGrayColor];
    }
    return _vidioView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthss-(boxWH-20))/2, 64+72+10, boxWH-20, boxWH-20)];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont boldSystemFontOfSize:18];
        _statusLabel.text = [CommenUtil LocalizedString:@"Face.PositiveBlink"];
        _statusLabel.backgroundColor = [UIColor lightGrayColor];
        _statusLabel.layer.cornerRadius = (boxWH-20)/2;
        _statusLabel.layer.masksToBounds = YES;
    }
    return _statusLabel;
}

- (UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] init];
        _messageLable.frame = CGRectMake(12, CGRectGetMaxY(self.vidioView.frame)+50, widthss-24, 30);
        _messageLable.textAlignment = NSTextAlignmentCenter;
        _messageLable.textColor = blueRGB;
        _messageLable.font = FT(18);
        _messageLable.text = [CommenUtil LocalizedString:@"Face.PositiveLightEnough"];
    }
    return _messageLable;
}

- (UIImageView *)manImageView
{
    if (!_manImageView) {
        _manImageView = [[UIImageView alloc] initWithFrame:CGRectMake((widthss-115)/2, heightss-115-30, 115, 115)];
        _manImageView.clipsToBounds = YES;
        _manImageView.image = [UIImage imageNamed:@"man"];
    }
    return _manImageView;
}

- (MLMyNavigationView *)faceNaView
{
    if (!_faceNaView) {
        _faceNaView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Face.Scan"]];
    }
    return _faceNaView;
}

#pragma mark - view即将出现时
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startCaptureFace];
}

#pragma mark - view即将消失时
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.captureFaceService stopCaptureFace];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
