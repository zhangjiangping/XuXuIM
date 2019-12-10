//
//  MLValidationAuditsViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/26.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@interface MLValidationAuditsViewController : BaseViewController

@property (nonatomic, strong) NSString *statusStr;

@property (nonatomic, strong) NSString *isPopRoot;//是否返回到首页 1,返回 0,不返回

@property (nonatomic, strong) NSString *status;//1实名过来 2资质认证 3 银行卡认证

@end
