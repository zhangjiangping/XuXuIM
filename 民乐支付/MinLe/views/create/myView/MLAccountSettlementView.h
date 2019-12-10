//
//  MLAccountSettlementView.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseLayerView.h"

@interface MLAccountSettlementView : BaseLayerView
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *myArray;

@property (nonatomic, strong) NSString *type;

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray;

- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type withDataArray:(NSArray *)dataArray;

@end
