//
//  VETHistorySegmentViewController.h
//  MobileVoip
//
//  Created by Liu Yang on 16/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VETVoipAccount.h"

@protocol VETAddressBookViewControllerDelegate <NSObject>

- (void)selectPhone:(NSArray *)telsArr;

@end

@interface VETHistorySegmentViewController : BaseViewController

@property (weak, nonatomic)  id<VETAddressBookViewControllerDelegate> phoneDelegate;

@property (nonatomic, assign) const NSString *myAccount;
@property (nonatomic, assign) VETAccountStatus status;

@end
