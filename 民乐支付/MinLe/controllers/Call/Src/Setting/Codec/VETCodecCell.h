//
//  VETCodecCellTest.h
//  MobileVoip
//
//  Created by Liu Yang on 01/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETSwitchCell.h"

/***********************************************************
 *  VETCodecInfo
 ***********************************************************/
@interface VETCodecInfo : NSObject <NSCoding>

@property (nonatomic, retain) NSString *codecId;
@property (nonatomic, retain) NSNumber *priority;

- (instancetype)initWithCodecId:(NSString *)codecId priority:(NSUInteger)priority;

@end

/***********************************************************
 *  VETCodecCell
 ***********************************************************/
@class VETCodecCell;

@protocol VETCodecCellDelegate <NSObject>

- (void)tapSwitch:(UISwitch *)codecSwitch cell:(VETCodecCell *)cell;

@end

@interface VETCodecCell : VETSwitchCell

@property (nonatomic, retain) VETCodecInfo *codecInfo;
@property (nonatomic, assign) id<VETCodecCellDelegate> delegate;

@end
