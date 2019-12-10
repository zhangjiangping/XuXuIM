//
//  VETAddContactRecordHelper.m
//  MobileVoip
//
//  Created by Liu Yang on 17/06/2017.
//  Copyright © 2017 vetron. All rights reserved.
//

#import "VETAddContactRecordHelper.h"
#import "VETCallRecord.h"
#import "DBUtil.h"
#import "VETContactHelper.h"
#import "VETAppleContact.h"

@implementation VETAddContactRecordHelper

+ (void)insertRecentContactsRecord:(VETCallRecord *)record
{
    __block NSString *fullName;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        [VETContactHelper getContactsBigiOS9WithCompletion:^(NSArray *arr) {
            fullName = [VETAddContactRecordHelper queryContactWithPhoneNubmer:record.account contactArr:arr];
        } error:^(VETContactsErrorType errorType, NSError *error) {
            
        }];
    }
    else {
        [VETContactHelper getContactsSmalliOS9WithCompletion:^(NSArray *arr) {
            fullName = [VETAddContactRecordHelper queryContactWithPhoneNubmer:record.account contactArr:arr];
        } error:^(VETContactsErrorType errorType, NSError *error) {
            
        }];
    }
    record.callPhoneFullName = fullName;
    [[DBUtil sharedManager] insertRecentContactsRecord:record];
}

+ (NSString *)queryContactWithPhoneNubmer:(NSString *)phoneNumber contactArr:(NSArray *)contactArr
{
    __block NSString *fullName = @"";
    
    // 去除空格，去除+
    NSString *deletePlusPhoneString = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *deleteMinusPhoneString = [deletePlusPhoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    __block NSString *recentPhoneString = [deleteMinusPhoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [contactArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VETAppleContact *contact = (VETAppleContact *)obj;
        
        NSArray *mobileArr = contact.mobileArray;
        
        for (VETMobileModel *mobileModel in mobileArr) {
            NSString *phoneNumber = mobileModel.mobileContent;
            NSString *deletePlusPhoneString = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
            NSString *deleteMinusPhoneString = [deletePlusPhoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *newPhoneString = [deleteMinusPhoneString stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([newPhoneString isEqualToString:recentPhoneString]) {
                fullName = [NSString stringWithFormat:@"%@%@", contact.lastName, contact.firstName];
            }
        }

    }];
    return fullName;
}

@end
