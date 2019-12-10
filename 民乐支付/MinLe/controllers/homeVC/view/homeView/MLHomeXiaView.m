//
//  MLHomeXiaView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/19.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLHomeXiaView.h"
#import "MLHomeButton.h"
#import "MLMyViewController.h"
#import "UIView+Responder.h"
#import "MLCollectionViewController.h"
#import "BaseLayerView.h"
#import "MLErWeiMaSuccessViewController.h"
#import "MLWhetherBindingViewController.h"
#import "BaseWebViewController.h"
#import "VETHistorySegmentViewController.h"
#import "MLNOCardViewController.h"
#import "MLHomeViewController.h"
#import "MLBillViewController.h"

#define wCount 2 //横向
#define hCount 2 //竖向

#define AccountLeftImgWH  24
#define AccountRightImgWH 18

@interface MLHomeXiaView ()
{
    NSArray *nameArray;
    NSArray *imgArray;
    CGFloat WW;
    CGFloat HH;
    float accountWidth;
    float accountHeight;
}
@property (nonatomic, strong) UILabel *lable;

//公告显示
@property (nonatomic, strong) UIView *accountView;
@property (nonatomic, strong) UILabel *accountLeftLable;
@property (nonatomic, strong) NSMutableArray *contentViewsDataArr;//公告视图数组
@property (nonatomic, strong) NSMutableArray *accountUrlArray;
@property (nonatomic, assign) NSInteger currentPageIndex;//记录当前滚动视图下标

//item显示
@property (nonatomic, strong) BaseLayerView *view;
@property (nonatomic, strong) MLHomeButton *myBut;
@property (nonatomic, strong) UIView *xianView;

@end

@implementation MLHomeXiaView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(245, 246, 249);
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            accountHeight = 40;
        } else {
            accountHeight = 58;
        }
        _contentViewsDataArr = [[NSMutableArray alloc] init];
        _accountUrlArray = [[NSMutableArray alloc] init];
        nameArray = @[[CommenUtil LocalizedString:@"Home.Collection"],
                      [CommenUtil LocalizedString:@"Home.QRCode"],
                      [CommenUtil LocalizedString:@"Home.Call"],
                      [CommenUtil LocalizedString:@"Home.Me"]];
        imgArray = @[@"QR-Pay",@"QRScan",@"icon-phone",@"Profile"];
        [self addSubview:self.accountView];
        [self addSubview:self.lable];
        [self addSubview:self.xianView];
        [self addSubview:self.view];
    }
    return self;
}

#pragma mark - Action

- (void)accountAction
{
    if (_accountUrlArray.count > 0) {
        NSDictionary *dic = _accountUrlArray[_currentPageIndex];
        BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] init];
        baseWebVC.titleStr = [CommenUtil LocalizedString:@"Center.Announcement"];
        baseWebVC.urlStr = [NSString stringWithFormat:@"%@/mid/%@/user/%@",detail_noticeURL,dic[@"mid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        [self.viewController.navigationController pushViewController:baseWebVC animated:YES];
    }
}

- (void)onAction:(UIButton *)sender
{
//    MLHomeViewController *homeVC = (MLHomeViewController *)self.viewController;
//    if (sender.tag == 1) {
//        [homeVC.navigationController pushViewController:[[MLCollectionViewController alloc] init] animated:YES];
//    } else if (sender.tag == 2) {
//        [self isErWeiMa];
//    } else if (sender.tag == 3) {
//        VETHistorySegmentViewController *callHistoryVC = [[VETHistorySegmentViewController alloc] init];
//        callHistoryVC.status = homeVC.status;
//        [homeVC.navigationController pushViewController:callHistoryVC animated:YES];
//    } else if (sender.tag == 4) {
//        [homeVC.navigationController pushViewController:[[MLBillViewController alloc] init] animated:YES];
//    } else if (sender.tag == 5) {
//        MLNOCardViewController *vc = [[MLNOCardViewController alloc] init];
//        vc.state = NoCardBigState;
//        [homeVC.navigationController pushViewController:vc animated:YES];
//    } else {
//        [homeVC.navigationController pushViewController:[[MLMyViewController alloc] init] animated:YES];
//    }
    MLHomeViewController *homeVC = (MLHomeViewController *)self.viewController;
    if (sender.tag == 1) {
        [homeVC.navigationController pushViewController:[[MLCollectionViewController alloc] init] animated:YES];
    } else if (sender.tag == 2) {
        [self isErWeiMa];
    } else if (sender.tag == 3) {
        VETHistorySegmentViewController *callHistoryVC = [[VETHistorySegmentViewController alloc] init];
        callHistoryVC.status = homeVC.status;
        [homeVC.navigationController pushViewController:callHistoryVC animated:YES];
    } else {
        [homeVC.navigationController pushViewController:[[MLMyViewController alloc] init] animated:YES];
    }
}

//查询二维码
- (void)isErWeiMa
{
    [[MCNetWorking sharedInstance] createPostWithUrlString:selectQRURL withParameter:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSArray *dataArray = responseObject[@"data"];
            MLErWeiMaSuccessViewController *erweimaVC = [[MLErWeiMaSuccessViewController alloc] init];
            erweimaVC.dataArray = dataArray;
            [self.viewController.navigationController pushViewController:erweimaVC animated:YES];
        } else {
            [self.viewController.navigationController pushViewController:[[MLWhetherBindingViewController alloc] init] animated:YES];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

//更新公告视图
- (void)updataView:(NSArray *)accountArray
{
    if (accountArray && accountArray > 0) {
        [_accountUrlArray removeAllObjects];
        [_accountUrlArray addObjectsFromArray:accountArray];
        
        [_contentViewsDataArr removeAllObjects];
        for (int i = 0; i < accountArray.count; i++) {
            NSDictionary *dic = accountArray[i];
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, accountWidth, accountHeight)];
            tempLabel.text            = [NSString stringWithFormat:@"%@",dic[@"title"]];
            tempLabel.font            = FT(14);
            [_contentViewsDataArr addObject:tempLabel];
        }
        [_accountScrollView reloadData];
    }
}

#pragma mark - LMJEndlessLoopScrollView Delegate
- (NSInteger)numberOfContentViewsInLoopScrollView:(LMJEndlessLoopScrollView *)loopScrollView
{
    if (_contentViewsDataArr.count > 0) {
        return _contentViewsDataArr.count;
    } else {
        return 1;
    }
}

- (UIView *)loopScrollView:(LMJEndlessLoopScrollView *)loopScrollView contentViewAtIndex:(NSInteger)index
{
    if (_contentViewsDataArr.count > 0) {
        return _contentViewsDataArr[index];
    } else {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, accountWidth, accountHeight)];
        tempLabel.text = @"";
        tempLabel.font = FT(14);
        return tempLabel;
    }
}

- (void)loopScrollView:(LMJEndlessLoopScrollView *)loopScrollView didSelectContentViewAtIndex:(NSInteger)index
{
    NSLog(@"点击哪个视图的下标：%ld",index);
    _currentPageIndex = index;
    [self accountAction];
}

- (void)loopScrollView:(LMJEndlessLoopScrollView *)loopScrollView currentContentViewAtIndex:(NSInteger)index
{
    _currentPageIndex = index;
    NSLog(@"当前滚动哪个视图的下标：%ld",_currentPageIndex);
}

#pragma mark - Getter

- (UIView *)accountView
{
    if (!_accountView) {
        _accountView = [[UIView alloc] init];
        _accountView.frame = CGRectMake(0, 10, widths, accountHeight);
        _accountView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, (accountHeight-AccountLeftImgWH)/2, AccountLeftImgWH, AccountLeftImgWH)];
        leftImg.clipsToBounds = YES;
        leftImg.image = [UIImage imageNamed:@"icon-information"];
        [_accountView addSubview:leftImg];
        
        float accLeftWidth = [CommenUtil getWidthWithContent:[CommenUtil LocalizedString:@"Home.NewAnnouncement"] height:accountHeight font:14];
        _accountLeftLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImg.frame)+15, 0, accLeftWidth, accountHeight)];
        _accountLeftLable.font = FT(14);
        _accountLeftLable.text = [CommenUtil LocalizedString:@"Home.NewAnnouncement"];
        [_accountView addSubview:_accountLeftLable];
        
        accountWidth = widths-15*2-AccountRightImgWH-CGRectGetMaxX(_accountLeftLable.frame);
        _accountScrollView = [[LMJEndlessLoopScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_accountLeftLable.frame), 0, accountWidth, accountHeight) animationScrollDuration:4.f withState:DirectionDownAndUpState];
        _accountScrollView.delegate = self;
        _accountScrollView.backgroundColor = [UIColor whiteColor];
        [_accountView addSubview:_accountScrollView];
        
        UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_accountScrollView.frame)+15, (accountHeight-AccountRightImgWH)/2, AccountRightImgWH, AccountRightImgWH)];
        rightImg.clipsToBounds = YES;
        rightImg.image = [UIImage imageNamed:@"icon--more"];
        [_accountView addSubview:rightImg];
    }
    return _accountView;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] init];
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            _lable.frame = CGRectMake(15, CGRectGetMaxY(self.accountView.frame), 80, 30);
            _lable.font = FT(16);
        } else {
            _lable.frame = CGRectMake(15, CGRectGetMaxY(self.accountView.frame), 80, 50);
            _lable.font = FT(18);
        }
        _lable.text = [CommenUtil LocalizedString:@"Home.SelectedService"];
        _lable.textColor = RGB(85, 85, 85);
        _lable.alpha = 0.5;
    }
    return _lable;
}

- (UIView *)xianView
{
    if (!_xianView) {
        _xianView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lable.frame)+5, CGRectGetMinY(self.lable.frame)+CGRectGetHeight(self.lable.frame)/2, widths-CGRectGetMaxX(self.lable.frame)-5-15, 0.5)];
        _xianView.backgroundColor = RGB(85, 85, 85);
        _xianView.alpha = 0.25;
    }
    return _xianView;
}

- (BaseLayerView *)view
{
    if (!_view) {
        _view = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.lable.frame), widths-30, heights-CGRectGetMaxY(self.lable.frame)-15)];
        WW = CGRectGetWidth(_view.frame)/wCount;
        HH = CGRectGetHeight(_view.frame)/hCount;
        int butTag = 1;
        BOOL isWLine = NO;
        for (int i = 0; i < wCount; i++) {
            for (int j = 0; j < hCount; j++) {
                MLHomeButton *but = [[MLHomeButton alloc] initWithFrame:CGRectMake(i*WW, j*HH, WW, HH) withText:nameArray[butTag-1] withImgStr:imgArray[butTag-1]];
                but.tag = butTag;
                [but addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
                butTag++;
                [_view addSubview:but];
                
                if (j > 0 && !isWLine) {
                    CGRect rect = CGRectMake(0, j*HH, CGRectGetWidth(_view.frame), 0.5);
                    [_view addSubview:[self getLineViewWithRect:rect]];
                    isWLine = YES;
                }
            }
            if (i > 0) {
                CGRect rect = CGRectMake(WW*i, 0, 0.5, CGRectGetHeight(self.view.frame));
                [_view addSubview:[self getLineViewWithRect:rect]];
            }
        }
    }
    return _view;
}

- (UIView *)getLineViewWithRect:(CGRect)rect
{
    UIView *lineV = [[UIView alloc] initWithFrame:rect];
    lineV.backgroundColor = [UIColor lightGrayColor];
    lineV.alpha = 0.5;
    return lineV;
}


@end









