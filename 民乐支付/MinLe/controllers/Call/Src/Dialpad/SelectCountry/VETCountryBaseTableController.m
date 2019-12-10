//
//  VETCountryBaseTableController.m
//  MobileVoip
//
//  Created by Liu Yang on 03/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETCountryBaseTableController.h"
#import "VETCountryCell.h"
#import "VETCountry.h"

NSString *const kCellIndentifier = @"cellID";
NSString *const kCellClassName = @"VETCountryCell";

@interface VETCountryBaseTableController ()

@end

@implementation VETCountryBaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    [self.tableView registerClass:NSClassFromString(kCellClassName) forCellReuseIdentifier:kCellIndentifier];
}
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

- (void)configCell:(VETCountryCell *)cell forCountryInfo:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    VETCountry *country = (VETCountry *)object;
    cell.countryLogo.image = [UIImage imageNamed:country.icon];
    if ([CommenUtil isChinaLanguage]) {
        cell.leftLabel.text = country.countryChineseName;
    } else {
        cell.leftLabel.text = country.countryEnglishName;
    }
    cell.rigLabel.text = [NSString stringWithFormat:@"(+%@)",country.code];
}

@end
