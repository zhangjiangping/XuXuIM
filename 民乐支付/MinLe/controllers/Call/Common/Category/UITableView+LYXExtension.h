//
//  UITableView+LYXExtension.h
//  MobileVoip
//
//  Created by Liu Yang on 06/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LYXTableViewRemoveExtraLineType) {
    LYXTableViewRemoveExtraLineTypeIncludeLastLine, // 包含最后一行线
    LYXTableViewRemoveExtraLineTypeExcludeLastLine, // 不包含最后一行线
};

@interface UITableView (LYXExtension)

- (void)removeExtraLine:(LYXTableViewRemoveExtraLineType)type;

@end
