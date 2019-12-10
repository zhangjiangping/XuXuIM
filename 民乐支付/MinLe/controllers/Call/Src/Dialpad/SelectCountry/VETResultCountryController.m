//
//  VETResultCountryController.m
//  MobileVoip
//
//  Created by Liu Yang on 03/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETResultCountryController.h"
#import "VETCountryCell.h"
#import "VETCountry.h"

@implementation VETResultCountryController

- (instancetype)init
{
    if (self = [super init]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredCountry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VETCountryCell *cell = (VETCountryCell *)[tableView dequeueReusableCellWithIdentifier:kCellIndentifier];
    if (cell == nil) {
        cell = [[VETCountryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIndentifier];
    }
    VETCountry *country = self.filteredCountry[indexPath.row];
    [self configCell:cell forCountryInfo:country atIndexPath:indexPath];
    return cell;
}

@end
