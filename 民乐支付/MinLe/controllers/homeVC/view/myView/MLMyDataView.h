//
//  MLMyDataView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/14.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLRegisterTextField.h"

@interface MLMyDataView : UIView
@property (nonatomic, strong) UIScrollView *dataView;//可移动视图
@property (nonatomic, strong) MLRegisterTextField *textField_JC;//商户简称输入框
@property (nonatomic, strong) MLRegisterTextField *textField_QC;//商户全称输入框
@property (nonatomic, strong) MLRegisterTextField *textField_FR;//法人信息输入框
@property (nonatomic, strong) MLRegisterTextField *textField_SFZH;//身份证号输入框
@property (nonatomic, strong) MLRegisterTextField *textField_DLS;//代理商输入框
@property (nonatomic, strong) UIButton *kaihuYHBut;//开户银行选择器
@property (nonatomic, strong) UIButton *ccBut;//城市选择
@property (nonatomic, strong) MLRegisterTextField *textField_YHKH;//银行卡号输入框
@property (nonatomic, strong) MLRegisterTextField *textField_YHZH;//银行支行输入框
@property (nonatomic, strong) MLRegisterTextField *textField_DLMM;//登录密码输入框
@property (nonatomic, strong) MLRegisterTextField *textField_TMM;//确认密码输入框
@property (nonatomic, strong) MLRegisterTextField *textField_KHName;//开户名称
@property (nonatomic, strong) MLRegisterTextField *textField_Email;//民生电子账户
@property (nonatomic, strong) UIButton *gerenBut;//个人账户是否选中
@property (nonatomic, strong) UIButton *gongsiBut;//公司账户是否选中
@property (nonatomic, strong) UIButton *submitBut;//提交按钮

@property (nonatomic, strong) UILabel *yinhangNameLable;
@property (nonatomic, strong) UILabel *cityNameLable;

@end
