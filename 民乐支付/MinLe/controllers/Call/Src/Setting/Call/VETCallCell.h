//
//  VETCallCell.h
//  MobileVoip
//
//  Created by Liu Yang on 01/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETSwitchCell.h"

@class VETCallCell;

@protocol VETCallCellDelegate <NSObject>

- (void)tapSwitch:(UISwitch *)codecSwitch cell:(VETCallCell *)cell;

@end

@interface VETCallCell : VETSwitchCell

@property (nonatomic, assign) id<VETCallCellDelegate> delegate;

@end
