//
//  VETAddContactViewController.h
//  VETEphone
//
//  Created by Liu Yang on 29/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLCustomCellBtn.h"

#pragma mark - VETUserInfoCell

/***********************************************************
 *  VETUserInfoCell
 ***********************************************************/

@interface VETUserInfoCell : UITableViewCell

/*
 *  头像View
 */
@property (nonatomic, retain) UIView *avatarView;
@property (nonatomic, retain) UIImageView *avatarImageView;
@property (nonatomic, retain) UILabel *addLabel;

/*
 *  NameView
 */
@property (nonatomic, retain) UIView *nameView;

@property (nonatomic, retain) UIView *firstNameView;
@property (nonatomic, retain) UITextField *firstNameTextfield;
@property (nonatomic, retain) UIView *line1View;

@property (nonatomic, retain) UIView *lastNameView;
@property (nonatomic, retain) UITextField *lastNameTextfield;
@property (nonatomic, retain) UIView *line2View;

@end

/***********************************************************
 *  VETMobileCell
 ***********************************************************/
#pragma mark - VETMobileCell

@interface VETMobileCell : UITableViewCell

@property (nonatomic, retain) PLCustomCellBtn *typeButton;
@property (nonatomic, retain) UITextField *contentTextfield;
@property (nonatomic, retain) UIView *lineView;

@end

/***********************************************************
 *  VETAddContactViewController
 ***********************************************************/
#pragma mark - VETAddContactViewController

@interface VETAddContactViewController : UITableViewController

@end
