//
//  VETHistoryView.m
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import "VETHistoryMainView.h"
#import "VETScrollPageView.h"
#import "VETHistoryTableView.h"

@interface VETHistoryMainView ()<VETScrollPageViewDelagate>

@end

@implementation VETHistoryMainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _leftView = [[VETHistoryTableView alloc] initWithFrame:CGRectZero];
    _rightView = [[VETHistoryTableView alloc] initWithFrame:CGRectZero];
    _pageView = [[VETScrollPageView alloc] initWithFrame:self.bounds views:@[_leftView, _rightView]];
    _pageView.delegate = self;
    [self addSubview:_pageView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView pageProgress:(CGFloat)pageProgress {
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyView:pageProgress:)]) {
        [self.delegate historyView:self pageProgress:pageProgress];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView currentIndex:(CGFloat)currentIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyView:currentIndex:)]) {
        [self.delegate historyView:self currentIndex:currentIndex];
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    [_pageView scrollToInex:currentIndex];
}

- (void)setAllHistoryArray:(NSArray *)allHistoryArray {
    _allHistoryArray = allHistoryArray;
    _leftView.dataArray = _allHistoryArray;
}

- (void)setMissedHistoryArray:(NSArray *)missedHistoryArray {
    _missedHistoryArray = missedHistoryArray;
    _rightView.dataArray = _missedHistoryArray;
}


@end
