//
//  VETHistoryView.h
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VETHistoryMainView;
@class VETHistoryTableView;
@class VETScrollPageView;
@protocol VETHistoryMainViewDelegate <NSObject>

- (void)historyView:(VETHistoryMainView *)historyView pageProgress:(CGFloat)pageProgress;
- (void)historyView:(VETHistoryMainView *)historyView currentIndex:(CGFloat)currentIndex;

@end

@interface VETHistoryMainView : UIView

@property (nonatomic, assign) id<VETHistoryMainViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, retain) NSArray *allHistoryArray;
@property (nonatomic, retain) NSArray *missedHistoryArray;
@property (nonatomic, retain) VETHistoryTableView *leftView;
@property (nonatomic, retain) VETHistoryTableView *rightView;
@property (nonatomic, retain) VETScrollPageView *pageView;

@end
