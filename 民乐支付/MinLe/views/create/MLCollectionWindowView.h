//
//  MLCollectionWindowView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/1.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLayerView.h"

@protocol DidSelectedDelegate <NSObject>

- (void)didSelectedWithType:(NSString *)type withTTtype:(NSString *)tType;

@end

@interface MLCollectionWindowView : UIView
@property (nonatomic, strong) BaseLayerView *layerView;
@property (nonatomic, strong) UILabel *moneyLable;
@property (nonatomic, strong) UIButton *cancelBut;

- (void)updataTableView:(NSArray *)dataArray withType:(NSString *)type;

@property (nonatomic, weak) id <DidSelectedDelegate> delegate;

- (void)show;

- (void)hiden;

@end
