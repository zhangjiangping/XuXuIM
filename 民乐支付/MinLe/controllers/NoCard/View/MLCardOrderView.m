//
//  MLCardOrderView.m
//  minlePay
//
//  Created by JP on 2017/10/17.
//  Copyright © 2017年 Jiangsu Minle Data Service Co., Ltd. All rights reserved.
//

#import "MLCardOrderView.h"
#import "CardOrderCell.h"
#import "Data.h"

#define rowHeight 110

@interface MLCardOrderView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UILabel *emptyLable;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MLCardOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
        [_table registerClass:[CardOrderCell class] forCellReuseIdentifier:@"CardOrderCell"];
        [self addSubview:_table];
        [self addSubview:self.emptyLable];
    }
    return self;
}

- (void)updata:(NSArray *)dataArray
{
    _dataArray = [NSArray arrayWithArray:dataArray];
    
    if (_dataArray.count == 0) {
        _emptyLable.hidden = NO;
        _table.hidden = YES;
    } else {
        _emptyLable.hidden = YES;
        _table.hidden = NO;
        
        [_table reloadData];
    }
}

- (UILabel *)emptyLable
{
    if (!_emptyLable) {
        _emptyLable = [[UILabel alloc] initWithFrame:CGRectMake(15, (heights-50)/2, widths-30, 50)];
        _emptyLable.text = [CommenUtil LocalizedString:@"NoCard.NotOrderRecoder"];
        _emptyLable.font = [UIFont boldSystemFontOfSize:18];
        _emptyLable.numberOfLines = 0;
        _emptyLable.textAlignment = NSTextAlignmentCenter;
        _emptyLable.hidden = YES;
    }
    return _emptyLable;
}

#pragma mark - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardOrderCell *centerCell = [tableView dequeueReusableCellWithIdentifier:@"CardOrderCell" forIndexPath:indexPath];
    [centerCell setModel:_dataArray[indexPath.row]];
    return centerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
