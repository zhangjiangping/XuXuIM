//
//  VETCountryBaseTableController.h
//  MobileVoip
//
//  Created by Liu Yang on 03/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VETCountryCell;

extern NSString *const kCellIndentifier;

@interface VETCountryBaseTableController : UITableViewController

- (void)configCell:(VETCountryCell *)cell forCountryInfo:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end
