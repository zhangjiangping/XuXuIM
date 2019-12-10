//
//  MLNoCardCodeView.h
//  minlePay
//
//  Created by JP on 2017/11/9.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "BaseLayerView.h"
#import "MLMinLeTextField.h"

@interface MLNoCardCodeView : BaseLayerView

@property (nonatomic, strong) MLMinLeTextField *orderTradingMoneyTextField;//订单交易金额
@property (nonatomic, strong) MLMinLeTextField *cardNameTextField;//结算卡姓名
@property (nonatomic, strong) MLMinLeTextField *haomaTextField;//身份证号码
@property (nonatomic, strong) MLMinLeTextField *settlementBorrowTextField;//结算借记卡卡号
@property (nonatomic, strong) MLMinLeTextField *phoneNumberTextField;//手机号
@property (nonatomic, strong) MLMinLeTextField *smsCodeTextField;//短信验证码

@property (nonatomic, strong) UILabel *smsCodeLable;//获取短信按钮
@property (nonatomic, strong) UIButton *smsCodeBut;//获取短信按钮

@end
