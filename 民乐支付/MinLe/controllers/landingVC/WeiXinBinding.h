//
//  WeiXinBinding.h
//  民乐支付
//
//  Created by JP on 2017/8/23.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BindingDelegate <NSObject>

- (void)hide;

- (void)bindingLogin;

@end

@interface WeiXinBinding : UIView

- (instancetype)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dic;

@property (nonatomic, weak) id <BindingDelegate> delegate;

@end
