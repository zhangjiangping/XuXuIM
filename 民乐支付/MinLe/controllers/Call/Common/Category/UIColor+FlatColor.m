//
//  UIColor+FlatColor.m
//  VETEphone
//
//  Created by young on 20/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "UIColor+FlatColor.h"
#import <ChameleonFramework/Chameleon.h>

#define hsb(h,s,b) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:1.0]

@implementation UIColor (FlatColor)

+ (NSInteger)generateRandomNumberWithMax:(NSInteger)max {
    
    //Choose a random number between 0 and our number of available colors
    return arc4random_uniform((UInt32)max);
}

+ (UIColor *)gradientColorWith:(NSUInteger)number
{
    UIColor *color;
    switch (number) {
        case 0: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(143, 119, 246),RGBCOLOR(183, 40, 233)]];
            break;
        }
        case 1: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(104, 102, 246),RGBCOLOR(136, 138, 249)]];
            break;
        }
        case 2: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(243, 177, 108),RGBCOLOR(247, 202, 119)]];
            break;
        }
        case 3: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(87, 164, 237),RGBCOLOR(133, 205, 248)]];
            break;
        }
        case 4: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(124, 203, 118),RGBCOLOR(167, 217, 133)]];
            break;
        }
        case 5: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(237, 102, 109),RGBCOLOR(239, 133, 104)]];
            break;
        }
        case 6: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(104, 102, 246),RGBCOLOR(136, 168, 249)]];
            break;
        }
        case 7: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(143, 119, 246),RGBCOLOR(183, 40, 233)]];
            break;
        }
        case 8: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(204, 104, 233),RGBCOLOR(211, 153, 237)]];
            break;
        }
        case 9: {
            color = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(10, 60 / 2 - 35/2, 35, 35) andColors:@[RGBCOLOR(204, 104, 233),RGBCOLOR(211, 153, 237)]];
            break;
        }
        default:
            [self randomGradientColor];
            break;
    }
    return color;
}

+ (UIColor *)randomGradientColor
{
    NSUInteger randomNumber = [UIColor generateRandomNumberWithMax:9];
    return [self gradientColorWith:randomNumber];
}

+ (UIColor *)randomFlatColor
{
    NSUInteger randomNumber = [UIColor generateRandomNumberWithMax:11];
    UIColor *color;
    switch (randomNumber) {
        case 0: {
            color = [self flatYellowColor];
            break;
        }
        case 1: {
            color = [self flatNavyBlueColor];
            break;
        }
        case 2: {
            color = [self flatMintColor];
            break;
        }
        case 3: {
            color = [self flatMaroonColor];
            break;
        }
        case 4: {
            color = [self flatMagentaColor];
            break;
        }
        case 5: {
            color = [self flatLimeColor];
            break;
        }
        case 6: {
            color = [self flatSkyBlueColor];
            break;
        }
        case 7: {
            color = [self flatGrayColor];
            break;
        }
        case 8: {
            color = [self flatWatermelonColor];
            break;
        }
        case 9: {
            color = [self flatSandColor];
            break;
        }
        case 10: {
            color = [self flatBrownColor];
            break;
        }
        case 11: {
            color = [self flatBlueColor];
            break;
        }
        default:
            break;
    }
    return color;
}


+ (UIColor *)flatBlackColor {
    return hsb(0, 0, 17);
}

+ (UIColor *)flatBlueColor {
    return hsb(224, 50, 63);
}

+ (UIColor *)flatBrownColor {
    return hsb(24, 45, 37);
}

+ (UIColor *)flatCoffeeColor {
    return hsb(25, 31, 64);
}

+ (UIColor *)flatForestGreenColor {
    return hsb(138, 45, 37);
}

+ (UIColor *)flatGrayColor {
    return hsb(184, 10, 65);
}

+ (UIColor *)flatGreenColor {
    return hsb(145, 77, 80);
}

+ (UIColor *)flatLimeColor {
    return hsb(74, 70, 78);
}

+ (UIColor *)flatMagentaColor {
    return hsb(283, 51, 71);
}

+ (UIColor *)flatMaroonColor {
    return hsb(5, 65, 47);
}

+ (UIColor *)flatMintColor {
    return hsb(168, 86, 74);
}

+ (UIColor *)flatNavyBlueColor {
    return hsb(210, 45, 37);
}

+ (UIColor *)flatOrangeColor {
    return hsb(28, 85, 90);
}

+ (UIColor *)flatPinkColor {
    return hsb(324, 49, 96);
}

+ (UIColor *)flatPlumColor {
    return hsb(300, 45, 37);
}

+ (UIColor *)flatPowderBlueColor {
    return hsb(222, 24, 95);
}

+ (UIColor *)flatPurpleColor {
    return hsb(253, 52, 77);
}

+ (UIColor *)flatRedColor {
    return hsb(6, 74, 91);
}

+ (UIColor *)flatSandColor {
    return hsb(42, 25, 94);
}

+ (UIColor *)flatSkyBlueColor {
    return hsb(204, 76, 86);
}

+ (UIColor *)flatTealColor {
    return hsb(195, 55, 51);
}

+ (UIColor *)flatWatermelonColor {
    return hsb(356, 53, 94);
}

+ (UIColor *)flatWhiteColor {
    return hsb(192, 2, 95);
}

+ (UIColor *)flatYellowColor {
    return hsb(48, 99, 100);
}


@end
