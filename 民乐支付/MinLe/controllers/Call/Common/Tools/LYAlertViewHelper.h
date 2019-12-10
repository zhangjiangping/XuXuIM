//
//  JDYAlertViewHelper.h
//  DSZJinDouYunApp
//
//  Created by Young on 15/12/30.
//  Copyright (c) 2015年 dsz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ConfirmBlock)(UIAlertAction *action);
typedef void(^CancelBlock)(UIAlertAction *action);

@interface LYAlertViewHelper : NSObject

/**
 *  确认取消按钮 
 *
 */
+ (UIAlertController *)alertViewStrongWithTagert:(id)target title:(NSString *)title content:(NSString *)content confirmEvent:(ConfirmBlock)confirmBlock cancelEvent:(CancelBlock)cancelBlock;

/**
 *  确认按钮 
 *
 */
+ (UIAlertController *)alertViewStrongWithTagert:(id)target title:(NSString *)title content:(NSString *)content confirmEvent:(ConfirmBlock)confirmBlock;

@end
