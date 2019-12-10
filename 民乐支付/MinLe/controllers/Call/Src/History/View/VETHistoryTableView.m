//
//  VETHistoryTableView.m
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import "VETHistoryTableView.h"
#import "VETHistoryCell.h"
#import "DBUtil.h"
#import "PLCustomCellBtn.h"
#import "NSDate+LYXExtension.h"
#import "NSDateFormatter+Category.h"

@interface VETHistoryTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *mutableArrary;
@property (nonatomic, retain) UILabel *textLabel;

@end

@implementation VETHistoryTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setups];
    }
    return self;
}

- (void)setups {
    self.dataSource = self;
    self.delegate = self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [_mutableArrary removeAllObjects];
    _mutableArrary = [NSMutableArray arrayWithArray:_dataArray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!(_mutableArrary.count > 0)) {
        if (_textLabel == nil) {
            _textLabel = [UILabel new];
            _textLabel.textAlignment = NSTextAlignmentCenter;
            _textLabel.textColor = [UIColor lightGrayColor];
            _textLabel.font = [UIFont systemFontOfSize:20.0];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.backgroundView = _textLabel;
            _textLabel.text = [CommenUtil LocalizedString:@"Call.NoRecord"];
        });
    }
    else {
        _textLabel.text = @"";
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mutableArrary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    VETHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VETHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    VETCallRecord *record = _mutableArrary[indexPath.row];
    [cell setRecord:record];
    
    [cell.detailButton addTarget:self action:@selector(tapPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.detailButton.selectIndexpath = indexPath;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VETCallRecord *record = _mutableArrary[indexPath.row];
    if (self.historyDelegate && [self.historyDelegate respondsToSelector:@selector(historyTableView:didSelectRow:type:)]) {
        [self.historyDelegate historyTableView:self didSelectRow:record type:_type];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    VETCallRecord *record = _mutableArrary[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.historyDelegate && [self.historyDelegate respondsToSelector:@selector(historyTableView:didSelectRow:type:)]) {
            [_mutableArrary removeObjectAtIndex:indexPath.row];
            [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.historyDelegate historyTableView:self didDeleteRow:indexPath record:record type:VETHistoryTableViewTypeAllRecord];
        }
    }
}

- (void)tapPhoneBtn:(id)sender {
    PLCustomCellBtn *btn = (PLCustomCellBtn*)sender;
    NSIndexPath *indexPath = btn.selectIndexpath;
    VETCallRecord *record = _mutableArrary[indexPath.row];
    if (record.account.length > 0) {
        if (self.historyDelegate && [self.historyDelegate respondsToSelector:@selector(historyTableView:withPhone:type:)]) {
            [self.historyDelegate historyTableView:self withPhone:record.account type:_type];
        }
    }
}

@end
