//
//  UIColor+FlatColor.h
//  VETEphone
//
//  Created by young on 20/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FlatColor)

+ (UIColor *)randomFlatColor;
+ (UIColor *)randomGradientColor;

/* 0-8 */
+ (UIColor *)gradientColorWith:(NSUInteger)number;

@end
