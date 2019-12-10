//
//  Contacts.h
//  Manager
//
//  Created by Apple on 15/8/18.
//  Copyright (c) 2015年 LXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CNContact;

@interface VETContacts : NSObject

@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *username;
@property (nonatomic, retain) NSArray *telsArr;
@property (nonatomic, copy)   NSString *avatar;
@property (nonatomic, copy)   NSString *nickName;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, assign) BOOL isRegistered;

@property (nonatomic, copy)   NSString *searchText;//供搜索的text.中文
@property (nonatomic, copy)   NSString *sortText;//排序.

@property (nonatomic, retain)   CNContact *cnContact;

@end
