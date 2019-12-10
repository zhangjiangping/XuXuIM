//
//  VETDTMFView.h
//  MobileVoip
//
//  Created by Liu Yang on 12/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VETDTMFView;

typedef NS_ENUM(NSUInteger, VETKeypadNumberType) {
    VETKeypadNumberZero,
    VETKeypadNumberOne,
    VETKeypadNumberTwo,
    VETKeypadNumberThree,
    VETKeypadNumberFour,
    VETKeypadNumberFive,
    VETKeypadNumberSix,
    VETKeypadNumberSeven,
    VETKeypadNumberEight,
    VETKeypadNumberNine,
    VETKeypadNumberStar,
    VETKeypadNumberWell,
};

@protocol VETDTMFViewDelegate <NSObject>

@optional
- (void)DTMFView:(VETDTMFView *)view tapHideButton:(id)sender;
- (void)DTMFView:(VETDTMFView *)view tapHangupButton:(id)sender;
- (void)DTMFView:(VETDTMFView *)view tapNumberButton:(id)sender number:(VETKeypadNumberType)numberType;
- (void)DTMFView:(VETDTMFView *)view longPressZeroButton:(id)sender;

@end

@interface VETDTMFView : UIView

@property (nonatomic, assign) id<VETDTMFViewDelegate> delegate;

- (void)show;
- (void)hide;

@end
