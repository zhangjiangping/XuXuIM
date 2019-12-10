//
//  VETCallingMainView.h
//  VETEphone
//
//  Created by young on 18/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VETCallingMainView;

@protocol VETCallingMainViewDelegate <NSObject>

@optional;
- (void)callingMainView:(VETCallingMainView *)view tapMuteButton:(id)sender;
- (void)callingMainView:(VETCallingMainView *)view tapVideoButton:(id)sender;
- (void)callingMainView:(VETCallingMainView *)view tapSpeakerButton:(id)sender;
- (void)callingMainView:(VETCallingMainView *)view tapHoldButton:(id)sender;
- (void)callingMainView:(VETCallingMainView *)view tapMinimizeButton:(id)sender;
- (void)callingMainView:(VETCallingMainView *)view tapKeypadButton:(id)sender;
- (void)callingMainView:(VETCallingMainView *)view tapHangupButton:(id)sender;
@end

@interface VETCallingMainView : UIView

@property (nonatomic, assign) id<VETCallingMainViewDelegate> delegate;

/*
 *   topContainer
 */
@property (nonatomic, retain) UILabel *phoneLabel;
@property (nonatomic, retain, readonly) UILabel *statusLabel;
@property (nonatomic, retain) UILabel *qualityLeftLabel;
@property (nonatomic, retain) UILabel *qualityRightLabel;
@property (nonatomic, retain) UIImageView *qualityImageView;

/*
 *   centerContainer
 */
@property (nonatomic, retain) UIView *centerContainer;
@property (nonatomic, retain) UIView *centerFirstRowView;

@property (nonatomic, retain) UIView *muteView;
@property (nonatomic, retain) UIButton *muteButton;
@property (nonatomic, retain) UILabel *muteLabel;

@property (nonatomic, retain) UIView *videoView;
@property (nonatomic, retain) UIButton *videoButton;
@property (nonatomic, retain) UILabel *videoLabel;

@property (nonatomic, retain) UIView *speakerView;
@property (nonatomic, retain) UIButton *speakerButton;
@property (nonatomic, retain) UILabel *speakerLabel;

@property (nonatomic, retain) UIView *centerSecondRowView;

@property (nonatomic, retain) UIView *holdView;
@property (nonatomic, retain) UIButton *holdButton;
@property (nonatomic, retain) UILabel *holdLabel;

@property (nonatomic, retain) UIView *minimizeView;
@property (nonatomic, retain) UIButton *minimizeButton;
@property (nonatomic, retain) UILabel *minimizeLabel;

@property (nonatomic, retain) UIView *keypadView;
@property (nonatomic, retain) UIButton *keypadButton;
@property (nonatomic, retain) UILabel *keypadLabel;

/*
 *   bottomContainer
 */
@property (nonatomic, retain) UIView *bottomContainer;
@property (nonatomic, retain) UIButton *hangupButton;

- (void)endCalling:(NSString *)callTime;

@end
