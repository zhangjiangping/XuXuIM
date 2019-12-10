//
//  MLRegisterView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/7.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLMinLeTextField.h"

@interface MLRegisterView : UIView

@property (nonatomic, strong) MLMinLeTextField *phoneTextField;//手机号输入框
@property (nonatomic, strong) MLMinLeTextField *verificationTextField;//验证码输入框
@property (nonatomic, strong) UIButton *tureBut;//是否同意协议
@property (nonatomic, strong) UIButton *gouBut;//服务协议
@property (nonatomic, strong) UIButton *but;//获取验证码
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) MLMinLeTextField *textField_DLS;//代理商编号输入框
@property (nonatomic, strong) MLMinLeTextField *textField_DLMM;//登录密码输入框
@property (nonatomic, strong) MLMinLeTextField *textField_TMM;//确认密码输入框

@property (nonatomic, strong) NSString *countryName;//国家名字
@property (nonatomic, strong) NSString *countryCode;//国家区号
@property (nonatomic, strong) NSString *countryIcon;//国家code

@end
