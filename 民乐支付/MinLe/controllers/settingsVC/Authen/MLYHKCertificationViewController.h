//
//  MLYHKCertificationViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@interface MLYHKCertificationViewController : BaseViewController

@property (nonatomic, strong) NSString *isPopRoot;//是否返回到首页 1,返回 0,不返回

@property (nonatomic, strong) NSString *ccStr;
@property (nonatomic, strong) NSString *bankStr;

@property (nonatomic, strong) NSString *yhkChangeType; //1代表从结算账户过来 0为默认状态

@property (nonatomic, assign) BOOL isPeopleCertification;//是否是从资质认证界面过来的 YES 是的

@end
