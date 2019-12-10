//
//  VETCodecInfo.h
//  minlePay
//
//  Created by JP on 2018/1/15.
//  Copyright © 2018年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETCodecInfo : NSObject <NSCoding>

@property (nonatomic, retain) NSString *codecId;
@property (nonatomic, retain) NSNumber *priority;

- (instancetype)initWithCodecId:(NSString *)codecId priority:(NSUInteger)priority;

@end
