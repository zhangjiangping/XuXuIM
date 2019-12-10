//
//  DYContactsListViewController.h
//  DYBluetoothLock
//
//  Created by Young on 15/11/12.
//  Copyright (c) 2015年 youngLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETBaseTableViewController.h"

@protocol VETAddressBookViewControllerDelegate <NSObject>

- (void)selectPhone:(NSArray *)telsArr;

@end

@interface VETAddressBookViewController : VETBaseTableViewController

@property (weak, nonatomic)  id<VETAddressBookViewControllerDelegate> phoneDelegate;
//@property (nonatomic, strong) id<DialDelegate> delegate;
@property (nonatomic, assign) const NSString *myAccount;

@end
