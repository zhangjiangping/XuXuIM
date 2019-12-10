//
//  GuideView.m
//  民乐支付
//
//  Created by JP on 2017/8/2.
//  Copyright © 2017年 SZVETRON-iMAC. All rights reserved.
//

#import "GuideView.h"
#import "BaseNavigationController.h"
#import "MLHomeViewController.h"
#import "MLLandingViewController.h"

@interface GuideView () <UIScrollViewDelegate>
//图片路径数组
@property (nonatomic, strong) NSArray *imageNames;
//滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
//页码
@property (nonatomic, strong) UIPageControl *page;
//立即体验按钮
@property (nonatomic, strong) UIButton *experienceButton;
@end

@implementation GuideView

- (instancetype)initWithFrame:(CGRect)frame withImageNames:(NSArray *)imageNames
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageNames = imageNames;
        [self addSubview:self.scrollView];
        [self addSubview:self.page];
    }
    return self;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

//跳转主页面
- (void)pushToHome:(UIButton *)sender
{
    [self dismiss];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    BaseNavigationController *baseNav = (BaseNavigationController *)SharedApp.window.rootViewController;
//    for (BaseViewController *vc in baseNav.viewControllers) {
//        if ([vc isKindOfClass:[MLHomeViewController class]]) {
//            vc.isWriteBar = YES;
//            [vc setNeedsStatusBarAppearanceUpdate];
//        }
//        if ([vc isKindOfClass:[MLLandingViewController class]]) {
//            vc.isWriteBar = NO;
//            [vc setNeedsStatusBarAppearanceUpdate];
//        }
//    }
}

- (void)dismiss
{
    [UIImageView animateWithDuration:1.0 animations:^{
        self.transform = CGAffineTransformMakeScale(2.0, 2.0);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UI

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        //设置滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, widths, heights)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(self.imageNames.count * widths, 0);
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        
        for (NSInteger i = 0; i < self.imageNames.count; i ++) {
            CGRect rect = CGRectMake(i * widths, 0, widths, heights);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:self.imageNames[i]];
            [_scrollView addSubview:imageView];
            
            if (i == self.imageNames.count-1) {
                [imageView addSubview:self.experienceButton];
            }
        }
    }
    return _scrollView;
}

- (UIPageControl *)page
{
    if (!_page) {
        _page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, heights - 40, widths, 40)];
        _page.currentPageIndicatorTintColor = blueRGB;
        _page.pageIndicatorTintColor = [UIColor whiteColor];
        _page.numberOfPages = self.imageNames.count;
        _page.userInteractionEnabled = NO;
    }
    return _page;
}

- (UIButton *)experienceButton
{
    if (!_experienceButton) {
        _experienceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _experienceButton.frame = CGRectMake((widths-180)/2, heights-90, 180, 40);
        _experienceButton.layer.cornerRadius = 20;
        _experienceButton.layer.borderWidth = 1;
        _experienceButton.layer.borderColor = blueRGB.CGColor;
        _experienceButton.layer.masksToBounds = YES;
        _experienceButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_experienceButton setTitle:[CommenUtil LocalizedString:@"Home.Experience"] forState:UIControlStateNormal];
        [_experienceButton setTitleColor:blueRGB forState:UIControlStateNormal];
        [_experienceButton addTarget:self action:@selector(pushToHome:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _experienceButton;
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger offset = (targetContentOffset->x)/screenWidth;
    self.page.currentPage = offset;
}

@end
