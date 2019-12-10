//
//  CAGradientLayer+Custom.h
//  面包旅行
//
//  Created by aoyolo on 16/6/9.
//  Copyright © 2016年 aoyolo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface CAGradientLayer (Custom)

+ (CAGradientLayer *)createCAGradientLayer:(UIView *)view;

+ (CAGradientLayer *)createCAGradientLayer:(UIView *)view withStartColor:(UIColor *)startColor withEndColor:(UIColor *)endColor;

@end
