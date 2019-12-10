//
//  MLQrCodeViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLQrCodeViewController.h"
#import "UIImageView+MyImageView.h"
#import "BaseLayerView.h"
#import "MLQrDetailViewController.h"
#import "SoundUtil.h"

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSUInteger, TimeState){
    TimeStateLoading = 0,/**< 等待收款中 */
    TimeStateFailure = 1,/**< 收款失败 */
    TimeStateSuccess = 2,/**< 收款成功 */
};

@interface MLQrCodeViewController ()
{
    TimeState timeState;//用来标示是否去请求
    NSTimer *time;
    NSInteger timeNum;//计时器累加常量记录
}
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UIImageView *img;//二维码图片
@property (nonatomic, strong) UIImageView *tiaoImg;//条形码图片
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UIView *xianView1;
@property (nonatomic, strong) UIView *xianView2;

@property (nonatomic, strong) UIButton *rightBut;

@end

@implementation MLQrCodeViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    timeState = TimeStateLoading;
    timeNum = 0;
    [time invalidate];
    time = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加极光推送自定义通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveJPushMessage:)name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)setUI
{
    timeState = TimeStateLoading;
    timeNum = 0;
    [self.view addSubview:self.naView];
    [self.view addSubview:self.layerView];
    
    [self addTime];
}

//点击查询是否收款成功
- (void)queryAction
{
    [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"query..."] showView:nil];
    [self timerAction];
    [self addTime];
}

//接受到服务器发送过来推送消息
- (void)didReceiveJPushMessage:(NSNotification *)noti
{
    /*
     返回字段
     {
     content = "\U4fe1\U606f";
     "content_type" = 2;
     extras =     {
     "push_content" =         {
     merchantSeq = ML201708021705441217;
     remark = "\U652f\U4ed8\U6210\U529f";
     tradeStatus = S;
     };
     "push_type" = pay;
     };
     title = "";
     }
     */
    NSDictionary *dic = noti.userInfo;
    NSLog(@"%@",dic);
    NSDictionary *extraDic = [dic valueForKey:@"extras"];
    //判断是不是付款
    if ([extraDic[@"push_type"] isEqualToString:@"pay"]) {
        NSDictionary *contentDic = extraDic[@"push_content"];
        //判断订单号是否一样
        if ([contentDic[@"merchantSeq"] isEqualToString:self.dingdanhao]) {
            NSString *stateStr = contentDic[@"tradeStatus"];
            //判断付款状态是否成功
            if ([stateStr isEqualToString:@"S"]) {
                [self pushDetailVc];
            }
        } 
    }
}

//添加页面停留计时器
- (void)addTime
{
    if (!time) {
        time = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timePlay) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
        [time fire];
    }
}

//扫描二维码提示成功方法
- (void)timerAction
{
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *urlStr = [NSString string];
    if ([self.tType isEqualToString:@"T0"]) {
        urlStr = t0checkURL;
        dic = @{@"order_num":self.dingdanhao,@"token":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]};
    } else {
        urlStr = checkURL;
        dic = @{@"order_num":self.dingdanhao};
    }
    [[MCNetWorking sharedInstance] myPostWithUrlString:urlStr withParameter:dic withComplection:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@1]) {
            NSString *tradeStatus = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"tradeStatus"]];
            if ([tradeStatus isEqualToString:@"S"]) {
                timeState = TimeStateSuccess;
                [self pushDetailVc];
            } else {
                [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Collection.OrderNotPay"] showView:nil];
            }
        } else {
            [[MBProgressHUD shareInstance] ShowMessage:responseObject[@"msg"] showView:nil];
        }
    } withFailure:^(NSError *error) {
        [[MBProgressHUD shareInstance] ShowMessage:[CommenUtil LocalizedString:@"Common.NetworkAbnormal"] showView:nil];
        NSLog(@"%@",error);
    }];
}

//计时器方法
- (void)timePlay
{
    timeNum++;
    if (timeNum > 300) {
        NSLog(@"%ld",(long)timeNum);
        timeNum = 0;
        [time invalidate];
        time = nil;
        timeState = TimeStateFailure;
        
        UIAlertController *atCL = [UIAlertController alertControllerWithTitle:nil message:[CommenUtil LocalizedString:@"Collection.PayOvertime"] preferredStyle:UIAlertControllerStyleAlert];
        [atCL addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Ture"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [atCL dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:atCL animated:YES completion:nil];
    } else if (timeNum > 15) {
        if (!_rightBut.isEnabled) {
            _rightBut.enabled = YES;
            _rightBut.alpha = 1;
        }
    }
}

//跳转收款成功界面
- (void)pushDetailVc
{
    [[SoundUtil sharedInstance] playSound];
    
    MLQrDetailViewController *detailVC = [[MLQrDetailViewController alloc] init];
    detailVC.order_num = self.dingdanhao;
    detailVC.money = self.money;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UI

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 264) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Home.Collection"]];
        _naView.backgroundColor = RGB(255, 169, 0);
        
        [_naView addSubview:self.rightBut];
    }
    return _naView;
}

- (UIButton *)rightBut
{
    if (!_rightBut) {
        _rightBut = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightBut.frame = CGRectMake(CGRectGetWidth(self.naView.frame)-100, 16, 100, 46);
        [_rightBut setTitle:[CommenUtil LocalizedString:@"Collection.Query"] forState:UIControlStateNormal];
        [_rightBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightBut.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [_rightBut addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
        _rightBut.titleLabel.font = FT(17);
        _rightBut.alpha = 0.5;
        _rightBut.enabled = NO;
    }
    return _rightBut;
}

- (BaseLayerView *)layerView
{
    if (!_layerView) {
        _layerView = [[BaseLayerView alloc] initWithFrame:CGRectMake(15, 64, widthss-30, 479)];
        [_layerView addSubview:self.img];
        [_layerView addSubview:self.tiaoImg];
        [_layerView addSubview:self.nameLable];
        [_layerView addSubview:self.moneyLable];
        [_layerView addSubview:self.xianView1];
        [_layerView addSubview:self.xianView2];
    }
    return _layerView;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.layerView.frame)-259)/2, 20, 259, 259)];
        _img.clipsToBounds = YES;
        [_img setImageWithString:self.imgStr];
    }
    return _img;
}

- (UIView *)xianView1
{
    if (!_xianView1) {
        _xianView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 289, CGRectGetWidth(self.layerView.frame)-20, 0.5)];
        _xianView1.backgroundColor = [UIColor lightGrayColor];
        _xianView1.alpha = 0.5;
    }
    return _xianView1;
}

- (UIImageView *)tiaoImg
{
    if (!_tiaoImg) {
        _tiaoImg = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.layerView.frame)-289)/2, 309, 289, 100)];
        _tiaoImg.clipsToBounds = YES;
        NSLog(@"%@",self.tiaourl);
        [_tiaoImg setImageWithString:self.tiaourl];
    }
    return _tiaoImg;
}

- (UIView *)xianView2
{
    if (!_xianView2) {
        _xianView2 = [[UIView alloc] initWithFrame:CGRectMake(10, 429, CGRectGetWidth(self.layerView.frame)-20, 0.5)];
        _xianView2.backgroundColor = [UIColor lightGrayColor];
        _xianView2.alpha = 0.5;
    }
    return _xianView2;
}

- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.layerView.frame)-30, 100, 20)];
        _nameLable.alpha = 0.5;
        if ([self.type isEqualToString:@"API_ZFBQRCODE"] || [self.type isEqualToString:@"02"]) {
           _nameLable.text = [CommenUtil LocalizedString:@"Collection.ZFBPay"];
        } else if ([self.type isEqualToString:@"API_WXQRCODE"] || [self.type isEqualToString:@"01"]) {
            _nameLable.text = [CommenUtil LocalizedString:@"Collection.WXPay"];
        } else if ([self.type isEqualToString:@"API_QQQRCODE"]) {
            _nameLable.text = [CommenUtil LocalizedString:@"Collection.QQPay"];
        } else if ([self.type isEqualToString:@"API_JDQRCODE"]) {
            _nameLable.text = [CommenUtil LocalizedString:@"Collection.JDPay"];
        } else if ([self.type isEqualToString:@"API_BDQRCODE"]) {
            _nameLable.text = [CommenUtil LocalizedString:@"Collection.BDPay"];
        }
        _nameLable.font = [UIFont boldSystemFontOfSize:16];
    }
    return _nameLable;
}

- (UILabel *)moneyLable
{
    if (!_moneyLable) {
        _moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.layerView.frame)-110, CGRectGetHeight(self.layerView.frame)-30, 100, 20)];
        _moneyLable.font = [UIFont boldSystemFontOfSize:16];
        _moneyLable.textColor = RGB(255, 169, 0);
        _moneyLable.textAlignment = NSTextAlignmentRight;
        _moneyLable.text = [NSString stringWithFormat:@"%@%@",self.money,[CommenUtil LocalizedString:@"Common.Yuan"]];
    }
    return _moneyLable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
