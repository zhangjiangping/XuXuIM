//
//  UITableView+LYXExtension.m
//  MobileVoip
//
//  Created by Liu Yang on 06/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "UITableView+LYXExtension.h"

@implementation UITableView (LYXExtension)

- (void)removeExtraLine:(LYXTableViewRemoveExtraLineType)type
{
    switch (type) {
        case LYXTableViewRemoveExtraLineTypeIncludeLastLine:{
            self.tableFooterView = [UIView new];
            break;
        }
        // TODO:implement heightForFooterInSection
        case LYXTableViewRemoveExtraLineTypeExcludeLastLine:{
            break;
        }
        default:
            break;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.0;
//}

@end
