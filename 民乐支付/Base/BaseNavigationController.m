//
//  BaseNavigationController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MLMyViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = RGB(2, 138, 218);
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = RGB(2, 138, 218);
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    //MLMyViewController为需要有横屏功能的控制器
//    for (UIViewController *viewController in self.viewControllers) {
//        if ([viewController isKindOfClass:[MLMyViewController class]])
//        {
//            return UIInterfaceOrientationMaskAllButUpsideDown;
//        }
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}


@end
