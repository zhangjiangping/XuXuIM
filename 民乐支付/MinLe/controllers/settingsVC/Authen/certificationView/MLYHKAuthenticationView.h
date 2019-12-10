//
//  MLYHKAuthenticationView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayerView.h"
#import "MLMinLeTextField.h"
#import "CertificationView.h"

@protocol CertificationYHKProtocol <NSObject>

- (void)selectedEnder;

@end

@interface MLYHKAuthenticationView : BaseLayerView
@property (nonatomic, strong) MLMinLeTextField *textField_LHH;//联行号
@property (nonatomic, strong) MLMinLeTextField *nameTextField;//开户姓名
@property (nonatomic, strong) MLMinLeTextField *haomaTextField;//预留手机
@property (nonatomic, strong) UIButton *kaihuYHBut;//开户银行选择器
@property (nonatomic, strong) UIButton *ccBut;//城市选择
@property (nonatomic, strong) UIButton *yhzhBut;//支行输入框
@property (nonatomic, strong) UIButton *gerenBut;//个人账户是否选中
@property (nonatomic, strong) UIButton *gongsiBut;//公司账户是否选中

@property (nonatomic, strong) UILabel *yinhangNameLable;
@property (nonatomic, strong) UILabel *cityNameLable;
@property (nonatomic, strong) UILabel *zhihangNameLable;

@property (nonatomic, strong) CertificationView *cerYHKView;//银行卡识别视图
@property (nonatomic, strong) MLMinLeTextField *cardNumberTextField;//卡号框

@property (nonatomic, weak) id <CertificationYHKProtocol> yhkDelegate;

@end
