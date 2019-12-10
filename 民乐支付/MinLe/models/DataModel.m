//
//  DataModel.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/22.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "DataModel.h"
#import "Data.h"


@implementation DataModel

- (NSArray<Data *> *)dataArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.data) {
        Data *model = [Data modelWithDictionary:dic];
        [array addObject:model];
    }
    return array;
}

@end
