//
//  MLQrCodeViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@interface MLQrCodeViewController : BaseViewController
@property (nonatomic, strong) NSString *dingdanhao;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *imgStr;//二维码图片路劲
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *tType;//判断是T0还是T1收款
@property (nonatomic, strong) NSString *tiaourl;//条形码图片路劲
@end
