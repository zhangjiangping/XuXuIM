//
//  MLWithdrawalView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/31.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseLayerView.h"
#import "MLCustomTextField.h"

@interface MLWithdrawalView : BaseLayerView

@property (nonatomic, strong) UILabel *balanceLable;//当前余额
@property (nonatomic, strong) UIButton *allBut;//全部提现
@property (nonatomic, strong) MLCustomTextField *moneyTextField;//提现金额
@property (nonatomic, strong) UILabel *yhLable;//银行

@end
