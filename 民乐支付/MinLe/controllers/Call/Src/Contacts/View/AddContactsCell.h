//
//  AddContactsCell.h
//  Manager
//
//  Created by Apple on 15/8/19.
//  Copyright (c) 2015年 LXJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLCustomCellBtn.h"

@class VETAppleContact;

@interface AddContactsCell : UITableViewCell


@property (retain, nonatomic) VETAppleContact *contact;
@property (retain, nonatomic) PLCustomCellBtn *callBtn;
@property (strong, nonatomic) UIImageView *imgV;
@property (strong, nonatomic) UILabel *nameAbbreviation;

@property (retain, nonatomic) UILabel *lb_up;
@property (retain, nonatomic) UILabel *lb_down;
@property (strong, nonatomic) UILabel *lb_noti;

-(void)showBtn;
-(void)showLb;

@end
