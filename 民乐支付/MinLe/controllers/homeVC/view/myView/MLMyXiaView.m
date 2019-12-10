//
//  MLMyXiaView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/20.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLMyXiaView.h"
#import "MLMyButton.h"
#import "MLAccountInformationViewController.h"
#import "UIView+Responder.h"
#import "MLMationAuthenticationViewController.h"
#import "MLMyAssetsViewController.h"
#import "MLMyAgentViewController.h"
#import "MLAccountSettlementViewController.h"
#import "BaseLayerView.h"
#import "MLErWeiMaViewController.h"
#import "MLElectronicNotViewController.h"
#import "MLElectornicYesViewController.h"
#import "MLWithdrawalViewController.h"
#import "MerchantsViewController.h"
#import "FenRunViewController.h"
#import "InternationalViewController.h"
#import "MLBillViewController.h"
#import "MLMyViewController.h"

#define WW  (widths-30)/3
#define HH  (widths-30)/3

@interface MLMyXiaView ()
{
    //收款数组
    NSArray *nameArray;
    NSArray *imgArray;
    
    //付款数组
    NSArray *nameArray2;
    NSArray *imgArray2;
    
    //总高
    float layerHeight;
    //按钮的tag值
    int butTag;
    
    BOOL isShanghu;//是否是商户
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BaseLayerView *myView;
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIView *xianView;

@property (nonatomic, strong) BaseLayerView *myView2;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UIView *xianView2;
@end

@implementation MLMyXiaView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(245, 246, 249);
        layerHeight = 100;
        butTag = 1;
        //,@"提现"  ,@"Withdraw"
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] isEqualToString:@"5"]) {
            nameArray = @[[CommenUtil LocalizedString:@"Home.MyAssets"],
                          [CommenUtil LocalizedString:@"Bill.MyBill"],
                          [CommenUtil LocalizedString:@"Home.AccountDetails"],
                          [CommenUtil LocalizedString:@"Home.InformationAuthentication"],
                          [CommenUtil LocalizedString:@"Home.MyAgent"],
                          [CommenUtil LocalizedString:@"Me.AccountClearing"],
                          [CommenUtil LocalizedString:@"Me.ElectronicAccount"],
                          [CommenUtil LocalizedString:@"Me.Merchants"]];
            imgArray = @[@"Money",@"Statement",@"Accounts",@"Certification",@"MyProfile",@"ClearingAccount",@"Settlement",@"shanghuID"];
            isShanghu = YES;
        } else {
            nameArray = @[[CommenUtil LocalizedString:@"Home.MyAssets"],
                          [CommenUtil LocalizedString:@"Bill.MyBill"],
                          [CommenUtil LocalizedString:@"Home.AccountDetails"],
                          [CommenUtil LocalizedString:@"Home.InformationAuthentication"],
                          [CommenUtil LocalizedString:@"Home.MyAgent"],
                          [CommenUtil LocalizedString:@"Me.AccountClearing"],
                          [CommenUtil LocalizedString:@"Me.ElectronicAccount"],
                          [CommenUtil LocalizedString:@"Me.Merchants"],
                          [CommenUtil LocalizedString:@"Me.FenRunSettlement"]];
            imgArray = @[@"Money",@"Statement",@"Accounts",@"Certification",@"MyProfile",@"ClearingAccount",@"Settlement",@"shanghuID",@"commission"];
            isShanghu = NO;//代理身份
        }
        nameArray2 = @[[CommenUtil LocalizedString:@"Me.InternationalCreditCard"]];
        imgArray2 = @[@"International"];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = NO;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), layerHeight);
        [_scrollView addSubview:self.shangView];
        
        [_scrollView addSubview:self.lable];
        [_scrollView addSubview:self.xianView];
        [_scrollView addSubview:self.myView];
        [self createForViewWithNameArray:nameArray withImgArray:imgArray withSuperView:self.myView withY:CGRectGetMaxY(self.lable.frame)];
        
        [_scrollView addSubview:self.lable2];
        [_scrollView addSubview:self.xianView2];
        [_scrollView addSubview:self.myView2];
        [self createForViewWithNameArray:nameArray2 withImgArray:imgArray2 withSuperView:self.myView2 withY:CGRectGetMaxY(self.lable2.frame)];
    }
    return _scrollView;
}

- (void)createForViewWithNameArray:(NSArray *)nameArr withImgArray:(NSArray *)imgArr withSuperView:(UIView *)superView withY:(float)y
{
    int num = 0;
    NSInteger hang = 0;//判断最后一个button在第几行
    if (nameArr.count % 3 == 0) {
        hang = nameArr.count/3;
    } else {
        hang = nameArr.count/3 + 1;
    }
    layerHeight += 50+HH*hang;
    self.scrollView.contentSize = CGSizeMake(0, layerHeight);
    superView.frame = CGRectMake(15, y, widths-30, HH*hang);
    
    for (int i = 0; i < hang; i++) {
        
        if (i < hang - 1) {
            //添加横线
            [superView addSubview:[self getLineView:CGRectMake(0, HH*(i+1), widths-30, 0.5)]];
        }
        
        NSInteger lastLie = 0;//判断最后一个button在第几列
        if (nameArr.count % 3 == 0) {
            lastLie = 3;
        } else {
            lastLie = nameArr.count%3;
        }
        
        for (int j = 0; j < 3; j++) {
            if (i == 0 && j < 2) {
                //添加竖线
                [superView addSubview:[self getLineView:CGRectMake(WW*(j+1), 0, 0.5, HH*hang)]];
            }
            if (i == hang-1 && j == lastLie) {
                return;
            }
            MLMyButton *but = [[MLMyButton alloc] initWithFrame:CGRectMake(j*WW, i*HH, WW, HH) withText:nameArr[num] withImgStr:imgArr[num]];
            but.tag = butTag;
            
            [but addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
            [superView addSubview:but];
            butTag++;
            num++;
        }
    }
}

//得到统一的分割线视图
- (UIView *)getLineView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = RGB(85, 85, 85);
    view.alpha = 0.25;
    return view;
}

#pragma mark - UI

- (MLMyShangView *)shangView
{
    if (!_shangView) {
        _shangView = [[MLMyShangView alloc] initWithFrame:CGRectMake(0, 0, widths, 90)];
    }
    return _shangView;
}

- (BaseLayerView *)myView
{
    if (!_myView) {
        _myView = [[BaseLayerView alloc] init];
    }
    return _myView;
}

- (UILabel *)lable
{
    if (!_lable) {
        NSString *str = [CommenUtil LocalizedString:@"Me.MyApplication"];
        float w = [CommenUtil getWidthWithContent:str height:50 font:16];
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.shangView.frame), w, 50)];
        _lable.text = str;
        _lable.textColor = RGB(85, 85, 85);
        _lable.font = FT(16);
        _lable.alpha = 0.5;
    }
    return _lable;
}

- (UIView *)xianView
{
    if (!_xianView) {
        _xianView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lable.frame)+10, CGRectGetMinY(self.lable.frame)+CGRectGetHeight(self.lable.frame)/2, widths-CGRectGetMaxX(self.lable.frame)-10-15, 0.5)];
        _xianView.backgroundColor = RGB(85, 85, 85);
        _xianView.alpha = 0.25;
    }
    return _xianView;
}

- (BaseLayerView *)myView2
{
    if (!_myView2) {
        _myView2 = [[BaseLayerView alloc] init];
    }
    return _myView2;
}

- (UILabel *)lable2
{
    if (!_lable2) {
        NSString *str = [CommenUtil LocalizedString:@"Me.ThirdService"];
        float w = [CommenUtil getWidthWithContent:str height:50 font:16];
        _lable2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.myView.frame), w, 50)];
        _lable2.text = str;
        _lable2.textColor = RGB(85, 85, 85);
        _lable2.font = FT(16);
        _lable2.alpha = 0.5;
    }
    return _lable2;
}

- (UIView *)xianView2
{
    if (!_xianView2) {
        _xianView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lable2.frame)+10, CGRectGetMinY(self.lable2.frame)+CGRectGetHeight(self.lable2.frame)/2, widths-CGRectGetMaxX(self.lable2.frame)-10-15, 0.5)];
        _xianView2.backgroundColor = RGB(85, 85, 85);
        _xianView2.alpha = 0.25;
    }
    return _xianView2;
}

- (void)onAction:(UIButton *)sender
{
    MLMyViewController *myVC = (MLMyViewController *)self.viewController;
    if (!isShanghu) {
        switch (sender.tag) {
            case 1:
                [myVC.navigationController pushViewController:[[MLMyAssetsViewController alloc] init] animated:YES];
                break;
            case 2:
                [myVC.navigationController pushViewController:[[MLBillViewController alloc] init] animated:YES];
                break;
            case 3:
                [myVC.navigationController pushViewController:[[MLAccountInformationViewController alloc] init] animated:YES];
                break;
            case 4:
                [myVC.navigationController pushViewController:[[MLMationAuthenticationViewController alloc] init] animated:YES];
                break;
            case 5:
                [myVC.navigationController pushViewController:[[MLMyAgentViewController alloc] init] animated:YES];
                break;
            case 6:
                [myVC.navigationController pushViewController:[[MLAccountSettlementViewController alloc] init] animated:YES];
                break;
            case 7:
                [self isElectronic];
                break;
            case 8:
                [myVC.navigationController pushViewController:[[MerchantsViewController alloc] init] animated:YES];
                break;
            case 9:
                [myVC.navigationController pushViewController:[[FenRunViewController alloc] init] animated:YES];
                break;
            case 10:
                [myVC.navigationController pushViewController:[[InternationalViewController alloc] init] animated:YES];
                break;
            default:
                break;
        }
    } else {
        switch (sender.tag) {
            case 1:
                [myVC.navigationController pushViewController:[[MLMyAssetsViewController alloc] init] animated:YES];
                break;
            case 2:
                [myVC.navigationController pushViewController:[[MLBillViewController alloc] init] animated:YES];
                break;
            case 3:
                [myVC.navigationController pushViewController:[[MLAccountInformationViewController alloc] init] animated:YES];
                break;
            case 4:
                [myVC.navigationController pushViewController:[[MLMationAuthenticationViewController alloc] init] animated:YES];
                break;
            case 5:
                [myVC.navigationController pushViewController:[[MLMyAgentViewController alloc] init] animated:YES];
                break;
            case 6:
                [myVC.navigationController pushViewController:[[MLAccountSettlementViewController alloc] init] animated:YES];
                break;
            case 7:
                [self isElectronic];
                break;
            case 8:
                [myVC.navigationController pushViewController:[[MerchantsViewController alloc] init] animated:YES];
                break;
            case 9:
                [myVC.navigationController pushViewController:[[InternationalViewController alloc] init] animated:YES];
                break;
            default:
                break;
        }
    }
}

//查询电子账户
- (void)isElectronic
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:cmbc_accountURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"status"] isEqual:@1]) {
            MLElectornicYesViewController *eleVC = [[MLElectornicYesViewController alloc] init];
            eleVC.eleStr = responseObject[@"data"][0][@"cmbc_account"];
            [self.viewController.navigationController pushViewController:eleVC animated:YES];
        } else {
            [self.viewController.navigationController pushViewController:[[MLElectronicNotViewController alloc] init] animated:YES];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}



@end













