//
//  VETDiadadMainView.h
//  VETEphone
//
//  Created by young on 17/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETVoip.h"

@class VETDialpadButton;
@class VETDialpadMainView;
@class VETAreaCode;
@class VETCountry;

@protocol VETDialpadMainViewDelegate <NSObject>

@optional;
- (void)dialpadMainView:(VETDialpadMainView *)view tapCallButton:(id)sender;

- (void)dialpadMainView:(VETDialpadMainView *)view didDeleteTouchUpInsideButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view didDeleteTouchDownButton:(id)sender;

- (void)dialpadMainView:(VETDialpadMainView *)view tapCountryButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapAddContactsButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberOneButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberTwoButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberThreeButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberFourButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberFiveButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberSixButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberSevenButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberEightButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberNineButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberZeroButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberStarButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view tapNumberWellButton:(id)sender;
- (void)dialpadMainView:(VETDialpadMainView *)view longPressZeroButton:(id)sender;

- (void)dialpadMainView:(VETDialpadMainView *)view tapLongButton:(id)sender;

@end

@interface VETDialpadMainView : UIView

/*
 *   topView
 */
@property (nonatomic, retain) UIView *topPhoneContainer;
@property (nonatomic, retain) UIView *showPhoneView;
//@property (nonatomic, retain) UIButton *countryButton;
@property (nonatomic, retain) UILabel *countryLable;
@property (nonatomic, retain) UITextField *phoneTextfield;
@property (nonatomic, retain) UILabel *areaCodeLabel;

//@property (nonatomic, retain) UIView *payView;
//@property (nonatomic, retain) UILabel *showPayLabel;

//@property (nonatomic, retain) UILabel *balanceNotiLabel;
//@property (nonatomic, retain) UILabel *balanceLabel;

@property (nonatomic, retain) UIView *bottomThirdView;
@property (nonatomic, retain) UIButton *deleteButton;


// 状态View
//@property (nonatomic, retain) UIView *statusView;
//@property (nonatomic, retain) UIImageView *statusImg;
//@property (nonatomic, retain) UILabel *statusLabel;
//@property (nonatomic, retain) UIImageView *encryptionImageView;

/*
 *   centerView(0.5)
 */
@property (nonatomic, retain) UIView *centerPadContainer;
@property (nonatomic, retain) UIView *numberOneView;
@property (nonatomic, retain) UIButton *numberOneButton;

@property (nonatomic, retain) UIView *numberTwoView;
@property (nonatomic, retain) VETDialpadButton *numberTwoButton;

@property (nonatomic, retain) UIView *numberThreeView;
@property (nonatomic, retain) VETDialpadButton *numberThreeButton;

@property (nonatomic, retain) UIView *numberFourView;
@property (nonatomic, retain) VETDialpadButton *numberFourButton;

@property (nonatomic, retain) UIView *numberFiveView;
@property (nonatomic, retain) VETDialpadButton *numberFiveButton;

@property (nonatomic, retain) UIView *numberSixView;
@property (nonatomic, retain) VETDialpadButton *numberSixButton;

@property (nonatomic, retain) UIView *numberSevenView;
@property (nonatomic, retain) VETDialpadButton *numberSevenButton;

@property (nonatomic, retain) UIView *numberEightView;
@property (nonatomic, retain) VETDialpadButton *numberEightButton;

@property (nonatomic, retain) UIView *numberNineView;
@property (nonatomic, retain) VETDialpadButton *numberNineButton;

@property (nonatomic, retain) UIView *numberStarView;   //  *
@property (nonatomic, retain) UIButton *numberStarButton;

@property (nonatomic, retain) UIView *numberZeroView;
@property (nonatomic, retain) VETDialpadButton *numberZeroButton;

@property (nonatomic, retain) UIView *numberWellView;   //  #
@property (nonatomic, retain) UIButton *numberWellButton;

/*
 *   bottomView(0.1)
 */
@property (nonatomic, retain) UIView *bottomCallButtonContainer;

//@property (nonatomic, retain) UIView *bottomFirstView;

@property (nonatomic, retain) UIButton *callButton;

@property (nonatomic, assign) id<VETDialpadMainViewDelegate> delegate;

//@property (nonatomic, assign) NSUInteger nowAreaCode;

// Model
@property (nonatomic, retain) VETCountry *country;

//@property (nonatomic, assign) VETAccountStatus status;

@property (nonatomic, copy) NSString *phoneString;

@property (nonatomic, assign) BOOL encryptionStatus;

- (void)startCallAnimation;

@end
