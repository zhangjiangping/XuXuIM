//
//  VETSelectMobileTypeViewController.m
//  VETEphone
//
//  Created by Liu Yang on 30/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETSelectMobileTypeViewController.h"

@interface VETSelectMobileTypeViewController ()

@property (nonatomic, retain) NSArray *array;

@end

@implementation VETSelectMobileTypeViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = @[[CommenUtil LocalizedString:@"Call.Home"],
               [CommenUtil LocalizedString:@"Call.Work"],
               [CommenUtil LocalizedString:@"Call.iPhone"],
               [CommenUtil LocalizedString:@"Call.Mobile"],
               [CommenUtil LocalizedString:@"Call.Main"],
               [CommenUtil LocalizedString:@"Call.HomeFax"],
               [CommenUtil LocalizedString:@"Call.WorkFax"],
               [CommenUtil LocalizedString:@"Call.Pager"],
               [CommenUtil LocalizedString:@"Call.Other"],
               [CommenUtil LocalizedString:@"Call.OtherFax"]];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = _array[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapString:)]) {
        [self.delegate didTapString:_array[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
