//
//  UIBarButtonItem+Extension.h
//  DYBluetoothLock
//
//  Created by Young on 15/11/27.
//  Copyright (c) 2015年 youngLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem*)itemWithImageName:(NSString*)imageName highImageName:(NSString*)highImageName target:(id)target action:(SEL)action;

@end
