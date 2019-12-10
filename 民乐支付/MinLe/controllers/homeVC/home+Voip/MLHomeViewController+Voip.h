//
//  MLHomeViewController+Voip.h
//  minlePay
//
//  Created by JP on 2017/10/26.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLHomeViewController.h"

@interface MLHomeViewController (Voip) <VETVoipAccountDelegate>

//登录
- (void)loginVoip;

//释放
- (void)homeDealloc;

@end
