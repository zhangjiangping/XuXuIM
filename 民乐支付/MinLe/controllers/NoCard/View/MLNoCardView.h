//
//  MLNoCardView.h
//  minlePay
//
//  Created by JP on 2017/10/16.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "BaseLayerView.h"
#import "MLMinLeTextField.h"
#import "CertificationView.h"

@interface MLNoCardView : BaseLayerView

@property (nonatomic, strong) MLMinLeTextField *orderTradingMoneyTextField;//订单交易金额
@property (nonatomic, strong) MLMinLeTextField *cardNameTextField;//结算卡姓名
@property (nonatomic, strong) MLMinLeTextField *haomaTextField;//身份证号码
@property (nonatomic, strong) MLMinLeTextField *settlementBorrowTextField;//结算借记卡卡号
@property (nonatomic, strong) MLMinLeTextField *phoneNumberTextField;//手机号

@property (nonatomic, strong) UILabel *openOrderLable;//商户开卡订单号
@property (nonatomic, strong) UIButton *openOrderBut;//商户开卡订单号
@property (nonatomic, strong) UIButton *oneBut;//T1是否选中
@property (nonatomic, strong) UIButton *twoBut;//T0是否选中
@property (nonatomic, strong) UIImageView *oneImageView;
@property (nonatomic, strong) UIImageView *twoImageView;

- (void)selectedChannel:(BOOL)isT1;

@end
