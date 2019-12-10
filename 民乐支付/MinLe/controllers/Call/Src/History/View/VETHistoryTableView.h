//
//  VETHistoryTableView.h
//  LYXAnimatoinDemo
//
//  Created by Liu Yang on 22/03/2017.
//  Copyright © 2017 young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VETHistoryTableViewType) {
    VETHistoryTableViewTypeAllRecord,
    VETHistoryTableViewTypeMissedRecord,
};

@class VETHistoryTableView;
@class VETCallRecord;

@protocol VETHistoryTableViewDelegate <NSObject>

@optional
- (void)historyTableView:(VETHistoryTableView *)tableView withPhone:(NSString *)phone type:(VETHistoryTableViewType)type;
- (void)historyTableView:(VETHistoryTableView *)tableView didSelectRow:(VETCallRecord *)callRecord type:(VETHistoryTableViewType)type;
- (void)historyTableView:(VETHistoryTableView *)tableView didDeleteRow:(NSIndexPath *)indexPath record:(VETCallRecord *)callRecord type:(VETHistoryTableViewType)type;

@end

@interface VETHistoryTableView : UITableView

@property (nonatomic, assign) VETHistoryTableViewType type;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, assign) id<VETHistoryTableViewDelegate> historyDelegate;

@end
