//
//  VETCallSettingViewController.m
//  MobileVoip
//
//  Created by Liu Yang on 01/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCallSettingViewController.h"
#import "VETCallCell.h"

@interface VETCallSettingViewController ()<VETCallCellDelegate>

@property (nonatomic, strong) NSMutableArray *menuArray;

@end

@implementation VETCallSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuArray = [[NSMutableArray alloc] init];
    [_menuArray addObject:@"Send inband DTMFs"];
    [_menuArray addObject:@"Send SIP INFO DTMFs"];
    [_menuArray addObject:@"Repeat call notification"];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellId = @"call";
    VETCallCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[VETCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    cell.textLabel.text = _menuArray[indexPath.row];
    return cell;
}

- (void)tapSwitch:(UISwitch *)codecSwitch cell:(VETCallCell *)cell
{
    UISwitch *switchButton = codecSwitch;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        
    }
    else {
        
    }
}

@end
