//
//  CAGradientLayer+Custom.m
//  面包旅行
//
//  Created by aoyolo on 16/6/9.
//  Copyright © 2016年 aoyolo. All rights reserved.
//

#import "CAGradientLayer+Custom.h"

@implementation CAGradientLayer (Custom)

+ (CAGradientLayer *)createCAGradientLayer:(UIView *)view {
  CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer.cornerRadius = 5;
    gradientLayer.borderWidth = 0;
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)+16);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor], (id)[[UIColor clearColor] CGColor],nil];
    gradientLayer.startPoint = CGPointMake(0.0, 1.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    return gradientLayer;
}

//自定义从一个颜色到另一个颜色
+ (CAGradientLayer *)createCAGradientLayer:(UIView *)view withStartColor:(UIColor *)startColor withEndColor:(UIColor *)endColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor],nil];
    gradientLayer.startPoint = CGPointMake(1.0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    return gradientLayer;
}

@end
