//
//  BaseViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+XHPhoto.h"

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isBarHiden;//是否隐藏状态栏

@property (nonatomic, assign) BOOL isWriteBar;//是否要白色状态栏

@property (nonatomic, strong) UILabel *backGroundEmptyLable;//数据为空时背景显示

- (void)setUI;

- (void)hideKeyBorad;

- (void)logout;

//改变状态栏的颜色
- (void)changebarWhiteStyle:(BOOL)isWrite;

//关闭导航栏的显示（并没有隐藏）
- (void)offNavigationBarAlpha;

//打开导航栏的显示
- (void)openNavigationBarAlpha;

//显示导航栏的时候 隐藏导航栏的透明度
- (void)hideNavigationBarColor;

//添加分割线
- (UIView *)getLineViewWithRect:(CGRect)rect;

//获取文字高度
- (CGFloat)onRect:(NSString *)text withWidth:(CGFloat)w;

//计算lable高度
- (CGSize)setTextHeight:(UILabel *)label textW:(CGFloat)textW;

//弹出框
- (void)showAleartVcWithTitle:(NSString *)title withMessage:(NSString *)message withActionTitle:(NSString *)actionTitle;

//弹出框
- (void)showAleartVcWithTitle:(NSString *)title withMessage:(NSString *)message withTureBlock:(void(^)())tureBlock withCancelBlock:(void(^)())cancelBlock;

//公用弹出提醒框
- (void)showAleartView:(NSString *)message;

- (void)saveInformationUserDefaults:(NSDictionary *)responseObject withIsLogin:(BOOL)isLogin;

@end
