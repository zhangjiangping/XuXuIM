//
//  UIViewController+XHPhoto.h

//  XHPhotoExample
//
//  Created by xiaohui on 16/6/6.
//  Copyright © 2016年 qiantou. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHPhoto

#import <UIKit/UIKit.h>

typedef void(^photoBlock)(UIImage *photo);
typedef void(^TureBlock)(int index);
typedef void(^LogoutBlock)();

@interface UIViewController (XHPhoto)

/**
 *  照片选择->图库/相机
 *
 *  @param edit  照片是否需要裁剪,默认NO
 *  @param block 照片回调
 */
- (void)showCanEdit:(BOOL)edit photo:(photoBlock)block;

//只获取相机
- (void)showCanCameraEdit:(BOOL)edit photo:(photoBlock)block;

//弹出权限视图
- (void)showPermission:(NSString *)noPermissionName;

- (void)actionSheetTypeWithContentArray:(NSArray *)array confirmEvent:(TureBlock)tureBlock cancelEvent:(LogoutBlock)logoutBlock;
- (void)actionViewTypeWithTitle:(NSString *)title withMessage:(NSString *)message withContent:(NSString *)content confirmEvent:(TureBlock)tureBlock cancelEvent:(LogoutBlock)logoutBlock;

@end
