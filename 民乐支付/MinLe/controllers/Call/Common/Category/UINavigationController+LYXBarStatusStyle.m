//
//  UINavigationController+LYXBarStyle.m
//  MobileVoip
//
//  Created by Liu Yang on 02/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "UINavigationController+LYXBarStatusStyle.h"

@implementation UINavigationController (LYXBarStatusStyle)

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController *rootViewController = self.viewControllers.firstObject;
    if (rootViewController) {
        return rootViewController.preferredStatusBarStyle;
    }
    return [super preferredStatusBarStyle];
}

@end
