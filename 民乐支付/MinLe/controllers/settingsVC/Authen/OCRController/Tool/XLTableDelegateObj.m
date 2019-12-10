//
//  XLTableDelegateObj.m
//  IDAndBankCard
//
//  Created by mxl on 2017/3/28.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "XLTableDelegateObj.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const tableReuse = @"tableReuse";

@implementation XLTableDelegateObj

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableReuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableReuse];
    }
    cell.textLabel.text = (indexPath.row == 0) ? [CommenUtil LocalizedString:@"Authen.BankScan"] : [CommenUtil LocalizedString:@"Authen.IDScan"];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectSubject sendNext:indexPath];
}

- (RACSubject *)selectSubject {
    if (_selectSubject == nil) {
        _selectSubject = [RACSubject subject];
    }
    return _selectSubject;
}

@end
