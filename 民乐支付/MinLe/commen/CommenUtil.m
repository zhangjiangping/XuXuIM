//
//  CommenUtil.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 2017/2/17.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "CommenUtil.h"
#import "libPhoneNumberiOS.h"

#define dateFormatterStr @"yyyy-MM-dd HH:mm:ss" //时间格式

@implementation CommenUtil

+ (CommenUtil *)sharedInstance {
    static CommenUtil *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[CommenUtil alloc] init];
    });
    return util;
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    return preferredLang;
}

+ (BOOL)isChinaLanguage
{
    NSString *languageStr = [CommenUtil getPreferredLanguage];
    if ([languageStr isEqualToString:@"zh-Hans"] ||
        [languageStr isEqualToString:@"zh-Hans-US"] ||
        [languageStr isEqualToString:@"zh-Hans-HK"] ||
        [languageStr isEqualToString:@"zh-Hans-CN"] )  {
        return YES;
    } else  {
        return NO;
    }
}

+ (NSString *)getLanguage
{
    NSString *languageStr = [CommenUtil getPreferredLanguage];
    if ([languageStr containsString:@"zh-Hans"])  {
        //简体中文
        return @"zh";
    } else if ([languageStr containsString:@"Hant"]) {
        //繁体中文
        return @"tc";
    } else {
        //其他语言 用英语
        return @"en";
    }
}

//该方法根据传入的字体等参数返回高度
+(float)getTxtHeight:(NSString *)content forContentWidth:(float)content_width fotFontSize:(float)fontSize
{
    //计算发表内容的高度
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //设置一个行高上限
    CGSize size = CGSizeMake(content_width,MAXFLOAT);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    return labelsize.height;
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}

+ (CGFloat)getWidthWithContent:(NSString *)content withHeight:(CGFloat)height withFont:(UIFont *)font
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return rect.size.width;
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getHeightWithContent:(NSString *)content withWidth:(CGFloat)width withFont:(UIFont *)font
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return rect.size.height;
}

//通过当前时间生成扫码收款的外部订单号
+ (NSString *)getOut_order_number
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //(int)(100 + (arc4random() % (899))) 100~999中间的随机数
    NSString *tempStr = [NSString stringWithFormat:@"i%@%d",dateStr,(int)(100 + (arc4random() % (899)))];
    
    return tempStr;
}


//获取一个随机整数，范围在[from,to)，包括from，不包括to
- (int)getRandomNumber:(int)from to:(int)to
{
    int a = to - from;
    return (int)(from + (arc4random() % a));
}

//传入的字符串返回是否为空
- (BOOL)isNull:(NSString *)str
{
    if (str==nil||![str isKindOfClass:[NSString class]]||[@"" isEqualToString:[str stringByReplacingOccurrencesOfString:@" " withString:@""]] || [str isEqualToString:@"null"] || [str isEqualToString:@"(null)"]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 计算尺寸
//根据指定宽度返回高度
+ (float)getImgSize:(CGSize)size withImgViewWidth:(CGFloat)imgViewWidth
{
    CGFloat imgW = size.width;
    CGFloat imgH = size.height;
    CGFloat srcRatio = imgW / imgH;
    CGSize csize = CGSizeMake(imgViewWidth, imgViewWidth / srcRatio);
    return csize.height;
}

//根据指定高度返回宽度
+ (float)getImgSize:(CGSize)size withImgViewHeight:(CGFloat)imgViewHeight
{
    CGFloat imgW = size.width;
    CGFloat imgH = size.height;
    CGFloat srcRatio = imgH / imgW;
    CGSize csize = CGSizeMake(imgViewHeight / srcRatio, imgViewHeight);
    return csize.height;
}

#pragma mark - 时间部分

//获取当前时间字符串
- (NSString *)getCurrentDateStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormatterStr];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}

//两个时间相差多少秒
- (float)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:dateFormatterStr];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    
    int second = (int)value;//秒
    return second;
}

//判断是否超过了登录在线时间
- (BOOL)loginIsTimeoutFailure
{
    NSString *timeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:HistoryLoginTime]];
    if ([self isNull:timeStr]) {
        return NO;
    } else {
        NSString *currentTimeStr = [self getCurrentDateStr];
        int timeCha = [self dateTimeDifferenceWithStartTime:timeStr endTime:currentTimeStr];
        NSLog(@"没有登录累计时间：%d",timeCha);
        if ((timeCha - 12*3600) >= 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (void)setTintColor:(UIColor *)tintColor forImgView:(UIImageView *)imageView
{
    imageView.tintColor = tintColor;
    UIImage *img = imageView.image;
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = img;
}



//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//保留两位小数不进行四舍五入
- (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


//验证国际手机号码
+ (BOOL)isMobileWithPhone:(NSString *)phone withCode:(NSString *)code
{
    NSMutableString *mutCode = [NSMutableString string];
    if ([code isEqualToString:@""] || [code isEqual:[NSNull class]] || [code isEqualToString:@"Null"] || code == NULL) {
        mutCode = [@"CN" mutableCopy];
    } else {
        mutCode = [code mutableCopy];
    }
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:phone
                                 defaultRegion:mutCode error:&anError];
    
    if (anError == nil) {
        return [phoneUtil isValidNumber:myNumber] ? YES : NO;
        //        // E164          : +436766077303
        //        NSLog(@"E164          : %@", [phoneUtil format:myNumber
        //                                          numberFormat:NBEPhoneNumberFormatE164
        //                                                 error:&anError]);
        //        // INTERNATIONAL : +43 676 6077303
        //        NSLog(@"INTERNATIONAL : %@", [phoneUtil format:myNumber
        //                                          numberFormat:NBEPhoneNumberFormatINTERNATIONAL
        //                                                 error:&anError]);
        //        // NATIONAL      : 0676 6077303
        //        NSLog(@"NATIONAL      : %@", [phoneUtil format:myNumber
        //                                          numberFormat:NBEPhoneNumberFormatNATIONAL
        //                                                 error:&anError]);
        //        // RFC3966       : tel:+43-676-6077303
        //        NSLog(@"RFC3966       : %@", [phoneUtil format:myNumber
        //                                          numberFormat:NBEPhoneNumberFormatRFC3966
        //                                                 error:&anError]);
    } else {
        NSLog(@"Error : %@", [anError localizedDescription]);
        return NO;
    }
}

+ (NSString *)LocalizedString:(NSString *)str
{
    //return NSLocalizedString(str, str);
    return NSLocalizedStringFromTable(str, @"Localizable", nil);
}



@end
