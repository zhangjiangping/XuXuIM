//
//  MLInformationViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/20.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLInformationViewController.h"
#import "MLInformationView.h"
#import "MLSettingsPhoneViewController.h"
#import "UIButton+MyButton.h"
#import "UIImageView+MyImageView.h"

@interface MLInformationViewController ()
{
    NSString *editStr;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) MLInformationView *inforMationView;
@property (nonatomic, strong) UIButton *myBut;//修改手机号码按钮
@end

@implementation MLInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUI
{
    [self request];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.inforMationView];
    [self.view addSubview:self.myBut];
}

- (MLInformationView *)inforMationView
{
    if (!_inforMationView) {
        _inforMationView = [[MLInformationView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 330) withStr:editStr withImg:self.photoImg];
    }
    return _inforMationView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Me.Information"]];
        [_naView.but addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naView;
}

- (void)backAction:(UIButton *)sender
{
    [self.backDelegate backActionWithImage:self.inforMationView.img.image];
}

- (void)request
{
    [SharedApp.netWorking createPostWithUrlString:infomationURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
//            if (![responseObject[@"data"][0][@"path_img"] isEqualToString:@""] || [responseObject[@"data"][0][@"path_img"] isEqual:[NSNull null]]) {
//                NSString *imgStr = [NSString stringWithFormat:@"%@%@",MLMLJK,responseObject[@"data"][0][@"path_img"]];
//                [self.inforMationView.img setImageWithString:imgStr withDefalutImage:[UIImage imageNamed:@"touxiang"]];
//            }
            self.inforMationView.status = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"status"]];
            [self.inforMationView.nameBut setTitle:responseObject[@"data"][0][@"username"] forState:UIControlStateNormal];
            [self.inforMationView.sexBut setTitle:responseObject[@"data"][0][@"sex"] forState:UIControlStateNormal];
            [self.inforMationView.myPhoneBut setTitle:responseObject[@"data"][0][@"phone"] forState:UIControlStateNormal];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

//刷新
- (void)upLoadReuest
{
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
