//
//  MLNOCardViewController.h
//  minlePay
//
//  Created by JP on 2017/10/16.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

//无卡模块的两种状态
typedef NS_ENUM(NSUInteger, NoCardState) {
    NoCardBigState = 0,/**< 无卡大额(10元-5万) */
    NoCardSmallState = 1 /**< 无卡小额(10元-2万) */
};

@interface MLNOCardViewController : BaseViewController

@property (nonatomic, assign) NoCardState state;

@end
