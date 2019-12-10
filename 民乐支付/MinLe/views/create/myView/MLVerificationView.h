//
//  MLVerificationView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/14.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLMinLeTextField.h"

@interface MLVerificationView : UIView

@property (nonatomic, strong) MLMinLeTextField *phoneTextField;//手机号输入框
@property (nonatomic, strong) MLMinLeTextField *verificationTextField;//验证码输入框
@property (nonatomic, strong) UIButton *but;//获取验证码
@property (nonatomic, strong) UILabel *lable;

@property (nonatomic, strong) NSString *countryName;//国家名字
@property (nonatomic, strong) NSString *countryCode;//国家区号
@property (nonatomic, strong) NSString *countryIcon;//国家code

@end
