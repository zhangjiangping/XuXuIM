//
//  MLNoCardRegisterView.h
//  minlePay
//
//  Created by JP on 2017/10/16.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "BaseLayerView.h"
#import "MLMinLeTextField.h"

@interface MLNoCardRegisterView : BaseLayerView

@property (nonatomic, strong) MLMinLeTextField *phoneNumberTextField;//手机号码
@property (nonatomic, strong) MLMinLeTextField *openCardNumberTextField;//开通快捷的贷记卡卡号

@end
