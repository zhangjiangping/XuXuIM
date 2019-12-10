//
//  MLGoSaoMiaoViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/11.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

//跳转记录
typedef NS_ENUM(NSUInteger, PushState) {
    ElectornicPushState = 0, /** 电子账户跳转过来 */
    NoCardPushState = 1      /** 无卡模块跳转过来 */
};

@interface MLGoSaoMiaoViewController : BaseViewController

@property (nonatomic, assign) PushState state;

@property (nonatomic, assign) BOOL isPopRoot;

@end

