//
//  MLHomeViewController.h
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/10/13.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "BaseViewController.h"
#import "VETVoipAccount.h"

@interface MLHomeViewController : BaseViewController

//当前用户
@property (nonatomic, strong) VETVoipAccount *currentVoipAccount;
@property (nonatomic, assign) VETAccountStatus status;
@property (nonatomic, assign) BOOL  isReconectCancled;;
@property (nonatomic, assign) BOOL  isLoginSuccess;
@property (strong, readwrite, nonatomic) dispatch_source_t connectTimer;

@end
