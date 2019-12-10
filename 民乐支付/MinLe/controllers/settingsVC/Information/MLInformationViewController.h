//
//  MLInformationViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/20.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"

@protocol  BACKTOUXIANGDelegate <NSObject>

- (void)backActionWithImage:(UIImage *)img;

@end

@interface MLInformationViewController : BaseViewController

@property (nonatomic, weak) id <BACKTOUXIANGDelegate> backDelegate;

@property (nonatomic, strong) UIImage *photoImg;

- (void)upLoadReuest;

@end
