//
//  DBUtil.h
//  ephone
//
//  Created by Jian Liao on 16/4/21.
//  Copyright © 2016年 zeoh. All rights reserved.
//

//
//  DBUtil.h
//  ephone
//
//  Created by administrator on 15/11/16.
//  Copyright © 2015年 com.cditv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "VETCallRecord.h"

#define DB_FILE_NAME @"ephone.sqlite3"

@class VETAccount;
@class VETAppleContact;

@interface DBUtil : NSObject {
    sqlite3 *db;
}

+ (DBUtil *) sharedManager; //获取单例对象

/// 插入收藏的联系人
- (BOOL)insertFavoriteContact:(VETAppleContact *)contact;
/// 删除已收藏的联系人
- (BOOL)deleteFavoriteContact:(NSString *)fullName;
/// 查询已收藏的联系人
- (NSArray *)queryFavoritedContact;

#pragma mark 数据库存储路径获取
- (NSString *)applicationDocumentsDirectoryFile;
#pragma mark 创建数据库文件
- (void) createEditableCopyOfDbIfNeeded;
#pragma mark 创建通话记录联系人表
- (BOOL) createRecentContactsTable;
#pragma mark 查询所有通话记录的方法
- (NSArray *) findAllRecentContactsRecordByLoginMobNum:(NSString *) myAccount;
#pragma mark 查询所有未接通话方法
- (NSArray *) findAllMissedContactsRecordByLoginMobNum:(NSString *) myAccount;
#pragma mark 删除所有通话记录的方法
- (BOOL) deleteAllRecentContactsRecordByLoginMobNum:(NSString *) myAccount;
#pragma mark 删除所有未接通话方法
- (BOOL) deleteAllMissedContactsRecordByLoginMobNum:(NSString *) myAccount;
#pragma mark 模糊查找通话记录
- (NSArray *) findRecentContactsRecordsByLoginSearchBarContent:(NSString *) searchText withAccount:(NSString*) myAccount;
#pragma mark 插入通话记录的方法
- (BOOL) insertRecentContactsRecord:(VETCallRecord *) crm;
#pragma mark 删除指定id通话记录的方法
- (BOOL) deleteRecentContactRecordById:(int) dbId;
#pragma mark 删除指定id未接通话记录的方法
- (BOOL) deleteMissedContactRecordById:(int) dbId;
#pragma mark 根据登陆账号清空该用户通话记录表的方法
//- (BOOL) deleteAllRecentContactRecordWithLoginMobNum:(NSString *) myAccount;

#pragma mark 创建联系人表
- (BOOL) createContactsTable;
#pragma mark 查询联系人通话记录的方法
- (NSMutableArray *) findAllContactsByLoginMobNum:(NSString *) myAccount;
#pragma mark 模糊联系人
- (NSMutableArray *) findContactsByLoginSearchBarContent:(NSString *) searchText withAccount:(NSString*) myAccount;
#pragma mark 插入联系人的方法
- (BOOL) insertContact:(VETCallRecord *) cm;
#pragma mark 修改联系人的方法
- (BOOL) editContactByID:(VETCallRecord *) cm withId:(int)dbId;
#pragma mark 删除指定id联系人的方法
- (BOOL) deleteContactById:(int) dbId;
#pragma mark 根据登陆账号清空该用户联系人的方法
- (BOOL) deleteAllContactsWithLoginMobNum:(NSString *) myAccount;
#pragma mark 根据号码查询联系人信息
- (VETCallRecord *) queryContactByAccount:(NSString*) account withAccount:(NSString*) myAccount;

/*
 *  保存帐号
 */
- (BOOL)addAccount:(VETAccount *)account;
- (NSArray *)queryAccount;
- (BOOL)deleteAccount:(NSString *)username;
- (BOOL)updateAccount:(VETAccount *)account;

@end
