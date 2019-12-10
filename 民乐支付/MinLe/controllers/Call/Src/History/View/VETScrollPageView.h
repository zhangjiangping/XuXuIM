//
//  LYXScrollPageView.h
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VETScrollPageViewDelagate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView pageProgress:(CGFloat )pageProgress;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView currentIndex:(CGFloat )currentIndex;

@end

@interface VETScrollPageView : UIView

@property (nonatomic, assign) id<VETScrollPageViewDelagate> delegate;

- (instancetype)initWithFrame:(CGRect)frame views:(NSArray *)viewArrary;

- (void)scrollToInex:(NSUInteger)index;

@end
