//
//  UIImage+MLMyimage.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/10.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MLMyimage)

- (UIImage *)resetImgFrame:(UIImageView *)imageView withImage:(UIImage *)newImage;

//指定宽度按比例缩放
//- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
-(UIImage *)imageCompress:(UIImage *)sourceImage targetHeight:(CGFloat)defineHeight;

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
- (UIImage *)imageCompress:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
