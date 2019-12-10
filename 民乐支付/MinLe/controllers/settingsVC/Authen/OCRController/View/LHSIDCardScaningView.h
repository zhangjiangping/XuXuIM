//
//  LHSIDCardScaningView.h
//  身份证识别
//
//  Created by huashan on 2017/2/17.
//  Copyright © 2017年 LiHuashan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IDCardTypePositive,//身份证正面识别
    IDCardTypeReverse,//身份证反面识别
    BankCardTypePositive,//银行卡正面识别
} IDCardType;

@interface LHSIDCardScaningView : UIView

@property (nonatomic,assign) CGRect facePathRect;

- (instancetype)initWithFrame:(CGRect)frame withType:(IDCardType)type;

- (void)addTimer;

- (void)clearTimer;

@end
