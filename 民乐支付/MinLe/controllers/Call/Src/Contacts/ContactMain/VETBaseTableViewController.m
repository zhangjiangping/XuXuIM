//
//  VETBaseTableViewController.m
//  VETEphone
//
//  Created by Liu Yang on 31/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETBaseTableViewController.h"
#import "AddContactsCell.h"
#import "VETAppleContact.h"

NSString *const kCellIdentifier = @"cellID";
NSString *const kTableCellClassName = @"AddContactsCell";

@interface VETBaseTableViewController ()

@end

@implementation VETBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - bottomHeight)];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    [self.tableView registerClass:NSClassFromString(kTableCellClassName) forCellReuseIdentifier:kCellIdentifier];
}

- (void)configCell:(AddContactsCell *)cell forContacts:(VETAppleContact *)contact atIndexPath:(NSIndexPath *)indexPath
{
    cell.contact = contact;
    cell.callBtn.selectIndexpath = indexPath;
}

- (void)tapCallBtn:(id)sender
{
    
}

@end
