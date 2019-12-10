//
//  MLAccountSettlementView.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/24.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLAccountSettlementView.h"

@interface MLAccountSettlementView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *img;
@end

@implementation MLAccountSettlementView

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.array = dataArray[0];
        self.myArray = dataArray[1];
        
        [self addSubview:self.table];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type withDataArray:(NSArray *)dataArray
{
    /*
     type : 审核状态
     1 = 审核成功
     2 = 审核失败
     0 = 审核中
     */
    self = [super initWithFrame:frame];
    if (self) {
        
        [self hideLayer];
                
        self.array = dataArray[0];
        self.myArray = dataArray[1];
        
        _type = type;
        
        [self addSubview:self.table];
        
        if ([type isEqualToString:@"0"]) {
            self.img.image = [UIImage imageNamed:@"ing"];
        } else if ([type isEqualToString:@"1"]) {
            self.img.image = [UIImage imageNamed:@"success-1"];
        } else {
            self.img.image = [UIImage imageNamed:@"failure"];
        }
        [self addSubview:self.img];
    }
    return self;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc] initWithFrame:self.bounds];
        _img.clipsToBounds = YES;
    }
    return _img;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, widths, heights-40) style:UITableViewStylePlain];
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
    cell.textLabel.text = _myArray[indexPath.row];
    cell.detailTextLabel.contentMode = UIViewContentModeScaleAspectFill;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.type && indexPath.row == _array.count-1) {
        if ([self.type isEqualToString:@"0"]) {
            cell.detailTextLabel.textColor = [ColorsUtil colorWithHexString:@"#929294"];
            cell.detailTextLabel.text = [CommenUtil LocalizedString:@"Asset.Review"];
        } else if ([self.type isEqualToString:@"1"]) {
            cell.detailTextLabel.textColor = [ColorsUtil colorWithHexString:@"#008ada"];
            cell.detailTextLabel.text = [CommenUtil LocalizedString:@"Settle.ReviewSuccess"];
        } else {
            cell.detailTextLabel.textColor = [ColorsUtil colorWithHexString:@"#ff0000"];
            cell.detailTextLabel.text = [CommenUtil LocalizedString:@"Settle.ReviewFaile"];
        }
    } else {
        cell.detailTextLabel.textColor = [ColorsUtil colorWithHexString:@"#929294"];
        cell.detailTextLabel.text = _array[indexPath.row];
    }
    return cell;
}



@end
