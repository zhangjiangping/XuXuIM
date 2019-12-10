//
//  DYProfileTextCell.h
//  DunyunLock
//
//  Created by young on 16/4/13.
//  Copyright © 2016年 duyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYPlaceHolderTextCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, assign, getter=isShowLine) BOOL showLine;
@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) UIImageView *leftImageView;
@property (nonatomic, retain) UIImageView *rightImageView;

@end
