//
//  VETNavMenuView.m
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import "VETNavMenuView.h"

@interface VETNavMenuView () {
    CGFloat _lastScrollX;
}

@property (nonatomic, retain) UIButton *allButton;
@property (nonatomic, retain) UIView *allLineView;

@property (nonatomic, retain) UIButton *missedButton;
@property (nonatomic, retain) UIView *missedLineView;

@end

@implementation VETNavMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews {
    _allButton = [[UIButton alloc] init];
    [self addSubview:_allButton];
    [_allButton setTitle:NSLocalizedString(@"All", @"Title") forState:UIControlStateNormal];
    [_allButton setTitleColor:MAINTHEMECOLOR forState:UIControlStateSelected];
    [_allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_allButton setTitleColor:MAINTHEMECOLOR forState:UIControlStateHighlighted];
    [_allButton addTarget:self action:@selector(tapAllButton:) forControlEvents:UIControlEventTouchUpInside];
    _allButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _allButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    _allButton.selected = YES;
    //  默认字体为1.2倍
    _allButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    _allLineView = [UIView new];
    [self addSubview:_allLineView];
    _allLineView.backgroundColor = MAINTHEMECOLOR;
    
    _missedButton = [[UIButton alloc] init];
    [self addSubview:_missedButton];
    [_missedButton setTitle:NSLocalizedString(@"Missed", @"Title") forState:UIControlStateNormal];
    [_missedButton setTitleColor:MAINTHEMECOLOR forState:UIControlStateSelected];
    [_missedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_missedButton setTitleColor:MAINTHEMECOLOR forState:UIControlStateHighlighted];
    [_missedButton addTarget:self action:@selector(tapMissedButton:) forControlEvents:UIControlEventTouchUpInside];
    _missedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _missedButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    _missedLineView = [UIView new];
    [self addSubview:_missedLineView];
    _missedLineView.backgroundColor = MAINTHEMECOLOR;
    _missedLineView.hidden = YES;
}

- (void)setupLayouts {
    [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(self).offset(0);
        make.width.mas_equalTo(self).multipliedBy(0.5);
    }];
    
    [_allLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(@2);
        make.width.mas_equalTo(self).multipliedBy(0.5);
    }];
    
    [_missedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.bottom.mas_equalTo(self).offset(0);
        make.width.mas_equalTo(_allButton.mas_width);
    }];
    
    [_missedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(0);
        make.width.mas_equalTo(_allLineView.mas_width);
        make.bottom.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(@2);
    }];
}

- (void)tapAllButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navMenuView:tapAllButton:)]) {
        //  字体变化
        [UIView animateWithDuration:0.3 animations:^{
            _allButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            _missedButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [self.delegate navMenuView:self tapAllButton:sender];
    }
}

- (void)tapMissedButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navMenuView:tapMissedButton:)]) {
        //  字体变化
        [UIView animateWithDuration:0.3 animations:^{
            _missedButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            _allButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [self.delegate navMenuView:self tapAllButton:sender];
        [self.delegate navMenuView:self tapMissedButton:sender];
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    if (_currentIndex == currentIndex) return;
    _currentIndex = currentIndex;
    _missedLineView.alpha = 1.0;
    _allLineView.alpha = 1.0;
    if (currentIndex == 0) {
        _allButton.selected = YES;
        _missedButton.selected = NO;
        _allLineView.hidden = NO;
        _missedLineView.hidden = YES;
    }
    else {
        _missedButton.selected = YES;
        _allButton.selected = NO;
        _allLineView.hidden = YES;
        _missedLineView.hidden = NO;
    }
}

- (void)setCurrentProgress:(CGFloat)currentProgress {
    if (_allLineView.hidden == YES) {
        _allLineView.hidden = NO;
    }
    else if (_missedLineView.hidden == YES) {
        _missedLineView.hidden = NO;
    }
    _currentProgress = currentProgress;
    _currentIndex = currentProgress + 0.5;
    _allLineView.alpha = 1 - currentProgress;
    _missedLineView.alpha = currentProgress;

    _missedButton.selected = _currentIndex == 1 ? YES : NO;
    _allButton.selected = _currentIndex == 1 ? NO : YES;
    
    if (currentProgress < 0 || currentProgress > 1) {
        _lastScrollX = currentProgress;
        return;
    }
    /*
     *  字体变化
     */
    //  左滑(All字体变大)
    if (_lastScrollX > currentProgress) {
        _missedButton.transform = CGAffineTransformMakeScale(1 + currentProgress / 5, 1 + currentProgress / 5);
        _allButton.transform = CGAffineTransformMakeScale(1 - currentProgress / 5 + 0.2, 1 - currentProgress / 5 + 0.2);
    }
    //  右滑(Missed字体变大)
    else {
        //  1 - currentProgress / 5 > 1 ? 1 - currentProgress / 5 : _allButton.transform.xy
        _allButton.transform = CGAffineTransformMakeScale(1 - currentProgress / 5 + 0.2, 1 - currentProgress / 5 + 0.2);
        _missedButton.transform = CGAffineTransformMakeScale(1 + currentProgress / 5, 1 + currentProgress / 5);
    }

    //    NSLog(@"_missedButton currentProgress:%f", 1 - currentProgress - 0.2);
    //    NSLog(@"_allButton currentProgress:%f", currentProgress + 0.2);
    _lastScrollX = currentProgress;
}

@end
