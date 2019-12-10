//
//  VETProfileViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 08/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETProfileViewController.h"
#import "DYPlaceHolderTextCell.h"
#import "DYProfileAvtarCell.h"
#import "AppDelegate.h"
#import "DBUtil.h"
#import "VETLogoutHelper.h"
#import "DYPlaceHolderTextCell.h"

@interface VETProfileViewController ()

@end

@implementation VETProfileViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVETViewControllerRefreshBalanceNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Balance", @"Setting");
    self.view.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);
    self.tableView.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voipRefreshBalance:) name:kVETViewControllerRefreshBalanceNotification object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            return 2;
            break;
        }
        case 1: {
            return 1;
            break;
        }
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 80 : 50;
    }
    else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0 && indexPath.row == 0) {
        DYProfileAvtarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatarCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return [self setupProfileCell:cell];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        static NSString *identifer = @"balance";
        DYPlaceHolderTextCell *cell = (DYPlaceHolderTextCell *)[tableView dequeueReusableCellWithIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return [self setupTextAndDisclosureCell:cell text:NSLocalizedString(@"Balance", @"Setting")];;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString *identifer = @"logoutcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        return [self logoutCell:cell];
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);
    return view;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.0;
    }
    return 30.0;
}

- (UITableViewCell *)logoutCell:(UITableViewCell *)cell
{
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logoutcell"];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:16.0];
        label.text = NSLocalizedString(@"Sign out", @"Setting");
        [cell.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.mas_equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [VETLogoutHelper logoutAccount];
    }
}

- (DYProfileAvtarCell *)setupProfileCell:(DYProfileAvtarCell *)cell
{
    if (cell == nil) {
        cell = [[DYProfileAvtarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"avatarCell"];
    }
    cell.title = [[VETUserManager sharedInstance] currentUsername];
    cell.avtarImageView.image =  [UIImage imageNamed:@"avatar"];;
    cell.showLine = YES;
    cell.showDisclosure = NO;
    return cell;
}

- (DYPlaceHolderTextCell *)setupTextAndDisclosureCell:(DYPlaceHolderTextCell *)cell text:(NSString *)text{
    if (cell == nil) {
        cell = [[DYPlaceHolderTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.leftImageView.image = [UIImage imageNamed:@"setting_balance"];
    cell.textLabel.text = text;
    cell.placeHolderLabel.textColor = [UIColor blackColor];
    cell.showLine = YES;
    
    NSString *balanceStr = [[VETUserManager sharedInstance] balance];
    if ([balanceStr floatValue] > 0) {
        cell.placeHolder = [NSString stringWithFormat:@"%@%@", CURRENCY_CODE, [[VETUserManager sharedInstance] balance]];
    }
    else {
        cell.placeHolder = [[VETUserManager sharedInstance] balance];
    }
    return cell;
}

- (void)voipRefreshBalance:(id)notification
{
    NSLog(@"balance:%@", [[VETUserManager sharedInstance] balance]);
    DYPlaceHolderTextCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.placeHolderLabel.text = [[VETUserManager sharedInstance] balance];
}

@end
