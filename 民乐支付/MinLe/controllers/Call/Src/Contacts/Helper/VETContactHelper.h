//
//  VETContactHelper.h
//  VETEphone
//
//  Created by Liu Yang on 30/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VETAppleContact;
@class CNContactPickerViewController;

typedef NS_ENUM(NSUInteger, VETContactsErrorType) {
    VETContactsErrorTypeNotGranted = 1, // 未授权
    VETContactsErrorTypeOtherError = 2, // 其它错误
};

@interface VETContactHelper : NSObject

/*
 *  判断通讯录版本
 */
+ (void)accessAddressBookAuthWithCompletion:(void (^)(BOOL granted))completion;
+ (id)callAddressBook:(id)target ;
+ (void)saveContact:(VETAppleContact *)contacts;

+ (void)getContactsSmalliOS9WithCompletion:(void(^)(NSArray *arr))completion error:(void(^)(VETContactsErrorType errorType, NSError *error))error;
+ (void)getContactsBigiOS9WithCompletion:(void(^)(NSArray *arr))completion error:(void(^)(VETContactsErrorType errorType, NSError *error))errorCompletion;

@end
