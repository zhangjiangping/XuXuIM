//
//  MLQrDetailViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@interface MLQrDetailViewController : BaseViewController

@property (nonatomic, strong) NSString *order_num;
@property (nonatomic, strong) NSString *money;

@property (nonatomic, assign) BOOL isSaomiao;

@property (nonatomic, strong) NSDictionary *detailDataDic;//扫描收款过来的订单详情数据

@end
