//
//  VETAccountViewController.h
//  MobileVoip
//
//  Created by Liu Yang on 16/05/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VETAccount.h"

/***********************************************************
 *  VETSegmentView
 ***********************************************************/

@interface VETSegmentView : UIView

@property (nonatomic, retain) UILabel *hintLable;
@property (nonatomic, retain) UISegmentedControl *segmentControl;

@end

/***********************************************************
 *  VETAccountViewController
 ***********************************************************/
@interface VETAccountViewController : UIViewController

@property (nonatomic, retain) UITextField *displayTextfield;
@property (nonatomic, retain) UITextField *usernameTextfield;
@property (nonatomic, retain) UITextField *passwordTextfield;
@property (nonatomic, retain) UITextField *domainTextfield;
@property (nonatomic, retain) UISegmentedControl *transportSeg;
@property (nonatomic, retain) UISegmentedControl *encryptionSeg;
@property (nonatomic, retain) UITextField *portTextfield;

@property (nonatomic, assign) VETTransportType transportType;
@property (nonatomic, assign) VETEncryptionType encryptionType;

@end
