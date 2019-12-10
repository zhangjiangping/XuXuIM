//
//  MLCallContactTableView.m
//  minlePay
//
//  Created by JP on 2017/10/26.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLCallContactTableView.h"

@interface MLCallContactTableView () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation MLCallContactTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.sectionIndexBackgroundColor = [UIColor clearColor];
        self.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        self.tableFooterView = [UIView new];
        [self registerClass:NSClassFromString(@"AddContactCell") forCellReuseIdentifier:@"AddContactCell"];
    }
    return self;
}

#pragma mark - ContactTableView data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    //  显示收藏栏
//    if (_favorityArray.count > 0) {
//        return [_dataSourceBySection count] + 1;
//    }
//    return [_dataSourceBySection count];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    //  有收藏栏情况
//    if (_favorityArray.count > 0) {
//        if (section == 0) {
//            return _favorityArray.count + 1;
//        }
//        else {
//            return [[_dataSourceBySection objectAtIndex:(section - 1)] count];
//        }
//    }
//    return [[_dataSourceBySection objectAtIndex:(section)] count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"AddFriendCell";
//    AddContactsCell *cell = (AddContactsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[AddContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    VETAppleContact *contact;
//    if (_favorityArray.count > 0) {
//        if (indexPath.section == 0 && indexPath.row == 0) {
//            contact = [_favorityArray objectAtIndex:indexPath.row];
//            return [self setupFavoriteCell:tableView indexpath:indexPath];
//        }
//        else if (indexPath.section == 0) {
//            contact = [_favorityArray objectAtIndex:indexPath.row - 1];
//        }
//        else {
//            contact = [_dataSourceBySection objectAtIndex:indexPath.section - 1][indexPath.row];
//        }
//    }
//    else {
//        contact = [_dataSourceBySection objectAtIndex:indexPath.section][indexPath.row];
//    }
//    cell.contact = contact;
//    cell.callBtn.selectIndexpath = indexPath;
//    [cell.callBtn addTarget:self action:@selector(tapCallBtn:) forControlEvents:UIControlEventTouchUpInside];
//    return cell;
//}
//
//- (UITableViewCell *)setupFavoriteCell:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath
//{
//    static NSString *CellIdentifier = @"favoriteCell";
//    AddContactsCell *cell = (AddContactsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[AddContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    cell.imgV.image = [UIImage imageNamed:@"contact_favorite"];
//    cell.lb_up.text = NSLocalizedString(@"Favorites", @"Contacts");
//    cell.callBtn.hidden = YES;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    NSInteger newSection = section;
//    // 收藏栏headerview height
//    if (_favorityArray.count > 0) {
//        if (section == 0) {
//            return 0.0;
//        }
//        else {
//            newSection = section - 1;
//        }
//    }
//    if ([[_dataSourceBySection objectAtIndex:(newSection)] count] == 0) {
//        return 0.01;
//    }
//    return 22;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSInteger newSection = section;
//    // 收藏栏headerview
//    if (_favorityArray.count > 0) {
//        if (section == 0) {
//            VETContactFavoriteView *view = [[VETContactFavoriteView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 06.0)];
//            return view;
//        }
//        else {
//            newSection = section - 1;
//        }
//    }
//    if ([[_dataSourceBySection objectAtIndex:(newSection)] count] == 0){
//        return nil;
//    }
//    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:RGBCOLOR(0xf2, 0xf2, 0xf2)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 22)];
//    label.backgroundColor = [UIColor clearColor];
//    [label setText:[self.sectionTitles objectAtIndex:(newSection)]];
//    [contentView addSubview:label];
//    return contentView;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    VETAppleContact *contact;
//    // did select result contacts list
//    if (tableView == self.resultsTableController.tableView) {
//        contact = [self.resultsTableController.filteredContacts objectAtIndex:indexPath.row];
//    }
//    // did select contacts list
//    else {
//        if (_favorityArray.count > 0) {
//            // favorite提示页
//            if (indexPath.section == 0 && indexPath.row == 0) {
//                return;
//            }
//            // 收藏的Contact
//            else if (indexPath.section == 0) {
//                contact = _favorityArray[indexPath.row - 1];
//            }
//            else {
//                contact = [_dataSourceBySection objectAtIndex:indexPath.section - 1][indexPath.row];
//            }
//        }
//        else {
//            contact = [_dataSourceBySection objectAtIndex:indexPath.section][indexPath.row];
//        }
//    }
//    VETContactDetailViewController *detailContactVC = [VETContactDetailViewController new];
//    detailContactVC.contact = contact;
//    if (self.searchController.active) {
//        self.searchController.active = NO;
//        [self.navigationController pushViewController:detailContactVC animated:YES];
//    } else {
//        [self.navigationController pushViewController:detailContactVC animated:YES];
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.searchController.searchBar resignFirstResponder];
//}
//
////- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
////{
////    return [self getSectionIndexArray];
////}
//
//- (NSArray *)getSectionIndexArray
//{
//    NSMutableArray * existTitles = [NSMutableArray array];
//    //section数组为空的title过滤掉，不显示
//    for (int i = 0; i < [self.sectionTitles count]; i++) {
//        if (![_dataSourceBySection count]) break;
//        if ([_dataSourceBySection count] > i && [[_dataSourceBySection objectAtIndex:i] count] > 0) {
//            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
//        }
//    }
//    return existTitles;
//}

@end
