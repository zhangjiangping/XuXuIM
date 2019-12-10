//
//  VETOutgoingViewController.h
//  MobileVoip
//
//  Created by Liu Yang on 09/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VETVoipCall;
@class VETCallRecord;
@class VETCallingMainView;

@interface VETCallingMainViewController : UIViewController

@property (nonatomic, strong, readonly) VETCallingMainView *mainView;

@property (nonatomic, retain) NSString *callPhone;

@property (nonatomic, retain, readonly) VETCallRecord *vetNewRecord;

//  call or incomingcall
@property (nonatomic, retain) VETVoipCall *call;

- (void)endCallOperation;

@end
