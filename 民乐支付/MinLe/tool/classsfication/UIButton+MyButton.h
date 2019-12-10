//
//  UIButton+MyButton.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/27.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

@interface UIButton (MyButton)

- (void)setImageWithString:(NSString *)string;

- (void)setImageWithString:(NSString *)string withDefalutImage:(UIImage *)image;

@end
