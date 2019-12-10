//
//  DataModel.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Data;
@interface DataModel : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *info_status;
@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSString *today;
@property (nonatomic, strong) NSString *yesterday;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *money;

@property (nonatomic, strong) NSArray <Data *> *dataArray;

@end
