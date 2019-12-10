//
//  VETSwitchCell.h
//  MobileVoip
//
//  Created by Liu Yang on 01/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VETSwitchCell : UITableViewCell

@property (nonatomic, retain) UISwitch *switchBtn;

// subclass implementation
- (void)tapSwitch:(id)sender;

@end
