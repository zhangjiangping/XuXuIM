//
//  VETBaseTableViewController.h
//  VETEphone
//
//  Created by Liu Yang on 31/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VETAppleContact;
@class AddContactsCell;

extern NSString *const kCellIdentifier;

#define bottomHeight 65

@interface VETBaseTableViewController : UIViewController

@property (nonatomic, retain) UITableView *tableView;

- (void)configCell:(AddContactsCell *)cell forContacts:(VETAppleContact *)contacts atIndexPath:(NSIndexPath *)indexPath;
- (void)tapCallBtn:(id)sender;

@end
