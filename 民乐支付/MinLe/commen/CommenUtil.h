//
//  CommenUtil.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 2017/2/17.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommenUtil : NSObject

+ (CommenUtil *)sharedInstance;

+ (float)getTxtHeight:(NSString *)content forContentWidth:(float)content_width fotFontSize:(float)fontSize;

+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;
+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font;

+ (CGFloat)getWidthWithContent:(NSString *)content withHeight:(CGFloat)height withFont:(UIFont *)font;
+ (CGFloat)getHeightWithContent:(NSString *)content withWidth:(CGFloat)width withFont:(UIFont *)font;

//通过当前时间生成扫码收款的外部订单号
+ (NSString *)getOut_order_number;

//获取当前时间
- (NSString *)getCurrentDateStr;

//两个时间相差多少秒
- (float)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

//判断是否超过了登录在线时间
- (BOOL)loginIsTimeoutFailure;

//传入的字符串返回是否为空
- (BOOL)isNull:(NSString *)str;

//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;

#pragma mark - 计算尺寸
//根据指定宽度返回高度
+ (float)getImgSize:(CGSize)size withImgViewWidth:(CGFloat)imgViewWidth;

//根据指定高度返回宽度
+ (float)getImgSize:(CGSize)size withImgViewHeight:(CGFloat)imgViewHeight;

+ (void)setTintColor:(UIColor *)tintColor forImgView:(UIImageView *)imageView;

#pragma mark - 语言

//获取语言
+ (NSString*)getPreferredLanguage;

//判断是不是中文
+ (BOOL)isChinaLanguage;

//给接口调用的语言包字段
+ (NSString *)getLanguage;

//多语言
+ (NSString *)LocalizedString:(NSString *)str;

//验证国际手机号码
+ (BOOL)isMobileWithPhone:(NSString *)phone withCode:(NSString *)code;

@end
