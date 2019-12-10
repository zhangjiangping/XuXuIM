//
//  MLDetailsView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/21.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLDetailsView.h"

@interface MLDetailsView () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *nameArray;
}
@end

@implementation MLDetailsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        nameArray = @[[CommenUtil LocalizedString:@"Account.MerchantsReferred"],
                      [CommenUtil LocalizedString:@"Account.MerchantsAllName"],
                      [CommenUtil LocalizedString:@"Account.LegalName"],
                      [CommenUtil LocalizedString:@"Account.ContractRate"],
                      [CommenUtil LocalizedString:@"Account.ContractNo"],
                      [CommenUtil LocalizedString:@"Account.SigningDate"],
                      [CommenUtil LocalizedString:@"Account.AsOfDate"]];
        [self addSubview:self.table];
    }
    return self;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, widths, heights-70) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [[UIView alloc] init];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.scrollEnabled = NO;
    }
    return _table;
}

#pragma mark - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"myDetailsViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = nameArray[indexPath.row];
    cell.detailTextLabel.text = _array[indexPath.row];
    cell.detailTextLabel.contentMode = UIViewContentModeScaleAspectFill;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
