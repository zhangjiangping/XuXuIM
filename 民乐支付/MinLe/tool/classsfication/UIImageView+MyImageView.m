//
//  UIImageView+MyImageView.m
//  MeituanMovie
//
//  Created by Chris on 16/1/16.
//  Copyright © 2016年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import "UIImageView+MyImageView.h"

@implementation UIImageView (MyImageView)

- (void)setImageWithString:(NSString *)string
{
    [self sd_setImageWithURL:[NSURL URLWithString:string]];
}

- (void)setImageWithString:(NSString *)string withDefalutImage:(UIImage *)image
{
    [self sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:image];
}

@end
