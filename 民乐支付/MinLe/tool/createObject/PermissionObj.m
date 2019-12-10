//
//  PermissionObj.m
//  uTel
//
//  Created by JP on 2017/6/28.
//  Copyright © 2017年 JP. All rights reserved.
//

#import "PermissionObj.h"
#import "objc/runtime.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <PhotosUI/PhotosUI.h>

@implementation PermissionObj

- (instancetype)init
{
    self = [super init];
    if (self) {
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    return self;
}

+ (PermissionObj *)sharedInstance {
    static PermissionObj *permission = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        permission = [[PermissionObj alloc] init];
    });
    return permission;
}

//判断相册权限
- (BOOL)isCanUsePhotos {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            return NO;
        } else if (author == kCLAuthorizationStatusNotDetermined) {
            NSLog(@"用户还没有做过选择");
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        } else if (status == PHAuthorizationStatusNotDetermined) {
            NSLog(@"用户还没有做过选择");
        }
    }
    return YES;
}

//判断相机权限
- (BOOL)isCanVideos
{
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //无权限
        return NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        NSLog(@"用户还没有做过选择");
    }
    return YES;
}

// 判断麦克风权限是否打开
- (BOOL)getMicrophonePermission
{
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) isAllow = 1;
            else isAllow = 0;
        }];
    }
    return isAllow;
}

//获取通讯录读取权限
- (void)getContactPermission:(BlockPermission)block;
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error) {
                    //拒绝访问
                    NSLog(@"Error: %@", error);
                    block(NO);
                } else if (!granted) {
                    block(NO);
                } else {
                    block(YES);
                }
            }];
        } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            block(YES);
        } else {
            block(NO);
        }
    } else {
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        //拒绝访问
                        NSLog(@"Error: %@", error);
                        block(NO);
                    } else {
                        if (granted) {
                            block(YES);
                        } else {
                            block(NO);
                        }
                    }
                });
            });
        } else if (authStatus == kABAuthorizationStatusAuthorized) {
            block(YES);
        } else{
            block(NO);
        }
    }
}

@end
