//
//  UIButton+MyButton.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/27.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "UIButton+MyButton.h"

@implementation UIButton (MyButton)

- (void)setImageWithString:(NSString *)string
{
    [self sd_setImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal];
}

- (void)setImageWithString:(NSString *)string withDefalutImage:(UIImage *)image
{
    [self sd_setImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal placeholderImage:image];
}

@end
