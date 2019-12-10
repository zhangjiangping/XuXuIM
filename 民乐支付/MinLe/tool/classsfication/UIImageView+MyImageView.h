//
//  UIImageView+MyImageView.h
//  MeituanMovie
//
//  Created by Chris on 16/1/16.
//  Copyright © 2016年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (MyImageView)

- (void)setImageWithString:(NSString *)string;

- (void)setImageWithString:(NSString *)string withDefalutImage:(UIImage *)image;

@end
