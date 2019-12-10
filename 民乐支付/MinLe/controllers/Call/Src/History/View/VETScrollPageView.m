//
//  LYXScrollPageView.m
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import "VETScrollPageView.h"
#import "UIView+Extension.h"

@interface VETScrollPageView ()<UIScrollViewDelegate> {
    BOOL _userPanGes;   //  区分是用户拖动或者是点击按钮后调用滑动方法。
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *viewsArray;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation VETScrollPageView

- (instancetype)initWithFrame:(CGRect)frame views:(NSArray *)viewArrary {
    if (self == [super initWithFrame:frame]) {
        self.viewsArray = viewArrary;
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.width * self.viewsArray.count, self.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    for (NSUInteger i = 0; i < _viewsArray.count; i++) {
        [self addPageView:_viewsArray[i] index:i];
    }
}

- (void)addPageView:(UIView *)view index:(NSUInteger)index {
    [_scrollView addSubview:view];
    view.frame = self.frame;
    view.x = self.width * index;
}

- (void)setupLayouts {
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.and.bottom.mas_equalTo(self).offset(0);
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _userPanGes = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //  是用户拖动，才会传递数据给navMenuView
    if (!_userPanGes) return;
    CGFloat pageProgress = scrollView.contentOffset.x / self.width;
//    NSLog(@"veletory x", scrollView.vec);
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:pageProgress:)]) {
        [self.delegate scrollViewDidScroll:scrollView pageProgress:pageProgress];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageProgress = scrollView.contentOffset.x / self.width;
    _currentIndex = (NSUInteger)(pageProgress + 0.5);
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:currentIndex:)]) {
        [self.delegate scrollViewDidScroll:scrollView currentIndex:_currentIndex];
    }
}

- (void)scrollToInex:(NSUInteger)index {
    _userPanGes = NO;
    if (_currentIndex == index) {
        _currentIndex = index;
        return;
    }
    _currentIndex = index;
    CGRect newFrame = CGRectMake(self.width * _currentIndex, _scrollView.y, self.width, self.height);
    [_scrollView scrollRectToVisible:newFrame animated:YES];
}

@end
