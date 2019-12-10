//
//  MLCollectionViewController.m
//  民乐支付
//  收款
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLCollectionViewController.h"
#import "MLCollectionSetView.h"
#import "MLCollectionWindowView.h"
#import "MLCertificationWindowView.h"
#import "MLNameAuthenticationViewController.h"
#import "MLPeopleCertificationViewController.h"
#import "MLYHKCertificationViewController.h"
#import "MLQrCodeViewController.h"
#import "MLValidationAuditsViewController.h"
#import "BaseWebViewController.h"
#import "NSString+MyString.h"
#import "SaomiaoViewController.h"
#import "MLGoSaoMiaoViewController.h"

@interface MLCollectionViewController () <UIActionSheetDelegate,DidSelectedDelegate>
{
    NSNumber *statusNum;
    NSArray *dataArray;
    NSArray *dataArray2;
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UIButton *instructionsBut;

@property (nonatomic, strong) MLCollectionSetView *collecTionSetView;
@property (nonatomic, strong) UIView *shuomingView;

@property (nonatomic, strong) MLCollectionWindowView *windowView;
@property (nonatomic, strong) MLCertificationWindowView *cerWindowView;
@property (nonatomic, strong) UIButton *but;

@end

@implementation MLCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showAuther];
}

//当视图完全显示 让输入框成为第一响应者
- (void)viewDidAppear:(BOOL)animated
{
    //当认证通过后
    if ([statusNum isEqual:@1] ||
        statusNum == nil ||
        [statusNum isEqual:@10]) {
        [_collecTionSetView.customTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cerWindowView hiden];
    [_collecTionSetView.customTextField resignFirstResponder];
}

- (void)setUI
{
    [self getDataArray];
    [self.view addSubview:self.naView];
    [self.view addSubview:self.but];
    [self.view addSubview:self.collecTionSetView];
    [self.view addSubview:self.shuomingView];
    
    [self.view insertSubview:self.windowView aboveSubview:self.view.subviews.lastObject];
    [self.view insertSubview:self.cerWindowView aboveSubview:self.view.subviews.lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MLCollectionSetView *)collecTionSetView
{
    if (!_collecTionSetView) {
        _collecTionSetView = [[MLCollectionSetView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, heightss/2.22)];
        [_collecTionSetView.customTextField.tureBut addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collecTionSetView;
}

- (UIView *)shuomingView
{
    if (!_shuomingView) {
        _shuomingView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.collecTionSetView.frame)+35, widthss-30, 80)];
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        lable1.text = [CommenUtil LocalizedString:@"Common.Instructions"];
        lable1.font = FT(15);
        lable1.alpha = 0.5;
        [_shuomingView addSubview:lable1];
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.shuomingView.frame), 20)];
        lable2.text = [CommenUtil LocalizedString:@"Collection.T0_T1Msg"];
        lable2.font = FT(15);
        lable2.alpha = 0.5;
        [_shuomingView addSubview:lable2];
        UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.shuomingView.frame), 20)];
        lable3.text = [CommenUtil LocalizedString:@"Collection.SelectedRightHelp"];
        lable3.font = FT(15);
        lable3.alpha = 0.5;
        [_shuomingView addSubview:lable3];
    }
    return _shuomingView;
}

- (MLCollectionWindowView *)windowView
{
    if (!_windowView) {
        _windowView = [[MLCollectionWindowView alloc] initWithFrame:CGRectMake(-1000, 0, widthss, heightss)];
        [_windowView.cancelBut addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _windowView.delegate = self;
    }
    return _windowView;
}

- (MLCertificationWindowView *)cerWindowView
{
    if (!_cerWindowView) {
        _cerWindowView = [[MLCertificationWindowView alloc] initWithFrame:CGRectMake(0, -1000, widthss, heightss)];
        [_cerWindowView.certificationBut addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cerWindowView;
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, heightss/2.52) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Collection.SetupMoney"]];
        [_naView addSubview:self.instructionsBut];
    }
    return _naView;
}

- (UIButton *)but
{
    if (!_but) {
        _but = [UIButton buttonWithType:UIButtonTypeSystem];
        _but.backgroundColor = RGB(2, 138, 218);
        _but.frame = CGRectMake(0, heightss-50, widthss, 50);
        [_but setTitle:[CommenUtil LocalizedString:@"Common.Ture"] forState:UIControlStateNormal];
        [_but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _but.titleLabel.font = FT(19);
        [_but addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _but;
}

- (UIButton *)instructionsBut
{
    if (!_instructionsBut) {
        _instructionsBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _instructionsBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-50, 14, 50, 50);
        [_instructionsBut addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        img.image = [UIImage imageNamed:@"bangzhuzhongxin"];
        img.clipsToBounds = YES;
        [_instructionsBut addSubview:img];
    }
    return _instructionsBut;
}

#pragma mark - Didselected delegate

- (void)didSelectedWithType:(NSString *)type withTTtype:(NSString *)tType
{
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *jPushregisterID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:JPushRegisterID]];
    dic = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
            @"money":self.collecTionSetView.customTextField.text,
            @"selectTradeType":type,
            @"remarks":self.collecTionSetView.myTextView.text,
            @"arrival_type":tType,
            @"push_id":jPushregisterID};
    
    if (![type isEqualToString:MLSaoMa]) {
        [[MCNetWorking sharedInstance] createPostWithUrlString:onlinePayURl withParameter:dic withComplection:^(id responseObject) {
            if ([responseObject[@"status"] isEqual:@1]) {
                MLQrCodeViewController *qrVC = [[MLQrCodeViewController alloc] init];
                qrVC.money = self.collecTionSetView.customTextField.text;
                qrVC.imgStr = [NSString stringWithFormat:@"%@%@",MLMLJK,responseObject[@"data"][0][@"moveurl"]];
                qrVC.dingdanhao = responseObject[@"data"][0][@"merchantSeq"];
                qrVC.type = type;
                qrVC.tType = tType;
                qrVC.tiaourl = [NSString stringWithFormat:@"%@%@",MLMLJK,responseObject[@"data"][0][@"tiaourl"]];
                [self.navigationController pushViewController:qrVC animated:YES];
            } else {
                self.but.alpha = 1.0;
                [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
            }
        } withFailure:^(NSError *error) {
            [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
            NSLog(@"%@",error);
        }];
    } else {
        //扫码收款
        [self getCmbcmchntid];
    }
    [self.windowView hiden];
}

- (void)getCmbcmchntid
{
    /*
     id ：商户号id
     cmbcmchntid ：民生商户号
     usestatus ：使用状态  1=使用，0=不使用
     money：金额
     mchntname: 商户简称
     */
    [SharedApp.netWorking createPostWithUrlString:partsListURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(NSDictionary *responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            //扫码收款
            SaomiaoViewController *saomaioVc = [[SaomiaoViewController alloc] init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                if ([dic[@"usestatus"] isEqualToString:@"1"]) {
                    saomaioVc.shanghuhao = dic[@"cmbcmchntid"];
                }
            }
            saomaioVc.amount = self.collecTionSetView.customTextField.text;
            [self.navigationController pushViewController:saomaioVc animated:YES];
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

- (void)onAction:(UIButton *)sender
{
    if (self.collecTionSetView.customTextField.text.length == 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.EnterNotEmpty"] showView:nil];
    } else if (![NSString isTwoPoint:self.collecTionSetView.customTextField.text]) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.MoneyWrong"] showView:nil];
    } else if ([self.collecTionSetView.customTextField.text floatValue] - 0.009 < 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.EnterMoneyMsg"] showView:nil];
    } else if ([self.collecTionSetView.customTextField.text floatValue] - 50000 >= 0) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.MoneyNotMoreThan5Wan"] showView:nil];
    } else {
        [self aleartShow];
    }
}

//弹出底部选择框
- (void)aleartShow
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:[CommenUtil LocalizedString:@"Common.Cancle"] destructiveButtonTitle:nil otherButtonTitles:[CommenUtil LocalizedString:@"Collection.T0TodayToAccount"],[CommenUtil LocalizedString:@"Collection.T1NextDayToAccount"], nil];
    [sheet showInView:self.view];
}

#pragma mark -  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2) {
        if (buttonIndex == 0) {
            [self updataWindowViewWithIsTo:YES];
        } else if (buttonIndex == 1) {
            [self updataWindowViewWithIsTo:NO];
        }
    }
}

//更新支付选择界面
- (void)updataWindowViewWithIsTo:(BOOL)isTo
{
    self.windowView.moneyLable.text = [NSString stringWithFormat:@"%@%@",self.collecTionSetView.customTextField.text,[CommenUtil LocalizedString:@"Common.Yuan"]];
    self.but.alpha = 0;
    [self.windowView show];
    if (isTo) {
        [self.windowView updataTableView:dataArray2 withType:@"0"];
    } else {
        [self.windowView updataTableView:dataArray withType:@"1"];
    }
}

//取消
- (void)cancelAction:(UIButton *)sender
{
    [self.windowView hiden];
    self.but.alpha = 1;
}

//认证跳转
- (void)playAction
{
    [self profileNoAuthAction];
    [self.cerWindowView hiden];
}

//收款须知
- (void)pushAction
{
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.titleStr = [CommenUtil LocalizedString:@"Collection.PaymentInstructions"];
    webVC.urlStr = [NSString stringWithFormat:@"%@2",ApiH5URL];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)getDataArray
{
    dataArray = @[@[@"zhifubao",[CommenUtil LocalizedString:@"Collection.ZFBPay"]],
                  @[@"weixing",[CommenUtil LocalizedString:@"Collection.WXPay"]],@[@"QQ",[CommenUtil LocalizedString:@"Collection.QQPay"]],
                  @[@"JD",[CommenUtil LocalizedString:@"Collection.JDPay"]],@[@"BAIDU",[CommenUtil LocalizedString:@"Collection.BDPay"]],
                  @[@"qr-Receipt",[CommenUtil LocalizedString:@"Collection.SweepCodeCollection"]]];
    dataArray2 = @[@[@"zhifubao",[CommenUtil LocalizedString:@"Collection.ZFBPay"]],
                   @[@"weixing",[CommenUtil LocalizedString:@"Collection.WXPay"]]];
}

- (void)showAuther
{
    self.but.alpha = 1;
    [[MCNetWorking sharedInstance] myPostWithUrlString:check_actauthenURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        statusNum = responseObject[@"status"];
        if ([statusNum isEqual:@1] || [statusNum isEqual:@10]) {
            return ;
        } else {
            //隐藏键盘
            [self.collecTionSetView.customTextField resignFirstResponder];
            [self.cerWindowView show];
            [self.cerWindowView setAuthCerWindowViewState:statusNum];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

//信息认证没有成功点击开通处理事件
- (void)profileNoAuthAction
{
    if (![statusNum isEqual:@1]) {
        if ([statusNum isEqual:@0] || [statusNum isEqual:@2]) {
            MLNameAuthenticationViewController *nameVC = [[MLNameAuthenticationViewController alloc] init];
            nameVC.isPopRoot = @"1";
            [self.navigationController pushViewController:nameVC animated:YES];
        } else if ([statusNum isEqual:@3] || [statusNum isEqual:@6] || [statusNum isEqual:@9]) {
            MLValidationAuditsViewController *vaVC = [[MLValidationAuditsViewController alloc] init];
            vaVC.statusStr = statusNum.description;
            if ([statusNum isEqual:@3]) {
                vaVC.status = @"1";
            } else if ([statusNum isEqual:@6]) {
                vaVC.status = @"2";
            } else if ([statusNum isEqual:@9]) {
                vaVC.status = @"3";
            }
            vaVC.isPopRoot = @"1";
            [self.navigationController pushViewController:vaVC animated:YES];
        } else if ([statusNum isEqual:@7] || [statusNum isEqual:@8]) {
            MLYHKCertificationViewController *yhkVC = [[MLYHKCertificationViewController alloc] init];
            yhkVC.isPopRoot = @"1";
            [self.navigationController pushViewController:yhkVC animated:YES];
        } else if ([statusNum isEqual:@4] || [statusNum isEqual:@5]) {
            MLPeopleCertificationViewController *nameVC = [[MLPeopleCertificationViewController alloc] init];
            nameVC.isPopRoot = @"1";
            [self.navigationController pushViewController:nameVC animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
