//
//  CCUtity.h
//  iCar
//
//  Created by 邱宝剑 on 16/1/6.
//  Copyright © 2016年 Zh. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CCUtity : NSObject

+ (NSString *)getString:(id)string;
/**
 *  转换成array
 */
+ (NSArray *)getArray:(id)array;
/**
 *  转换成Dictionary
 */
+ (NSDictionary *)getDictionary:(id)dic;

/**
 *  转换成json
 */
+ (NSDictionary *)requestJSONOfDictionary:(id)response;
/**
 *  转换成json
 */
+ (NSArray *)requestJSONOfarray:(id)response;

/**
 *  判断返回数据是否为空
 */
+ (BOOL)requestJSONIsNotNil:(id)response;

@end
