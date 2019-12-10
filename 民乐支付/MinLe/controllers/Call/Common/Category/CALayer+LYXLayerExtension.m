//
//  CALayer+LYXLayerExtension.m
//  YWXClothingMatch
//
//  Created by young on 16/12/20.
//  Copyright © 2016年 young. All rights reserved.
//

#import "CALayer+LYXLayerExtension.h"

@implementation CALayer (LYXLayerExtension)

- (void)setBorderUIColor:(UIColor *)borderUIColor
{
    self.borderColor = borderUIColor.CGColor;
}

- (UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

- (void)setBorderWidthOnePix:(BOOL)borderWidthOnePix
{
    if (borderWidthOnePix) {
        self.borderWidth = 1 / [[UIScreen mainScreen] scale];
    }
}

- (BOOL)borderWidthOnePix
{
    return YES;
}

@end
