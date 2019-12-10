//
//  VETNavMenuView.h
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VETNavMenuView;
@protocol VETNavMenuViewDelagate <NSObject>

@optional
- (void)navMenuView:(VETNavMenuView *)menuView tapAllButton:(UIButton *)allButton;
- (void)navMenuView:(VETNavMenuView *)menuView tapMissedButton:(UIButton *)missedButton;

@end

@interface VETNavMenuView : UIView

@property (nonatomic, assign) id<VETNavMenuViewDelagate> delegate;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) CGFloat currentProgress;

@end
