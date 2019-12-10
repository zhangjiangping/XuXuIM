//
//  VETSearchAreaCodeHelper.h
//  MobileVoip
//
//  Created by Liu Yang on 24/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETCountryCode : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *shouzimu;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *countryChineseName;
@property (nonatomic, copy) NSString *countryEnglishName;

@end

@interface VETAreaCode : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *mobileOperator;

@end

@interface VETSearchAreaCodeManager : NSObject

// YES表示已设置AreaCode，即非虚拟帐户
@property (nonatomic, assign, readonly, getter=isSettedAreaCodeFlag) BOOL settedAreaCodeFlag;

+ (VETSearchAreaCodeManager *)sharedInstance;
- (void)searchAreaCode:(NSString *)inputNumber completion:(void (^) (VETAreaCode *))block;

// 如果已经设置AreaCode不需要重复搜索
- (void)removeSettingAreaCode;

@end
