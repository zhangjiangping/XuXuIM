//
//  NSString+MyString.h
//  meituan
//
//  Created by Chris on 15/3/17.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyString)

- (NSString*)md532BitLower;

//手机型号
+ (NSString *)iphoneType;

//获取ip地址
+ (NSString *)getIpAddresses;

//验证手机号
+ (BOOL)isMobile:(NSString *)mobileNumbel;

+ (BOOL)isTwoPoint:(NSString *)text;

//获取当前时间
+ (NSString *)dataFormatter;

@end
