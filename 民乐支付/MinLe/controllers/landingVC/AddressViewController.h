//
//  AddressViewController.h
//  AddressDemo
//
//  Created by 张武星 on 15/5/29.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#define kDisplayProvince 0
#define kDisplayCity 1
#define kDisplayArea 2

typedef void(^CityBlock)(NSDictionary *dic);

@interface AddressViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int displayType;
@property(nonatomic,strong)NSArray *provinces;
@property(nonatomic,strong)NSArray *citys;
@property(nonatomic,strong)NSArray *areas;
@property(nonatomic,strong)NSString *selectedProvince;//选中的省
@property(nonatomic,strong)NSString *selectedCity;//选中的市
@property(nonatomic,strong)NSString *selectedArea;//选中的区

@property (nonatomic) CityBlock block;

@end
