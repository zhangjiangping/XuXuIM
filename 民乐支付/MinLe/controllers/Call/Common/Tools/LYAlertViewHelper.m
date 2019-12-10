//
//  JDYAlertViewHelper.m
//  DSZJinDouYunApp
//
//  Created by Young on 15/12/30.
//  Copyright (c) 2015年 dsz. All rights reserved.
//

#import "LYAlertViewHelper.h"

@interface LYAlertViewHelper ()

@end

@implementation LYAlertViewHelper

+ (UIAlertController *)alertViewStrongWithTagert:(id)target title:(NSString *)title content:(NSString *)content confirmEvent:(ConfirmBlock)confirmBlock cancelEvent:(CancelBlock)cancelBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", "Common") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock(action);
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancle", "Common") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock(action);
        }
    }]];
    
    [target presentViewController:alert animated:YES completion:nil];
    return alert;
}

+ (UIAlertController *)alertViewStrongWithTagert:(id)target title:(NSString *)title content:(NSString *)content confirmEvent:(ConfirmBlock)confirmBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", "Common") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock(action);
        }
    }]];

    [target presentViewController:alert animated:YES completion:nil];
    return alert;
}

@end
