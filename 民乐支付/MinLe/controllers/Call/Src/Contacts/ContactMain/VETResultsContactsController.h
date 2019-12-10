//
//  VETSearchContacts.h
//  VETEphone
//
//  Created by Liu Yang on 31/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETBaseTableViewController.h"

@protocol VETResultsContactsDidSelectedDismissDelegate <NSObject>

- (void)didSelectedDismiss:(VETAppleContact *)contact;

- (void)resultsContactsHideKeyboard;

- (void)searchControllerDissmiss;

@end

@interface VETResultsContactsController : VETBaseTableViewController

@property (nonatomic, strong) NSArray *filteredContacts;

@property (nonatomic, weak) id <VETResultsContactsDidSelectedDismissDelegate> delegate;

@end
