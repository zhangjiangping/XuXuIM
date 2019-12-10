//
//  DYProfileAvtarCell.h
//  DunyunLock
//
//  Created by young on 16/4/13.
//  Copyright © 2016年 duyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYProfileAvtarCell : UITableViewCell

@property (nonatomic, retain) UIImageView *avtarImageView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter = isShowLine) BOOL showLine;
@property (nonatomic, assign, getter = isShowDisclosure) BOOL showDisclosure;

@end
