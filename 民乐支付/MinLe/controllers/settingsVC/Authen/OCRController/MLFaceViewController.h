//
//  MLFaceViewController.h
//  民乐支付
//
//  Created by JP on 2017/7/28.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@interface MLFaceViewController : BaseViewController

@property (nonatomic, strong) NSString *isPopRoot;//是否返回到首页 1,返回 0,不返回

@property (nonatomic, assign) BOOL isRegister;//是否是从注册界面过来的 YES 是的

@property (nonatomic, strong) NSDictionary *dic;//实名认证接口要用的参数
@property (nonatomic, strong) NSArray *imgArray;//实名认证接口要用的参数

@end
