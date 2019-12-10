//
//  UIView+Responder.m
//  外卖APP
//
//  Created by aoyolo on 16/5/5.
//  Copyright © 2016年 eyu. All rights reserved.
//

#import "UIView+Responder.h"

@implementation UIView (Responder)


- (UIViewController *)viewController
{
    UIResponder *nextResponder = [self nextResponder];
    do {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        nextResponder = [nextResponder nextResponder];
    } while (nextResponder);
    return nil;
}

@end
