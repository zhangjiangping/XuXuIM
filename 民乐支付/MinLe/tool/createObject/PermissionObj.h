//
//  PermissionObj.h
//  uTel
//
//  Created by JP on 2017/6/28.
//  Copyright © 2017年 JP. All rights reserved.
//

#import <Foundation/Foundation.h>
/// iOS 9前的框架
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
/// iOS 9的新框架
#import <ContactsUI/ContactsUI.h>

typedef void(^BlockPermission)(BOOL isPermission);

@interface PermissionObj : NSObject

@property (nonatomic, assign) ABAddressBookRef addressBook;

+ (PermissionObj *)sharedInstance;

//判断相册权限
- (BOOL)isCanUsePhotos;

//判断相机权限
- (BOOL)isCanVideos;

// 判断麦克风权限是否打开
- (BOOL)getMicrophonePermission;

// 判断通讯录权限是否打开
- (void)getContactPermission:(BlockPermission)block;

@end
