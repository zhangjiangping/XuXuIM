//
//  MLElectronicNotViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/8.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLElectronicNotViewController.h"
#import "MLMinLeTextField.h"
#import "BaseLayerView.h"
#import "MLElectornicYesViewController.h"
#import "MLRegisterViewController.h"
#import "MLGoSaoMiaoViewController.h"

@interface MLElectronicNotViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UIButton *goBut;
@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UIImageView *eleImg;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) MLMinLeTextField *myTextField;
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIButton *but;
@end

@implementation MLElectronicNotViewController

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
    [self.view addSubview:self.naView];
    [self.view addSubview:self.layerView];
    [self.view addSubview:self.lable];
    [self.view addSubview:self.but];
    [self.view addSubview:self.goBut];
}

//当视图完全显示 让输入框成为第一响应者
- (void)viewDidAppear:(BOOL)animated
{
    [self.myTextField becomeFirstResponder];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Me.ElectronicAccount"]];
    }
    return _naView;
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 270)];
        [_layerView addSubview:self.messageLable];
        [_layerView addSubview:self.eleImg];
        [_layerView addSubview:self.nameLable];
        [_layerView addSubview:self.myTextField];
    }
    return _layerView;
}

- (UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, widthss-90, 15)];
        _messageLable.text = [CommenUtil LocalizedString:@"Electronic.PromptNotBound"];
        _messageLable.font = FT(15);
        _messageLable.textAlignment = NSTextAlignmentCenter;
        _messageLable.adjustsFontSizeToFitWidth = YES;
        _messageLable.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _messageLable;
}

- (UIImageView *)eleImg
{
    if (!_eleImg) {
        _eleImg = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.layerView.frame)-110)/2, CGRectGetMaxY(self.messageLable.frame)+25, 110, 110)];
        _eleImg.image = [UIImage imageNamed:@"e_nobody"];
        _eleImg.clipsToBounds = YES;
    }
    return _eleImg;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.eleImg.frame)+30, 70, 30)];
        _nameLable.text = [CommenUtil LocalizedString:@"Me.ElectronicAccount"];
        _nameLable.font = FT(15);
    }
    return _nameLable;
}

- (MLMinLeTextField *)myTextField
{
    if (!_myTextField) {
        _myTextField = [[MLMinLeTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLable.frame), CGRectGetMinY(self.nameLable.frame), CGRectGetWidth(self.layerView.frame)-CGRectGetMaxX(self.nameLable.frame)-30, 30)];
        _myTextField.placeholder = [CommenUtil LocalizedString:@"Electronic.EnterBankNumber"];
        _myTextField.adjustsFontSizeToFitWidth = YES;
        _myTextField.contentMode = UIViewContentModeScaleAspectFill;
        _myTextField.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_myTextField.frame)-1, CGRectGetWidth(_myTextField.frame), 1)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [_myTextField addSubview:view];
    }
    return _myTextField;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake((widthss-150)/2, CGRectGetMaxY(self.layerView.frame)+50, 100, 20)];
        _lable.text = [CommenUtil LocalizedString:@"Electronic.NotElectronic"];
        _lable.font = FT(15);
        _lable.textAlignment = NSTextAlignmentRight;
    }
    return _lable;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.frame = CGRectMake(CGRectGetMaxX(self.lable.frame), CGRectGetMinY(self.lable.frame), 50, 20);
        [_but setTitle:[CommenUtil LocalizedString:@"Electronic.GoRegister"] forState:UIControlStateNormal];
        [_but addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _but;
}

- (UIButton *)goBut
{
    if (!_goBut) {
        _goBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _goBut.frame = CGRectMake(0, heightss-50, widthss, 50);
        [_goBut setTitle:[CommenUtil LocalizedString:@"Electronic.Binding"] forState:UIControlStateNormal];
        _goBut.titleLabel.font = FT(19);
        [_goBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goBut.backgroundColor = RGB(0, 134, 219);
        [_goBut addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBut;
}

- (void)pushAction:(UIButton *)sender
{
    if (self.myTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Electronic.NotEnterElectronic"] showView:nil];
    } else {
        [[MCNetWorking sharedInstance] createPostWithUrlString:update_accountURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"cmbc_account":self.myTextField.text} withComplection:^(id responseObject) {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            if ([responseObject[@"status"] isEqual:@1]) {
                MLElectornicYesViewController *eleVC = [[MLElectornicYesViewController alloc] init];
                eleVC.eleStr = responseObject[@"data"][0][@"cmbc_account"];
                [self.navigationController pushViewController:eleVC animated:YES];
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    }
}

- (void)registerAction
{
    MLGoSaoMiaoViewController *goVC = [[MLGoSaoMiaoViewController alloc] init];
    [self.navigationController pushViewController:goVC animated:YES];
}

@end










