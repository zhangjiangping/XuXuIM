//
//  CCUtity.m
//  iCar
//
//  Created by 邱宝剑 on 16/1/6.
//  Copyright © 2016年 Zh. All rights reserved.
//

#import "CCUtity.h"

@implementation CCUtity


/**
 *  转换成string
 */
+ (NSString *)getString:(id)string
{
    if (string  && ![string isKindOfClass:[NSNull class]]) {
        return [NSString stringWithFormat:@"%@",string];
    }
    return @"";
}
/**
 *  转换成array
 */
+ (NSArray *)getArray:(id)array
{
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array;
    }
    
    return @[];
}
/**
 *  转换成Dictionary
 */
+ (NSDictionary *)getDictionary:(id)dic
{
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }
    return @{};
}

/**
 *  转换成json
 */
+ (NSDictionary *)requestJSONOfDictionary:(id)response
{
    NSError *error;
//    NSLog(@"%@",response);
    if ([response isKindOfClass:[NSDictionary class]]) {
        return response;
    }
    if (![response isKindOfClass:[NSData class]]) {
        return @{};
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"111111%@",error);
    return dic;
}

/**
 *  转换成json
 */
+ (NSArray *)requestJSONOfarray:(id)response
{
    if ([response isKindOfClass:[NSArray class]]) {
        return response;
    }
    if (![response isKindOfClass:[NSData class]]) {
        return @[];
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    return array;
}

/**
 *  判断返回数据是否为空
 */
+ (BOOL)requestJSONIsNotNil:(id)response
{
    if (response && ![response isKindOfClass:[NSError class]]) {
        return YES;
    }else{
        return NO;
    }
}
@end
