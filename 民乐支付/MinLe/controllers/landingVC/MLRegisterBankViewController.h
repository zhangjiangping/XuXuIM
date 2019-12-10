//
//  MLRegisterBankViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/4.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^BankBlock)(NSDictionary *dic);

@interface MLRegisterBankViewController : BaseViewController


@property (nonatomic) BankBlock block;

@end
