//
//  MLChangeNameViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/26.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ChangeBlock)(NSString *name);

@interface MLChangeNameViewController : BaseViewController

@property (nonatomic, strong) UIButton *nameBut;

@property (nonatomic, copy) ChangeBlock block;

@end
