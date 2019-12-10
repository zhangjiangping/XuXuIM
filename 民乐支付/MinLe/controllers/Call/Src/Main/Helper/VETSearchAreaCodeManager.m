//
//  VETSearchAreaCodeHelper.m
//  MobileVoip
//
//  Created by Liu Yang on 24/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETSearchAreaCodeManager.h"

/***********************************************************
 *  VETCountryCode
 ***********************************************************/

@implementation VETCountryCode

- (instancetype)initWithCode:(NSString *)code shouzimu:(NSString *)shouzimu icon:(NSString *)icon pinyin:(NSString *)pinyin countryEnglishName:(NSString *)countryEnglishName countryChineseName:(NSString *)countryChineseName
{
    if (self = [super init]) {
        _code = code;
        _shouzimu = shouzimu;
        _icon = icon;
        _pinyin = pinyin;
        _countryChineseName = countryChineseName;
        _countryEnglishName = countryEnglishName;
    }
    return self;
}

@end

/***********************************************************
 *  VETAreaCode
 ***********************************************************/

@implementation VETAreaCode

- (instancetype)initWithCode:(NSString *)code area:(NSString *)area mobileOperator:(NSString *)mobileOperator
{
    if (self = [super init]) {
        _code = code;
        _area = area;
        _mobileOperator = mobileOperator;
    }
    return self;
}

@end

/***********************************************************
 *  VETSearchAreaCodeManager
 ***********************************************************/

@interface VETSearchAreaCodeManager ()

@property (nonatomic, retain) NSArray *areaCodeArray;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) VETAreaCode *settingAreaCode;
@property (nonatomic, assign, readwrite, getter=isSettedAreaCodeFlag) BOOL settedAreaCodeFlag;

@end

@implementation VETSearchAreaCodeManager

+ (VETSearchAreaCodeManager *)sharedInstance
{
    static VETSearchAreaCodeManager *areaCodeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        areaCodeManager = [[VETSearchAreaCodeManager alloc] init];
    });
    return areaCodeManager;
}

- (void)searchAreaCode:(NSString *)inputNumber completion:(void (^) (VETAreaCode *))block
{
    if (inputNumber.length == 1) {
        return;
    }
    if (self.settingAreaCode) {
        return;
    }
    if (_areaCodeArray == nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"areacodes" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        
        NSArray *arr = [content componentsSeparatedByString:@"\n"];
        
        // 去除第一排提示语句
        NSArray *newArr = [NSArray arrayWithArray:[arr subarrayWithRange:NSMakeRange(1, arr.count - 1)]];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           [newArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               NSString *str = (NSString *)obj;
               NSArray *codeSeparateArr = [str componentsSeparatedByString:@"\t"];
               if (codeSeparateArr.count == 2) {
                   NSString *code = codeSeparateArr[0];
                   NSArray *areaArr = [codeSeparateArr[1] componentsSeparatedByString:@"-"];
                   NSString *area = [areaArr[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                   
                   NSString *mobileOperator;
                   if (areaArr.count == 2) {
                       mobileOperator = [areaArr[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                   }
                   VETAreaCode *areaCode = [[VETAreaCode alloc] initWithCode:code area:area mobileOperator:mobileOperator];
                   [tempArray addObject:areaCode];
               }
           }];
            self.areaCodeArray = [tempArray copy];
            VETAreaCode *areaCode = [self searchArrayAreaCode:inputNumber];
            self.settingAreaCode = areaCode;
            dispatch_async(dispatch_get_main_queue(), ^{
                block(areaCode);
            });
            return ;
        });
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        VETAreaCode *areaCode = [self searchArrayAreaCode:inputNumber];
        self.settingAreaCode = areaCode;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(areaCode);
        });
    });
}

- (VETAreaCode *)searchArrayAreaCode:(NSString *)inputNumber
{
    BOOL notNeedRoolback = NO;
    for (VETAreaCode *areaCode in self.areaCodeArray) {
        NSString *code;
        // 去除开头的00
        if ([areaCode.code hasPrefix:@"00"]) {
            code = [areaCode.code substringFromIndex:2];
        }
        else {
            code = areaCode.code;
        }
        // 完全匹配，则直接返回
        if (code) {
            if ([code isEqualToString:inputNumber]) {
                return areaCode;
            }
        }
        // 匹配是否有其它区号以这个开头，如果有
        BOOL matchPrefix = [code hasPrefix:inputNumber];
        if (matchPrefix) {
            notNeedRoolback = YES;
        }
    }
    if (!notNeedRoolback) {
        if (inputNumber.length <= 1) {
            return nil;
        }
        return [self searchCompleteMatch:[inputNumber substringToIndex:inputNumber.length - 1]];
    }
    return nil;
}

- (VETAreaCode *)searchCompleteMatch:(NSString *)number
{
    if (number.length < 1) {
        return nil;
    }
    for (VETAreaCode *areaCode in self.areaCodeArray) {
        NSString *code;
        // 去除开头的00;
        if ([areaCode.code hasPrefix:@"00"]) {
            code = [areaCode.code substringFromIndex:2];
        }
        else {
            code = areaCode.code;
        }
        // 完全匹配，则直接返回
        if (code) {
            if ([code isEqualToString:number]) {
                return areaCode;
            }
        }
    }
    return [self searchCompleteMatch:[number substringToIndex:number.length - 1]];
}

- (VETCountryCode *)modelWithDictionary:(NSDictionary *)dic
{
    VETCountryCode *countryCode = [[VETCountryCode alloc] initWithCode:[dic objectForKey:@"code"]
                                                              shouzimu:[dic objectForKey:@"shouzimu"]
                                                                  icon:[dic objectForKey:@"icon"]
                                                                pinyin:[dic objectForKey:@"pinyin"] countryEnglishName:[dic objectForKey:@"countryEnglishName"]
                                                    countryChineseName:[dic objectForKey:@"countryChineseName"]];
    return countryCode;
}

- (VETAreaCode *)areaCodeWithDictionary:(NSDictionary *)dic
{
    VETAreaCode *areaCode = [[VETAreaCode alloc] initWithCode:[dic objectForKey:@"code"]
                                                         area:[dic objectForKey:@"area"]
                                               mobileOperator:[dic objectForKey:@"mobileOperator"]];
    return areaCode;
}

- (void)removeSettingAreaCode
{
    self.settingAreaCode = nil;
}

- (void)setSettingAreaCode:(VETAreaCode *)settingAreaCode
{
    _settingAreaCode = settingAreaCode;
    _settedAreaCodeFlag = _settingAreaCode == nil ? NO : YES;
}


@end
