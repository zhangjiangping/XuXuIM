//
//  MLNameAuthenticationViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@interface MLNameAuthenticationViewController : BaseViewController

@property (nonatomic, strong) NSString *isPopRoot;//是否返回到首页 1,返回 0,不返回

@property (nonatomic, assign) BOOL isRegister;//是否是从注册界面过来的 YES 是的

@end
