//
//  BaseViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"
#import "MLLandingViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(245, 246, 249);
    //避免tableView顶部留白问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    //禁止屏幕侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //默认白色
    [self changebarWhiteStyle:YES];
    [self setUI];
}

////这个方法会通知系统去调用当前UIViewController的preferredStatusBarStyle方法 写在父类 避免每次调用
//- (void)setNeedsStatusBarAppearanceUpdate
//{
//    [self preferredStatusBarStyle];
//}

- (UILabel *)backGroundEmptyLable
{
    if (!_backGroundEmptyLable) {
        _backGroundEmptyLable = [[UILabel alloc] initWithFrame:CGRectMake(15, (screenHeight-64-50)/2, screenWidth-30, 50)];
        //_backGroundEmptyLable.backgroundColor = RGB(241, 241, 241);
        _backGroundEmptyLable.font = [UIFont boldSystemFontOfSize:18];
        _backGroundEmptyLable.numberOfLines = 0;
        _backGroundEmptyLable.textAlignment = NSTextAlignmentCenter;
    }
    return _backGroundEmptyLable;
}

- (BOOL)prefersStatusBarHidden
{
    if (self.isBarHiden) {
        return YES;
    } else {
        return NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.isWriteBar) {
        return UIStatusBarStyleLightContent;//状态栏颜色
    } else {
        return UIStatusBarStyleDefault;//状态栏颜色
    }
}

//改变状态栏的颜色
- (void)changebarWhiteStyle:(BOOL)isWrite
{
    self.isWriteBar = isWrite;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setUI
{
    //子类重写
}

// 点击空白处隐藏键盘 也可用作其他
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)hideKeyBorad
{
    [self.view endEditing:YES];
}

- (CGFloat)onRect:(NSString *)text withWidth:(CGFloat)w
{
    CGRect rect;
    //获取文字高度
    rect = [text boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil];
    return rect.size.height;
}

//计算高度
- (CGSize)setTextHeight:(UILabel *)label textW:(CGFloat)textW
{
    CGSize size = CGSizeMake(textW, 0);
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    CGSize retSize = [label.text boundingRectWithSize:size
                                              options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    
    return retSize;
}

- (void)showAleartVcWithTitle:(NSString *)title withMessage:(NSString *)message withActionTitle:(NSString *)actionTitle
{
    UIAlertController *atCL = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [atCL addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [atCL dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:atCL animated:YES completion:nil];
}

- (void)showAleartVcWithTitle:(NSString *)title withMessage:(NSString *)message withTureBlock:(void(^)())tureBlock withCancelBlock:(void(^)())cancelBlock
{
    UIAlertController *atCL = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [atCL addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Ture"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [atCL dismissViewControllerAnimated:YES completion:nil];
        if (tureBlock) {
            tureBlock();
        }
    }]];
    [atCL addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Cancle"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [atCL dismissViewControllerAnimated:YES completion:nil];
        if (cancelBlock) {
            cancelBlock();
        }
    }]];
    [self presentViewController:atCL animated:YES completion:nil];
}

//公用弹出提醒框
- (void)showAleartView:(NSString *)message
{
    UIAlertController *atCL = [UIAlertController alertControllerWithTitle:[CommenUtil LocalizedString:@"Common.Prompt"] message:message preferredStyle:UIAlertControllerStyleAlert];
    [atCL addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Know"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:atCL animated:YES completion:nil];
}

//关闭导航栏的显示（并没有隐藏）
- (void)offNavigationBarAlpha
{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

//打开导航栏的显示
- (void)openNavigationBarAlpha
{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

//显示导航栏的时候 隐藏导航栏的透明度
- (void)hideNavigationBarColor
{
    //self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundColor:blueRGB];
}

- (UIView *)getLineViewWithRect:(CGRect)rect
{
    UIView *lineV = [[UIView alloc] initWithFrame:rect];
    lineV.backgroundColor = [UIColor lightGrayColor];
    lineV.alpha = 0.5;
    return lineV;
}

- (void)saveInformationUserDefaults:(NSDictionary *)responseObject withIsLogin:(BOOL)isLogin
{
    NSDictionary *dic = [NSDictionary dictionary];
    if (isLogin) {
        dic = responseObject[@"data"][0];
    } else {
        dic = responseObject;
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"uid"] forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"phone"] forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"part_phone"] forKey:@"part_phone"];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"type"] forKey:@"type"];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"prefix"] forKey:Country_Code];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"voip_user"] forKey:VOIP_USERNAME];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"voip_pass"] forKey:VOIP_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VOIP_USERNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VOIP_PASSWORD];
    [SharedApp setupRootViewController:[[MLLandingViewController alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
