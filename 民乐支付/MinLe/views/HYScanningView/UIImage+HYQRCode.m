//
//  UIImage+HYQRCode.m
//  QRCodeTest
//
//  Created by yanghaha on 15/12/10.
//  Copyright © 2015年 yanghaha. All rights reserved.
//

#import "UIImage+HYQRCode.h"

@implementation UIImage (HYQRCode)

#pragma mark - encode

+ (UIImage *)qrImageFromString:(NSString *)qrString sideLength:(CGFloat)length {
    CIImage *ciImage = [UIImage ciImageFromString:qrString];
    UIImage *image = [UIImage createNonInterpolatedUIImageFormCIImage:ciImage withSize:length];

    return image;
}

+ (UIImage *)qrColorImageFromString:(NSString *)qrString sideLength:(CGFloat)length withR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue {
    UIImage *image = [UIImage qrImageFromString:qrString sideLength:length];
    image = [UIImage imageBlackToTransparent:image withRed:red andGreen:green andBlue:blue];

    return image;
}


+ (UIImage *)qrColorImageFromString:(NSString *)qrString sideLength:(CGFloat)length withColor:(UIColor *)color {
    const CGFloat *rgb = CGColorGetComponents(color.CGColor);
    UIImage * image = [UIImage qrColorImageFromString:qrString sideLength:length withR:rgb[0]*255 G:rgb[1]*255 B:rgb[2]*255];

    return image;
}

+ (CIImage *)ciImageFromString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];

    return qrFilter.outputImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (UIImage *)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return resultUIImage;
}

#pragma mark - decode

+ (NSString *)stringFromImage:(UIImage *)image {
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    return [UIImage stringFromCiImage:ciImage];
}

+ (NSString *)stringFromImageFilePath:(NSString *)filePath {

    NSURL *url = [NSURL fileURLWithPath:filePath];
    CIImage *ciimage = [CIImage imageWithContentsOfURL:url];

    return [UIImage stringFromCiImage:ciimage];
}

+ (NSString *)stringFromCiImage:(CIImage *)ciimage {
    NSString *content = @"";

    if (!ciimage) {
        return content;
    }

    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:[CIContext contextWithOptions:nil]
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:ciimage];
    if (features.count) {

        for (CIFeature *feature in features) {
            if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
                content = ((CIQRCodeFeature *)feature).messageString;
                break;
            }
        }
    } else {
        NSLog(@"未正常解析二维码图片, 请确保iphone5/5c以上的设备");
    }

    return content;
}

@end
