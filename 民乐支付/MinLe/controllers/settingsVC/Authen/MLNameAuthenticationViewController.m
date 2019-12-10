//
//  MLNameAuthenticationViewController.m
//  民乐支付
//  实名认证
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLNameAuthenticationViewController.h"
#import "MLValidationAuditsViewController.h"
#import "MLHomeViewController.h"
#import "MLPeopleCertificationViewController.h"
#import "CertificationNameView.h"
#import "MLFaceViewController.h"

@interface MLNameAuthenticationViewController ()

@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIScrollView *nameSrcollView;
@property (nonatomic, strong) CertificationNameView *nameCerView;
@property (nonatomic, strong) UIButton *but;
@property (nonatomic, strong) UIButton *backBut;

@end

@implementation MLNameAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.nameSrcollView];
    [self.view addSubview:self.but];
}

#pragma mark - UI

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Authen.Name"]];
        _naView.but.alpha = 0;
        if (!self.isRegister) {
            [_naView addSubview:self.backBut];
        }
    }
    return _naView;
}

- (UIScrollView *)nameSrcollView
{
    if (!_nameSrcollView) {
        _nameSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64-50)];
        _nameSrcollView.contentSize = CGSizeMake(0, 440);
        _nameSrcollView.showsVerticalScrollIndicator = NO;
        _nameSrcollView.showsHorizontalScrollIndicator = NO;
        
        [_nameSrcollView addSubview:self.nameCerView];
    }
    return _nameSrcollView;
}

- (CertificationNameView *)nameCerView
{
    if (!_nameCerView) {
        _nameCerView = [[CertificationNameView alloc] initWithFrame:CGRectMake(15, 0, widthss-30, 340)];
    }
    return _nameCerView;
}

#pragma mark - 返回
- (void)popAction
{
    if ([self.isPopRoot isEqualToString:@"1"]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MLHomeViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        _but.backgroundColor = RGB(2, 138, 218);
        [_but setTitle:[CommenUtil LocalizedString:@"Common.Next"] forState:UIControlStateNormal];
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_but addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
        _but.titleLabel.font = FT(20);
    }
    return _but;
}

- (void)pushAction:(UIButton *)sender
{
    if ([self.nameCerView.fView.leftImg.image isEqual:[UIImage imageNamed:@"name-card-pos"]]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.PeopleFace"] showView:nil];
    } else if ([self.nameCerView.zView.leftImg.image isEqual:[UIImage imageNamed:@"name-card-back"]]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Authen.EmblemFace"] showView:nil];
    } else {
        NSDictionary *dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"type":@"1",@"act":self.nameCerView.nameTextField.text,@"act_id_card":self.nameCerView.nameNumberTextField.text};
        NSArray *imgArray = @[self.nameCerView.fView.leftImg.image,self.nameCerView.zView.leftImg.image];
        MLFaceViewController *faceVC = [[MLFaceViewController alloc] init];
        faceVC.isRegister = self.isRegister;
        faceVC.isPopRoot = self.isPopRoot;
        faceVC.dic = dic;
        faceVC.imgArray = imgArray;
        [self.navigationController pushViewController:faceVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
