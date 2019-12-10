//
//  BaseWebViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/10.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *urlStr;

@property (nonatomic, strong) NSString *isRoot;//是否返回到首页

@property (nonatomic, assign) BOOL isHtml;
@property (nonatomic, strong) NSString *htmlDataString;

@end
