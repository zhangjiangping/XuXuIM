//
//  VETCodecInfo.m
//  minlePay
//
//  Created by JP on 2018/1/15.
//  Copyright © 2018年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "VETCodecInfo.h"

@implementation VETCodecInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.codecId = [aDecoder decodeObjectForKey:@"codecId"];
        self.priority = [aDecoder decodeObjectForKey:@"priority"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.codecId forKey:@"codecId"];
    [aCoder encodeObject:self.priority forKey:@"priority"];
}

- (instancetype)initWithCodecId:(NSString *)codecId priority:(NSUInteger)priority
{
    if (self == [super init]) {
        _codecId = codecId;
        _priority = [NSNumber numberWithInteger:priority];
    }
    return self;
}

@end
