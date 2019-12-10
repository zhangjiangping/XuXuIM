//
//  MLCardRegisterViewController.h
//  minlePay
//
//  Created by JP on 2017/10/16.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "Data.h"

typedef void(^OrderBlock)(Data *data);

@interface MLCardRegisterViewController : BaseViewController

@property (nonatomic, copy) OrderBlock block;

@end
