//
//  VETCountry.m
//  MobileVoip
//
//  Created by Liu Yang on 03/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCountry.h"

@implementation VETCountry

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.code = [self pubNewKey:[aDecoder decodeObjectForKey:@"code"]];
        self.shouzimu = [self pubNewKey:[aDecoder decodeObjectForKey:@"shouzimu"]];
        self.icon = [self pubNewKey:[aDecoder decodeObjectForKey:@"icon"]];
        self.pinyin = [self pubNewKey:[aDecoder decodeObjectForKey:@"pinyin"]];
        self.countryChineseName = [self pubNewKey:[aDecoder decodeObjectForKey:@"countryChineseName"]];
        self.countryEnglishName = [self pubNewKey:[aDecoder decodeObjectForKey:@"countryEnglishName"]];
        self.searchText = [self pubNewKey:[aDecoder decodeObjectForKey:@"searchText"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.shouzimu forKey:@"shouzimu"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.pinyin forKey:@"pinyin"];
    [aCoder encodeObject:self.countryChineseName forKey:@"countryChineseName"];
    [aCoder encodeObject:self.countryEnglishName forKey:@"countryEnglishName"];
    [aCoder encodeObject:self.searchText forKey:@"searchText"];
}

- (instancetype)initWithCode:(NSString *)code shouzimu:(NSString *)shouzimu icon:(NSString *)icon pinyin:(NSString *)pinyin countryEnglishName:(NSString *)countryEnglishName countryChineseName:(NSString *)countryChineseName
{
    if (self = [super init]) {
        // 去除开头的00
        if ([code hasPrefix:@"00"]) {
            _code = [self pubNewKey:[code substringFromIndex:2]];
        }
        else if ([code hasPrefix:@"0"]) {
            _code = [self pubNewKey:[code substringFromIndex:1]];
        }
        else {
            _code = [self pubNewKey:code];
        }
        _shouzimu = [self pubNewKey:shouzimu];
        _icon = [self pubNewKey:icon];
        _pinyin = [self pubNewKey:pinyin];
        _countryChineseName = [self pubNewKey:countryChineseName];
        _countryEnglishName = [self pubNewKey:countryEnglishName];
        _searchText = [NSString stringWithFormat:@"%@%@", _code, _countryEnglishName];
    }
    return self;
}

- (instancetype)initWithCode:(NSString *)code
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)pubNewKey:(NSString *)key
{
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    return key;
}

@end
