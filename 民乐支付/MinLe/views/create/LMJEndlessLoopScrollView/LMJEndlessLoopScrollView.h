//
//  LMJEndlessLoopScrollView.h
//  LMJEndlessLoopScroll
//
//  Created by Major on 16/3/10.
//  Copyright © 2016年 iOS开发者公会. All rights reserved.
//
//  iOS开发者公会-技术1群 QQ群号：87440292
//  iOS开发者公会-技术2群 QQ群号：232702419
//  iOS开发者公会-议事区  QQ群号：413102158
//

#import <UIKit/UIKit.h>

@class LMJEndlessLoopScrollView;

@protocol LMJEndlessLoopScrollViewDelegate <NSObject>

@required

- (NSInteger)numberOfContentViewsInLoopScrollView:(LMJEndlessLoopScrollView *)loopScrollView;

- (UIView *)loopScrollView:(LMJEndlessLoopScrollView *)loopScrollView contentViewAtIndex:(NSInteger)index;

@optional

- (void)loopScrollView:(LMJEndlessLoopScrollView *)loopScrollView currentContentViewAtIndex:(NSInteger)index;

- (void)loopScrollView:(LMJEndlessLoopScrollView *)loopScrollView didSelectContentViewAtIndex:(NSInteger)index;

@end

//滚动方向设置
typedef NS_ENUM(NSUInteger, DirectionState) {
    DirectionDownAndUpState = 0,/**< 纵向滚动 */
    DirectionRightAndLeftState = 1 /**< 横向滚动 */
};


@interface LMJEndlessLoopScrollView : UIView 

@property (nonatomic,assign) id<LMJEndlessLoopScrollViewDelegate> delegate;

// 当duration<=0时，默认不自动滚动
- (id)initWithFrame:(CGRect)frame animationScrollDuration:(NSTimeInterval)duration withState:(DirectionState)state;

- (void)reloadData;

- (void)pause;

- (void)start;

- (void)removeTimer;

@end
