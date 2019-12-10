//
//  UIImage+HYQRCode.h
//  QRCodeTest
//
//  Created by yanghaha on 15/12/10.
//  Copyright © 2015年 yanghaha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYQRCode)

#pragma mark - Encode (调用时，建议在子线程中执行)
/**
 通过传入内容获取对应的二维码image
 @params qrString 传入内容
 @params length 传入将要生成的image的大小的边长
 */
+ (UIImage *)qrImageFromString:(NSString *)qrString sideLength:(CGFloat)length;
/**
 通过传入内容获取对应的二维码image， 并设置颜色
 @params qrString 传入内容
 @params length 传入将要生成的image的大小的边长
 @params r g b 为0~255之间的数值
 */
+ (UIImage *)qrColorImageFromString:(NSString *)qrString sideLength:(CGFloat)length withR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;
/**
 通过传入内容获取对应的二维码image， 并设置颜色
 @params qrString 传入内容
 @params length 传入将要生成的image的大小的边长
 @params color 传入需要设置的颜色
 */
+ (UIImage *)qrColorImageFromString:(NSString *)qrString sideLength:(CGFloat)length withColor:(UIColor *)color;

#pragma mark - Decode (调用时,建议在子线程中执行)

/* 请确保iphone5/5c以上的设备,因为经测试发现在4、5、5c上调用的话，无法正常解析获取内容，
   在ipad mini2和ipad mini4上也可以正常解析
 */

/**
 获取image的内容
 @params image 待解析的image
 */
+ (NSString *)stringFromImage:(UIImage *)image NS_AVAILABLE(10_10, 8_0);
/**
 获取image的内容
 @params filePath 待解析的image的本地路径
 */
+ (NSString *)stringFromImageFilePath:(NSString *)filePath NS_AVAILABLE(10_10, 8_0);
/**
 获取image的内容
 @params ciimage 待解析的ciimage
 */
+ (NSString *)stringFromCiImage:(CIImage *)ciimage NS_AVAILABLE(10_10, 8_0);

@end
