//
//  UIViewController+XHPhoto.m

//  XHPhotoExample
//
//  Created by xiaohui on 16/6/6.
//  Copyright © 2016年 qiantou. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHPhoto

#import "UIViewController+XHPhoto.h"
#import "objc/runtime.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "PermissionObj.h"

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#else
#define debugLog(...)
#endif

static  BOOL canEdit = NO;
static  char blockKey;

@interface UIViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,copy)photoBlock photoBlock;

@end

@implementation UIViewController (XHPhoto)

#pragma mark-set
- (void)setPhotoBlock:(photoBlock)photoBlock
{
    objc_setAssociatedObject(self, &blockKey, photoBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark-get

- (photoBlock )photoBlock
{
    return objc_getAssociatedObject(self, &blockKey);
}

//获取相册和相机
- (void)showCanEdit:(BOOL)edit photo:(photoBlock)block
{
    if (edit) canEdit = edit;
    
    self.photoBlock = [block copy];
    
    [self actionSheetTypeWithContentArray:@[[CommenUtil LocalizedString:@"Permission.Photos"],[CommenUtil LocalizedString:@"Permission.PhotoAlbumFor"]] confirmEvent:^(int index) {
        if (index == 0) {
            [self cameraActionWithIndex:index];
        } else if (index == 1) {
            [self photoActionWithIndex:index];
        }
    } cancelEvent:nil];
}

//只获取相机
- (void)showCanCameraEdit:(BOOL)edit photo:(photoBlock)block
{
    if(edit) canEdit = edit;
    
    self.photoBlock = [block copy];
    
    [self actionSheetTypeWithContentArray:@[[CommenUtil LocalizedString:@"Permission.Photos"]] confirmEvent:^(int index) {
        [self cameraActionWithIndex:index];
    } cancelEvent:nil];
}

- (void)photoActionWithIndex:(int)buttonIndex
{
    //跳转到相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = canEdit;
    imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
    if ([[PermissionObj sharedInstance] isCanUsePhotos] == NO) {
        [imagePickerController showPermission:[CommenUtil LocalizedString:@"Permission.PhotoAlbum"]];
    }
}

- (void)cameraActionWithIndex:(int)buttonIndex
{
    //跳转到相机页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = canEdit;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    } else {
        [self actionViewTypeWithTitle:[CommenUtil LocalizedString:@"Permission.WarmPrompt"] withMessage:[CommenUtil LocalizedString:@"Permission.DeviceNotSupportCamera"] withContent:[CommenUtil LocalizedString:@"Face.GoSetup"] confirmEvent:^(int index) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } cancelEvent:nil];
    }
    
    if ([[PermissionObj sharedInstance] isCanVideos] == NO) {
        [imagePickerController showPermission:[CommenUtil LocalizedString:@"Permission.Camera"]];
    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image;
    //是否要裁剪
    if ([picker allowsEditing]){
        //编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
    } else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (self.photoBlock) {
        self.photoBlock(image);
    }
}

//弹出权限视图
- (void)showPermission:(NSString *)noPermissionName
{
    NSString *title = [NSString stringWithFormat:@"%@%@",noPermissionName,[CommenUtil LocalizedString:@"Permission.NotOpen"]];
    NSString *msg = [NSString stringWithFormat:@"%@%@%@\n(%@%@)%@",
                     [CommenUtil LocalizedString:@"Permission.OpenSystemSettings"],
                     noPermissionName,
                     [CommenUtil LocalizedString:@"Permission.Service"],
                     [CommenUtil LocalizedString:@"Permission.SetupAndPrivacy"],
                     noPermissionName,
                     [CommenUtil LocalizedString:@"Common.Open"]];
    
    [self actionViewTypeWithTitle:title withMessage:msg withContent:[CommenUtil LocalizedString:@"Face.GoSetup"] confirmEvent:^(int index) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } cancelEvent:nil];
}


#pragma mark - AleartVc

- (void)actionSheetTypeWithContentArray:(NSArray *)array confirmEvent:(TureBlock)tureBlock cancelEvent:(LogoutBlock)logoutBlock
{
    //从底部弹出选择框
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < array.count; i++) {
        [ac addAction:[UIAlertAction actionWithTitle:array[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (tureBlock) {
                tureBlock(i);
            }
        }]];
    }
    [ac addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Cancle"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (logoutBlock) {
            logoutBlock();
        }
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)actionViewTypeWithTitle:(NSString *)title withMessage:(NSString *)message withContent:(NSString *)content confirmEvent:(TureBlock)tureBlock cancelEvent:(LogoutBlock)logoutBlock
{
    //从底部弹出选择框
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:content style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (tureBlock) {
            tureBlock(0);
        }
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:[CommenUtil LocalizedString:@"Common.Cancle"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (logoutBlock) {
            logoutBlock();
        }
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
