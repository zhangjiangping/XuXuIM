//
//  VETSettingViewController.m
//  LYXAnimatoinDemo
//
//  Created by young on 21/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import "VETSettingViewController.h"
#import "DYPlaceHolderTextCell.h"
#import "DYProfileAvtarCell.h"
#import "AppDelegate.h"
#import "VETChangeAccountViewController.h"
#import "VETCodecViewController.h"
#import "VETCallSettingViewController.h"
#import "VETProfileViewController.h"
#import "VETNetworkViewController.h"
#import "VETAboutUsViewController.h"

@interface VETSettingViewController ()

@end

@implementation VETSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"Settings", @"Language", nil);
    //self.title = NSLocalizedString(@"Settings", @"Settings");
    self.navigationController.navigationBar.tintColor = MAINTHEMECOLOR;
    self.view.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);
    self.tableView.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    self.tabBarController.tabBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    self.tabBarController.navigationItem.title = NSLocalizedString(@"Settings", @"Settings");
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: {
            return 1;
            break;
        }
        case 1: {
            return 2;
            break;
        }
        case 2: {
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
        return 80;
    }
    else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        DYProfileAvtarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatarCell"];
        return [self setupProfileCell:cell];
    }
//    else if (indexPath.section == 1 && indexPath.row == 0) {
//        DYPlaceHolderTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
//        return [self setupTextAndDisclosureCell:cell text:NSLocalizedString(@"Call", @"Settings") imageName:@"setting_call"];
//    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        DYPlaceHolderTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        return [self setupTextAndDisclosureCell:cell text:NSLocalizedString(@"Audio", @"Settings") imageName:@"setting_audio"];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        DYPlaceHolderTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        DYPlaceHolderTextCell *cellResult = [self setupTextAndDisclosureCell:cell text:NSLocalizedString(@"Network", @"Settings") imageName:@"setting_network"];
        cellResult.showLine = NO;
        return cellResult;
    }
//    else if (indexPath.section == 2 && indexPath.row == 0) {
//        DYPlaceHolderTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
//        return [self setupTextAndDisclosureCell:cell text:NSLocalizedString(@"Notifications", @"Settings") imageName:@"setting_notification"];
//    }
//    else if (indexPath.section == 2 && indexPath.row == 0) {
//        DYPlaceHolderTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
//        return [self setupTextAndDisclosureCell:cell text:NSLocalizedString(@"FAQ", @"Settings") imageName:@"setting_faq"];
//    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        DYPlaceHolderTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        DYPlaceHolderTextCell *cellResult = [self setupTextAndDisclosureCell:cell text:NSLocalizedString(@"About", @"Settings") imageName:@"setting_about"];
        cellResult.showLine = NO;
        return cellResult;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //  切换帐号
    if (indexPath.section == 0) {
        VETProfileViewController *profile = [VETProfileViewController new];
        [self.navigationController pushViewController:profile animated:YES];
    }
   
    //  Call
//    else if (indexPath.section == 1 && indexPath.row == 0) {
//        VETCallSettingViewController *callSetting = [VETCallSettingViewController new];
//        [self.navigationController pushViewController:callSetting animated:YES];
//    }
    //  Audio-Codec
    else if (indexPath.section == 1 && indexPath.row == 0) {
        VETCodecViewController *codecVC = [VETCodecViewController new];
        [self.navigationController pushViewController:codecVC animated:YES];
    }
    //  Network
    else if (indexPath.section == 1 && indexPath.row == 1) {
        VETNetworkViewController *networkVC = [VETNetworkViewController new];
        [self.navigationController pushViewController:networkVC animated:YES];
    }
    //  Network
    else if (indexPath.section == 2 && indexPath.row == 0) {
        VETAboutUsViewController *vc = [VETAboutUsViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = RGBCOLOR(0xef, 0xef, 0xf4);;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.0;
    }
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        return view;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    }
    else {
        return 0.0;
    }
}

- (DYProfileAvtarCell *)setupProfileCell:(DYProfileAvtarCell *)cell;
{
    if (cell == nil) {
        cell = [[DYProfileAvtarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"avatarCell"];
    }
    cell.avtarImageView.image =  [UIImage imageNamed:@"avatar"];;
    cell.title = [[VETUserManager sharedInstance] currentUsername];
    cell.showLine = YES;
    cell.showDisclosure = YES;
    return cell;
}

- (DYPlaceHolderTextCell *)setupTextAndDisclosureCell:(DYPlaceHolderTextCell *)cell text:(NSString *)text imageName:(NSString *)imageName{
    if (cell == nil) {
        cell = [[DYPlaceHolderTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.leftImageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = text;
    cell.showLine = YES;
    cell.rightImageView.image = [UIImage imageNamed:@"arrow"];
    return cell;
}

@end
