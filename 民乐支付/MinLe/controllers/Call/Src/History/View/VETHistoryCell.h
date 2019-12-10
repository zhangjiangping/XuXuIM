//
//  VETHistoryCell.h
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PLCustomCellBtn;
@class VETCallRecord;

@interface VETHistoryCell : UITableViewCell

@property (nonatomic, retain) UIImageView *statusImageView;
@property (nonatomic, retain) UILabel *phoneLabel;
@property (nonatomic, retain) UILabel *stausLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) PLCustomCellBtn *detailButton;
@property (nonatomic, assign, getter = isShowLine) BOOL showLine;

@property (nonatomic, retain) VETCallRecord *record;

@end
