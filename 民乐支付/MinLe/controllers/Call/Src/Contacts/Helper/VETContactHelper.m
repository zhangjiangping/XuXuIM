//
//  VETContactHelper.m
//  VETEphone
//
//  Created by Liu Yang on 30/03/2017.
//  Copyright © 2017 Vetron. All rights reserved.
//

#import "VETContactHelper.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import "VETAppleContact.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "VETAppleContact.h"

//@interface VETContactsModel : NSObject
//
//@property (nonatomic, copy) NSString *username;
//@property (nonatomic, copy) NSString *phoneNumber;
//
//@end
//
//@implementation VETContactsModel
//
//@end

@interface VETContactHelper () <CNContactPickerDelegate>

@property (nonatomic, retain) CNContactPickerViewController *contactPicker;

@end

@implementation VETContactHelper

+ (void)accessAddressBookAuthWithCompletion:(void (^)(BOOL granted))completion
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        CNContactStore *contactStore = [CNContactStore new];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    LYLog(@"AddressBook Auth Error:%@", error);
                    completion(NO);
                }
                else if (!granted) {
                    completion(NO);
                }
                else {
                    completion(YES);
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            completion(YES);
        }
        //  被拒绝
        else {
            completion(NO);
        }
    }
    else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        //  不确定状态
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (error) {
                    LYLog(@"AddressBook Auth Error:%@", (__bridge NSError *)error);
                    completion(NO);
                }
                else if (!granted) {
                    completion(NO);
                }
                else {
                    completion(YES);
                }
            });
        }
        else if (authStatus == kABAuthorizationStatusAuthorized) {
            completion(YES);
        }
        //  被拒绝
        else {
            completion(NO);
        }
    }
}

+ (id)callAddressBook:(id)target {
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
//        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [target presentViewController:contactPicker animated:YES completion:nil];
        return contactPicker;
    }else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
//        peoplePicker.peoplePickerDelegate = self;
        [target presentViewController:peoplePicker animated:YES completion:nil];
        return peoplePicker;
    }
}

+ (void)saveContact:(VETAppleContact *)contacts
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        //1.创建Contact对象
        CNMutableContact *newContact = [[CNMutableContact alloc] init];
        newContact.givenName = contacts.firstName;
        newContact.familyName = contacts.lastName;
        
//        newContact.phoneNumbers
        NSMutableArray *phoneNumbers = [NSMutableArray array];
        for (VETMobileModel *mobileModel in contacts.mobileArray) {
            if (!mobileModel.mobileType|| !mobileModel.mobileType.length) continue;
            if (!mobileModel.mobileContent|| !mobileModel.mobileContent.length) continue;
            CNLabeledValue *phoneNumber = [[CNLabeledValue alloc] initWithLabel:mobileModel.mobileType value:[CNPhoneNumber phoneNumberWithStringValue:mobileModel.mobileContent]];
            [phoneNumbers addObject:phoneNumber];
        }
        newContact.phoneNumbers = phoneNumbers;
        CNContactStore *contactStore = [CNContactStore new];
        CNSaveRequest *request = [[CNSaveRequest alloc] init];
        [request addContact:newContact toContainerWithIdentifier:nil];
        [contactStore executeSaveRequest:request error:nil];
    }
    else {
        ABRecordRef newPersion = ABPersonCreate();
        CFErrorRef *error = NULL;
        
        //  name
        ABRecordSetValue(newPersion, kABPersonFirstNameProperty, (__bridge CFTypeRef)(contacts.firstName), error);
        ABRecordSetValue(newPersion, kABPersonLastNameProperty, (__bridge CFTypeRef)(contacts.lastName), error);
        
        //  phone number
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (VETMobileModel *mobileModel in contacts.mobileArray) {
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(mobileModel.mobileContent), (__bridge CFStringRef)(mobileModel.mobileType), NULL);
        }
//        ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
//        ABRecordRef newPerson = ABPersonCreate();
//        ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//        CFErrorRef error = NULL;
//        
//        ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(linkMobile), kABPersonPhoneMobileLabel, NULL);
//        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue , &error);
//        picker.displayedPerson = newPerson;
//        picker.newPersonViewDelegate = self;
//        picker.navigationItem.title = @"新建联系人";
//        [self modalShowController:picker];
//        CFRelease(newPerson);
//        CFRelease(multiValue);
    }
}

+ (void)getContactsSmalliOS9WithCompletion:(void(^)(NSArray *arr))completion error:(void(^)(VETContactsErrorType errorType, NSError *error))error
{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied)
    {
        error(VETContactsErrorTypeNotGranted, nil);
    }
    
    NSMutableArray *contactArr = [NSMutableArray array];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else{
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //循环，获取每个人的个人信息
        for (NSInteger i = 0; i < nPeople; i++)
        {
            //新建一个model类
            //        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
            VETAppleContact *contact = [[VETAppleContact alloc] init];
            //获取个人
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            //获取个人名字
            CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            //        AB_EXTERN const ABPropertyID kABPersonFirstNamePhoneticProperty;  // First name Phonetic - kABStringPropertyType
            //        AB_EXTERN const ABPropertyID kABPersonLastNamePhoneticProperty;   // Last name Phonetic - kABStringPropertyType
            //        AB_EXTERN const ABPropertyID kABPersonMiddleNamePhoneticProperty; // Middle name Phonetic - kABStringPropertyType
            
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            NSString *nameString = (__bridge NSString *)abName;
            NSString *lastNameString = (__bridge NSString *)abLastName;
            
            if ((__bridge id)abFullName != nil) {
                nameString = (__bridge NSString *)abFullName;
            } else {
                if ((__bridge id)abLastName != nil)
                {
                    nameString = [NSString stringWithFormat:@"%@%@", nameString, lastNameString];
                }
            }
            if ([[CommenUtil sharedInstance] isNull:nameString]) {
                contact.firstName = @"";
                contact.lastName = lastNameString;
            } else if ([[CommenUtil sharedInstance] isNull:lastNameString]) {
                contact.firstName = nameString;
                contact.lastName = @"";
            } else {
                contact.firstName = nameString;
                contact.lastName = lastNameString;
            }
            
//            contact.recordId = (NSInteger)ABRecordGetRecordID(person);
            //读取电话多值
            NSMutableArray *mobileModelArr = [NSMutableArray array];
            ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for (int k = 0; k < ABMultiValueGetCount(phone); k++)
            {
                //获取电话Label
                NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
                // 去除_$!<
                NSString *mobileTypeString;
                if ([personPhoneLabel containsString:@"_$!<"]) {
                    //                        NSRange range = [labeledValue.label rangeOfString:@"_$!<"];
                    NSString *str = [personPhoneLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
                    NSString *str2 = [str stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
                    mobileTypeString = str2;
                }
                else {
                    mobileTypeString = personPhoneLabel;
                }
                
                //获取該Label下的电话值
                NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                mobileTypeString = [self getNewTextByReplacing:mobileTypeString];
                personPhone = [self getNewTextByReplacing:personPhone];
                VETMobileModel *mobileModel = [[VETMobileModel alloc] initWithMobileType:mobileTypeString mobileNumber:personPhone];
                [mobileModelArr addObject:mobileModel];
            }
            contact.mobileArray = [mobileModelArr copy];
            
            //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
            NSMutableString *telMutableStr = [NSMutableString string];
            for (VETMobileModel *mobileModel in mobileModelArr) {
                [telMutableStr appendFormat:@"%@,", mobileModel.mobileContent];
                contact.searchText = [NSString stringWithFormat:@"%@%@", nameString, telMutableStr];
            }
            [contactArr addObject:contact];
            if (abName) CFRelease(abName);
            if (abLastName) CFRelease(abLastName);
            if (abFullName) CFRelease(abFullName);
        }
        completion([contactArr copy]);
    });
}

+ (void)getContactsBigiOS9WithCompletion:(void(^)(NSArray *arr))completion error:(void(^)(VETContactsErrorType errorType, NSError *error))errorCompletion
{
    CNContactPickerViewController *contactPickerViewController = [CNContactPickerViewController new];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                errorCompletion(VETContactsErrorTypeOtherError, error);
                return ;
            }
            if (granted) {
                contactPickerViewController.displayedPropertyKeys = @[CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey];
//                completion(contactPickerViewController);
                [self readContact:contactStore completion:completion error:errorCompletion];
            }
            else {
                LYLog(@"没有授权!");
                errorCompletion(VETContactsErrorTypeNotGranted, nil);
            }
        }];
    }
    else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        [self readContact:contactStore completion:completion error:errorCompletion];
        contactPickerViewController.displayedPropertyKeys = @[CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey];
    }
    else {
        LYLog(@"拒绝访问通讯录!");
        errorCompletion(VETContactsErrorTypeNotGranted, nil);
    }
//    completion(contactPickerViewController);
}

+ (void)readContact:(CNContactStore *)contactStore completion:(void(^)(NSArray *arr))completion error:(void(^)(VETContactsErrorType errorType, NSError *error))errorCompletion
{
    NSError *error = nil;
    NSMutableArray *contactArr = [NSMutableArray array];
    NSArray <id<CNKeyDescriptor>> *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    // TODO:Crash
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        if (!error) {
            VETAppleContact *aContact = [VETAppleContact new];
            
            NSString *givenName = [self getNewTextByReplacing:contact.givenName];
            NSString *familyName = [self getNewTextByReplacing:contact.familyName];
            
            if ([[CommenUtil sharedInstance] isNull:givenName]) {
                aContact.firstName = @"";
                aContact.lastName = familyName;
            } else if ([[CommenUtil sharedInstance] isNull:familyName]) {
                aContact.firstName = givenName;
                aContact.lastName = @"";
            } else {
                aContact.firstName = givenName;
                aContact.lastName = familyName;
            }
            
            if (contact.phoneNumbers && contact.phoneNumbers.count > 0) {
                NSMutableString *telMutableStr = [NSMutableString string];
                NSMutableArray *telsArr = [NSMutableArray array];
                for (NSUInteger i = 0; i < contact.phoneNumbers.count ; i++) {
                    CNLabeledValue *labeledValue = contact.phoneNumbers[i];
                    CNPhoneNumber *phoneNumber = contact.phoneNumbers[i].value;
                    
                    // 去除_$!<
                    NSString *mobileTypeString;
                    if ([labeledValue.label containsString:@"_$!<"]) {
//                        NSRange range = [labeledValue.label rangeOfString:@"_$!<"];
                        NSString *str = [labeledValue.label stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
                        NSString *str2 = [str stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
                        mobileTypeString = str2;
                    } else {
                        mobileTypeString = labeledValue.label;
                    }
                    mobileTypeString = [self getNewTextByReplacing:mobileTypeString];
                    NSString *phoneStr = [self getNewTextByReplacing:phoneNumber.stringValue];
                    VETMobileModel *mobileModel = [[VETMobileModel alloc] initWithMobileType:mobileTypeString mobileNumber:phoneStr];
                    [telMutableStr appendFormat:@"%@,", phoneStr];
                    [telsArr addObject:mobileModel];
                }
                aContact.mobileArray = [telsArr copy];
                aContact.searchText = [NSString stringWithFormat:@"%@%@,%@",aContact.lastName, aContact.firstName, telMutableStr];
            }
            [contactArr addObject:aContact];
        }
        else {
            LYLog(@"error:%@",error.localizedDescription);
            if (errorCompletion) {
                errorCompletion(VETContactsErrorTypeOtherError, error);
            }
        }
    }];
    if (completion) {
        completion([contactArr copy]);
    }
}

+ (NSString *)getNewTextByReplacing:(NSString *)text
{
    NSString *newText = text;
    newText = [newText stringByReplacingOccurrencesOfString:@"+" withString:@""];
    newText = [newText stringByReplacingOccurrencesOfString:@"-" withString:@""];
    newText = [newText stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newText;
}

@end
