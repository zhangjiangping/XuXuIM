//
//  VETContactDetailMainView.h
//  MobileVoip
//
//  Created by Liu Yang on 03/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VETAppleContact;
@class VETMobileModel;

/***********************************************************
 *  VETContactDetailPhoneCell
 ***********************************************************/

@class VETContactDetailPhoneCell;

@protocol VETContactDetailPhoneCellDelegate <NSObject>

- (void)detailPhoneCell:(VETContactDetailPhoneCell *)cell didTapRatesBtn:(UIButton *)ratesButton model:(VETMobileModel *)model;
- (void)detailPhoneCell:(VETContactDetailPhoneCell *)cell didTapCallBtn:(UIButton *)callButton model:(VETMobileModel *)model;

@end

@interface VETContactDetailPhoneCell : UITableViewCell

@property (nonatomic, retain) UILabel *hintLabel;
@property (nonatomic, retain) UILabel *phoneNumLabel;
@property (nonatomic, retain) UIButton *ratesButton;
@property (nonatomic, retain) UIButton *callButton;

@property (nonatomic, retain) VETMobileModel *mobileModel;

@property (nonatomic, assign) id<VETContactDetailPhoneCellDelegate> delegate;

@end

/***********************************************************
 *  VETContactDetailMainView
 ***********************************************************/
@class VETContactDetailMainView;

@protocol VETContactDetailMainViewDelegate <NSObject>

- (void)mainView:(VETContactDetailMainView *)mainView didTapFavorityBtn:(id)sender;

@end

@interface VETContactDetailMainView : UIView

/*
 * topView
 */
@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UIImageView *avatarImageView;
@property (nonatomic, retain) UIButton *favoriteButton;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) MASConstraint *topHeightConstraint;

/*
 * tableview
 */
@property (nonatomic, retain) UITableView *phoneNumberTableView;

@property (nonatomic, retain) VETAppleContact *contact;
@property (nonatomic, assign) id<VETContactDetailMainViewDelegate> delegate;

@end

