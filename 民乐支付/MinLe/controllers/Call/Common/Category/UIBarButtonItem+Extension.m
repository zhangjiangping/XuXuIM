//
//  UIBarButtonItem+Extension.m
//  DYBluetoothLock
//
//  Created by Young on 15/11/27.
//  Copyright (c) 2015年 youngLiu. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem*)itemWithImageName:(NSString*)imageName highImageName:(NSString*)highImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    btn.size = btn.currentBackgroundImage.size;
    [btn addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn] ;

    return leftBarButton;
}

@end
