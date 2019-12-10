//
//  DYNavigationController.m
//  DunyunLock
//
//  Created by young on 16/3/8.
//  Copyright © 2016年 duyun. All rights reserved.
//

#import "VETNavigationController.h"
#import "UIBarButtonItem+Extension.h"
//#import "UINavigationBar+Awesome.h"

@interface VETNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation VETNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIStatusBarStyle style = [self.navigationController preferredStatusBarStyle];
//    style = UIStatusBarStyleLightContent;
//    self.navigationBar.alpha = 0.2;
//    [self.navigationBar lt_setElementsAlpha:0.5];
//    [appearance lt_setBackgroundColor:MAINTHEMECOLOR];
//    self.navigationBar.backgroundColor = [UIColor yellowColor];
//    self.interactivePopGestureRecognizer.delegate = self;
//    self.interactivePopGestureRecognizer.enabled = YES;
//    self.interactivePopGestureRecognizer.delegate = self;
    __weak VETNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:RGBCOLOR(249, 249, 249)];
    // without this line, the bottom part will be black color
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] )
        {
            return NO;
        }
    }
    return YES;
}

+ (void)initialize
{
    [self setupNavigationBarTheme];
}

+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    //返回按钮颜色
    [appearance setTintColor:MAINTHEMECOLOR];
    appearance.barStyle = UIBarStyleDefault;
    [appearance setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
//    [appearance setBackgroundColor:RGBCOLOR(249, 249, 249)];
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [appearance setTranslucent:NO];
    }
    NSMutableDictionary *testAttrs = [NSMutableDictionary dictionary];
    testAttrs[NSForegroundColorAttributeName] = MAINTHEMECOLOR;
    [appearance setTitleTextAttributes:testAttrs];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon" highImageName:@"nav_item_back" target:self action:@selector(back_original)];
    }
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)back_original
{
    //这里用的是self, 因为self就是当前正在使用的导航控制器
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
