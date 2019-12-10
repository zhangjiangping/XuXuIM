//
//  VETCountry.h
//  MobileVoip
//
//  Created by Liu Yang on 03/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VETCountry : NSObject <NSCoding>

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *shouzimu;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *countryEnglishName;
@property (nonatomic, copy) NSString *countryChineseName;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSString *sortText;

- (instancetype)initWithCode:(NSString *)code shouzimu:(NSString *)shouzimu icon:(NSString *)icon pinyin:(NSString *)pinyin countryEnglishName:(NSString *)countryEnglishName countryChineseName:(NSString *)countryChineseName;

@end
