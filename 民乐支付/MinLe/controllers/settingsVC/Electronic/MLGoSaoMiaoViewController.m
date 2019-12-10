//
//  MLGoSaoMiaoViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/11.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLGoSaoMiaoViewController.h"
#import "BaseLayerView.h"
#import "UIImageView+MyImageView.h"
#import "MLHomeViewController.h"

@interface MLGoSaoMiaoViewController () <UIActionSheetDelegate>
{
    UILongPressGestureRecognizer *_longGesture;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *backBut;//返回按钮
@property (nonatomic, strong) UIImageView *minleBankImage;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UIView *xianView;
@end

@implementation MLGoSaoMiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    [self request];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.layerView];
    _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    [self.minleBankImage addGestureRecognizer:_longGesture];
}

- (void)request
{
    NSString *urlString = ele_accountURL;
    NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [[MCNetWorking sharedInstance] createPostWithUrlString:urlString withParameter:dic withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSString *imgStr;
            imgStr = [NSString stringWithFormat:@"%@%@",MLMLJK,responseObject[@"data"][0][@"ele_account"]];
            [self.minleBankImage setImageWithString:imgStr withDefalutImage:[UIImage imageNamed:@"unkonwn_QR"]];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

- (void)longAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:[CommenUtil LocalizedString:@"Electronic.SavePhoto"]
                                      delegate:self
                                      cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Cancle"]
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:[CommenUtil LocalizedString:@"Electronic.SavePhotoToPhone"],nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}

#pragma mark --- UIActionSheetDelegate---

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (_minleBankImage.image) {
            UIImageWriteToSavedPhotosAlbum(_minleBankImage.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:[CommenUtil LocalizedString:@"Electronic.PhotoNotLoading"] delegate:self cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Ture"] otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = [CommenUtil LocalizedString:@"Electronic.SaveGood"];
    if (!error) {
        message = [CommenUtil LocalizedString:@"Electronic.SaveSuccess"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:message delegate:self cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Ture"] otherButtonTitles: nil];
        [alert show];
    } else {
        message = [error description];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:message delegate:self cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Ture"] otherButtonTitles: nil];
        [alert show];
    }
}

- (void)popAction
{
    if (self.isPopRoot) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MLHomeViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        NSString *title = [CommenUtil LocalizedString:@"Electronic.Register"];
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:title];
        _naView.but.alpha = 0;
        [_naView addSubview:self.backBut];
    }
    return _naView;
}

- (UIButton *)backBut
{
    if (!_backBut) {
        _backBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _backBut.frame = CGRectMake(0, 0, 64, 64);
        [_backBut addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 12, 20)];
        img.image = [UIImage imageNamed:@"Back"];
        img.clipsToBounds = YES;
        [_backBut addSubview:img];
    }
    return _backBut;
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 390)];
        [_layerView addSubview:self.logoImage];
        //[_layerView addSubview:self.nameLable];
        [_layerView addSubview:self.xianView];
        [_layerView addSubview:self.minleBankImage];
        [_layerView addSubview:self.messageLable];
    }
    return _layerView;
}

- (UIImageView *)logoImage
{
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] init];
        _logoImage.clipsToBounds = YES;
        float imgHeight = [CommenUtil getImgSize:CGSizeMake(248, 71) withImgViewWidth:200];
        _logoImage.frame = CGRectMake((CGRectGetWidth(self.layerView.frame)-200)/2.f, 15, 200, imgHeight);
        _logoImage.image = [UIImage imageNamed:@"logo"];
    }
    return _logoImage;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoImage.frame)+5, CGRectGetWidth(self.layerView.frame), 30)];
        _nameLable.alpha = 0.5;
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.text = [CommenUtil LocalizedString:@"Electronic.LogoName"];
    }
    return _nameLable;
}

- (UIView *)xianView
{
    if (!_xianView) {
        _xianView = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.logoImage.frame)+20, CGRectGetWidth(self.layerView.frame)-60, 0.5)];
        _xianView.backgroundColor = [UIColor lightGrayColor];
        _xianView.alpha = 0.5;
    }
    return _xianView;
}

- (UIImageView *)minleBankImage
{
    if (!_minleBankImage) {
        _minleBankImage = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.layerView.frame)-175)/2, CGRectGetMaxY(self.xianView.frame)+30, 175, 175)];
        _minleBankImage.clipsToBounds = YES;
        _minleBankImage.userInteractionEnabled = YES;
    }
    return _minleBankImage;
}

- (UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.minleBankImage.frame)+30, CGRectGetWidth(self.layerView.frame)-30, 40)];
        _messageLable.textAlignment = NSTextAlignmentCenter;
        _messageLable.font = FT(15);
        _messageLable.alpha = 0.5;
        _messageLable.numberOfLines = 0;
        _messageLable.text = [CommenUtil LocalizedString:@"Electronic.WXScanOrSave"];
        _messageLable.adjustsFontSizeToFitWidth = YES;
        _messageLable.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _messageLable;
}

@end











