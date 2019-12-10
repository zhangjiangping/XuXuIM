//
//  VETSelectMobileTypeViewController.h
//  VETEphone
//
//  Created by Liu Yang on 30/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VETSelectMobileTypeViewControllerDelegate <NSObject>

- (void)didTapString:(NSString *)string;

@end

@interface VETSelectMobileTypeViewController : UITableViewController

@property (nonatomic, assign) id<VETSelectMobileTypeViewControllerDelegate> delegate;

@end
