//
//  MLAnnouncementViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/28.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@protocol BackActionDelegate <NSObject>

- (void)BackAction;

@end

@interface MLAnnouncementViewController : BaseViewController

@property (nonatomic, weak) id<BackActionDelegate> announceDelegate;

@end
