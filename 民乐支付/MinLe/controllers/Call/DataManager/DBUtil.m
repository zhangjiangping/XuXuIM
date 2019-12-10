//
//  DBUtil.m
//  ephone
//
//  Created by Jian Liao on 16/4/21.
//  Copyright © 2016年 zeoh. All rights reserved.
//

#import "DBUtil.h"
#import "VETAccount.h"
#import "VETAppleContact.h"

@implementation DBUtil

static DBUtil * util=nil;

+ (DBUtil *) sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        util=[[self alloc]init];
        [util createEditableCopyOfDbIfNeeded];
    });
    return util;
}

#pragma mark 数据库存储路径获取
- (NSString *)applicationDocumentsDirectoryFile {
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath=[docPath stringByAppendingPathComponent:DB_FILE_NAME];
//    LYLog(@"dbPath:%@", dbPath);
    return dbPath;
}

#pragma mark创建数据库文件
- (void) createEditableCopyOfDbIfNeeded {
    if([self openDB] != SQLITE_OK) {
        LYLog(@"Open DB failed.");
    } else {
        [self createRecentContactsTable];
        [self createContactsTable];
        [self createAccountTable];
        [self createFavoriteContactTable];
        [self createFavoriteContactMobileTable];
    }
    sqlite3_close(db);
}

- (BOOL)createFavoriteContactTable
{
    NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_favorite_contact(fullname varchar(32) primary key, firstname varchar(32), lastName varchar(32), searchText varchar(32))"];
    BOOL isSuccess = [self execSql:sqlString];
    return isSuccess;
    /**
     联系人收藏结构表 t_account
     id  int
     fullName varchar(32)
     firstName varchar(32)
     lastName varchar(32)
     searchText varchar(32)
     **/
}

- (BOOL)createFavoriteContactMobileTable
{
    NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_favorite_contact_mobile(fullname varchar(32), mobiletype varchar(32), mobilecontent varchar(32), primary key(fullname, mobilecontent))"];
    BOOL isSuccess = [self execSql:sqlString];
    return isSuccess;
}

- (BOOL)createAccountTable
{
    NSString *SQL = [NSString stringWithFormat:
                   @"CREATE TABLE IF NOT EXISTS t_account(username varchar(32) primary key, password varchar(32), domain varchar(32), displayname varchar(20), autologin int, encryption int, transport int)"];
    BOOL isCreationSuccess = [self execSql:SQL];
    return isCreationSuccess;
    /**
     通话记录数据库表格结构 t_account
     id  int 主键
     username varchar(32) username
     password varchar(32) password
     domain varchar(32) remote server address
     displayname varchar(32) display name
     autologin status(1 is autologin, other is not.)
     encryptionstatus int vos encryption status(1 is encrypted, other is not.)
     **/
}

#pragma mark 创建通话记录联系人表
- (BOOL) createRecentContactsTable{
    NSString *SQL=[NSString stringWithFormat:
                    @"CREATE TABLE IF NOT EXISTS t_phone_record(id integer primary key autoincrement, name varchar(32), account varchar(32), domain varchar(32), attribution varchar(20), callTime varcher(20), duration char(8), callType int, networkType int, myAccount varchar(32), fullname varchar(32))"];
    BOOL isCreationSuccess = [self execSql:SQL];
    return isCreationSuccess;
    /**
     通话记录数据库表格结构 t_phone_record
     id  int 主键
     name varchar(32) 联系人姓名
     account varchar(32) 通话号码
     domain varchar(32) remote server address
     attribution varchar(20) 号码归属地
     callTime varcher(20) 通话开始时间点   例如 ：2015-03-25 14:00:02
     duration char(8) 通话时长 e.g. 00:02:32
     callType int 接通方式    0:outcoming 1：incoming  2：failed  3：missed
     networkType int 网络类型 0:SIP 1:PSTN
     myAccount varchar(32) 我的当前登录号码
     contactId int foreign key
     fullname varchar(32) 全称
     **/
}

#pragma mark 查询所有通话记录的方法
- (NSArray *) findAllRecentContactsRecordByLoginMobNum:(NSString *) myAccount{
    NSMutableArray *resultList=[[NSMutableArray alloc]init];
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
    }else{
        NSString *SQL=@"select * from t_phone_record where myAccount=? order by id DESC";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [myAccount UTF8String], -1, NULL);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //                NSMutableDictionary *objDict=[[NSMutableDictionary alloc]init];//封装结果成字典对象
                VETCallRecord *recordModel=[[VETCallRecord alloc]init];
                recordModel.dbId=sqlite3_column_int(statement, 0);
                
                //                int  pid=sqlite3_column_int(statement, 0);
                //                [objDict setObject:[NSNumber numberWithInt:pid] forKey:@"id"];
                
                char *name=(char *)sqlite3_column_text(statement, 1);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:name] forKey:@"name"];
                if(name) recordModel.name=[[NSString alloc ] initWithUTF8String:name];
                
                char *account=(char *)sqlite3_column_text(statement, 2);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:phoneNum] forKey:@"phoneNum"];
                if(account) recordModel.account=[[NSString alloc ] initWithUTF8String:account];
                
                char *domain=(char *)sqlite3_column_text(statement, 3);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                if(domain) recordModel.domain=[[NSString alloc ] initWithUTF8String:domain];
                
                char *attribution=(char *)sqlite3_column_text(statement, 4);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                if(attribution) recordModel.attribution=[[NSString alloc ] initWithUTF8String:attribution];
                
                char  *callTime=(char *)sqlite3_column_text(statement, 5);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:call_time] forKey:@"call_time"];
                if(callTime) recordModel.callTime=[[NSString alloc ]initWithUTF8String:callTime];
                
                char  *duration=(char *)sqlite3_column_text(statement, 6);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:call_time] forKey:@"call_time"];
                if(duration) recordModel.duration=[[NSString alloc ]initWithUTF8String:duration];
                
                //                int  type=sqlite3_column_int(statement, 5);
                //                [objDict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
                
                VETCallType callType = atoi((char*)sqlite3_column_text(statement, 7));
                recordModel.callType = callType;
                
                VETNetworkType networkType=atoi((char*)sqlite3_column_text(statement, 8));
                recordModel.networkType = networkType;
                
                char  *myAccount=(char *)sqlite3_column_text(statement, 9);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:myAccount] forKey:@"myAccount"];
                if(myAccount) recordModel.myAccount = [[NSString alloc ]initWithUTF8String:myAccount];
                
                char *fullname = (char *)sqlite3_column_text(statement, 10);
                if (fullname) {
                    recordModel.callPhoneFullName = [[NSString alloc] initWithUTF8String:fullname];
                }
                
                [resultList addObject:recordModel];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return [resultList copy];
}

- (NSArray *) findAllMissedContactsRecordByLoginMobNum:(NSString *) myAccount {
    NSMutableArray *resultList=[[NSMutableArray alloc]init];
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
    }else{
        NSString *SQL = @"select * from t_phone_record where myAccount=? and callType=3 order by id DESC";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [myAccount UTF8String], -1, NULL);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //                NSMutableDictionary *objDict=[[NSMutableDictionary alloc]init];//封装结果成字典对象
                VETCallRecord *recordModel=[[VETCallRecord alloc]init];
                recordModel.dbId=sqlite3_column_int(statement, 0);
                //                int  pid=sqlite3_column_int(statement, 0);
                //                [objDict setObject:[NSNumber numberWithInt:pid] forKey:@"id"];
                
                char *name=(char *)sqlite3_column_text(statement, 1);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:name] forKey:@"name"];
                if(name) recordModel.name=[[NSString alloc ] initWithUTF8String:name];
                
                char *account=(char *)sqlite3_column_text(statement, 2);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:phoneNum] forKey:@"phoneNum"];
                if(account) recordModel.account=[[NSString alloc ] initWithUTF8String:account];
                
                char *domain=(char *)sqlite3_column_text(statement, 3);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                if(domain) recordModel.domain=[[NSString alloc ] initWithUTF8String:domain];
                
                char *attribution=(char *)sqlite3_column_text(statement, 4);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                if(attribution) recordModel.attribution=[[NSString alloc ] initWithUTF8String:attribution];
                
                char  *callTime=(char *)sqlite3_column_text(statement, 5);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:call_time] forKey:@"call_time"];
                if(callTime) recordModel.callTime=[[NSString alloc ]initWithUTF8String:callTime];
                
                char  *duration=(char *)sqlite3_column_text(statement, 6);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:call_time] forKey:@"call_time"];
                if(duration) recordModel.duration=[[NSString alloc ]initWithUTF8String:duration];
                
                //                int  type=sqlite3_column_int(statement, 5);
                //                [objDict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
                
                VETCallType callType = atoi((char*)sqlite3_column_text(statement, 7));
                recordModel.callType = callType;
                
                VETNetworkType networkType=atoi((char*)sqlite3_column_text(statement, 8));
                recordModel.networkType = networkType;
                
                char  *myAccount=(char *)sqlite3_column_text(statement, 9);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:myAccount] forKey:@"myAccount"];
                if(myAccount) recordModel.myAccount=[[NSString alloc ]initWithUTF8String:myAccount];
                
                char *fullname = (char *)sqlite3_column_text(statement, 10);
                if (fullname) {
                    recordModel.callPhoneFullName = [[NSString alloc] initWithUTF8String:fullname];
                }
                
                [resultList addObject:recordModel];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return [resultList copy];
}

- (BOOL) deleteAllRecentContactsRecordByLoginMobNum:(NSString *) myAccount {
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
    }else{
        NSString *SQL = @"delete from t_phone_record where myAccount=?";
//        NSString *SQL = @"delete from t_phone_record where myAccount=? and callType!=3";
        sqlite3_stmt *statement;
        int code2=sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code2==SQLITE_OK) {
            sqlite3_bind_text(statement,1, [myAccount UTF8String],-1,NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                LYLog(@"通话记录清空失败", nil);
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        return NO;
    }
    return YES;
}

#pragma mark 删除所有未接通话方法
- (BOOL) deleteAllMissedContactsRecordByLoginMobNum:(NSString *) myAccount {
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
    }else{
        NSString *SQL = @"delete from t_phone_record where myAccount=? and callType=3";
        sqlite3_stmt *statement;
        int code2= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code2==SQLITE_OK) {
            sqlite3_bind_text(statement,1, [myAccount UTF8String],-1,NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                LYLog(@"通话记录清空失败", nil);
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        return NO;
    }
    return YES;
}

#pragma mark 模糊查找通话记录
- (NSArray *) findRecentContactsRecordsByLoginSearchBarContent:(NSString *) searchText withAccount:(NSString*) myAccount {
    NSMutableArray *resultList=[[NSMutableArray alloc]init];
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
    }else{ //and (name like '%?%' or account like =?)
        NSString *SQL=[NSString stringWithFormat:@"select * from t_phone_record where myAccount=? and (name like '%%%@%%' or account like '%%%@%%') order by id DESC", searchText, searchText];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [myAccount UTF8String], -1, NULL);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //                NSMutableDictionary *objDict=[[NSMutableDictionary alloc]init];//封装结果成字典对象
                VETCallRecord *recordModel=[[VETCallRecord alloc]init];
                recordModel.dbId=sqlite3_column_int(statement, 0);
                
                //                int  pid=sqlite3_column_int(statement, 0);
                //                [objDict setObject:[NSNumber numberWithInt:pid] forKey:@"id"];
                
                char *name=(char *)sqlite3_column_text(statement, 1);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:name] forKey:@"name"];
                if(name) recordModel.name=[[NSString alloc ] initWithUTF8String:name];
                
                char *account=(char *)sqlite3_column_text(statement, 2);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:phoneNum] forKey:@"phoneNum"];
                if(account) recordModel.account=[[NSString alloc ] initWithUTF8String:account];
                
                char *domain=(char *)sqlite3_column_text(statement, 3);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                if(domain) recordModel.domain=[[NSString alloc ] initWithUTF8String:domain];
                
                char *attribution=(char *)sqlite3_column_text(statement, 4);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:location] forKey:@"location"];
                if(attribution) recordModel.attribution=[[NSString alloc ] initWithUTF8String:attribution];
                
                char  *callTime=(char *)sqlite3_column_text(statement, 5);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:call_time] forKey:@"call_time"];
                if(callTime) recordModel.callTime=[[NSString alloc ]initWithUTF8String:callTime];
                
                char  *duration=(char *)sqlite3_column_text(statement, 6);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8S ring:call_time] forKey:@"call_time"];
                if(duration) recordModel.duration=[[NSString alloc ]initWithUTF8String:duration];
                
                //                int  type=sqlite3_column_int(statement, 5);
                //                [objDict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
                
                VETCallType callType = atoi((char*)sqlite3_column_text(statement, 7));
                recordModel.callType = callType;
                
                VETNetworkType networkType=atoi((char*)sqlite3_column_text(statement, 8));
                recordModel.networkType = networkType;
                
                char  *myAccount=(char *)sqlite3_column_text(statement, 9);
                //                [objDict setObject:[[NSString alloc ]initWithUTF8String:myAccount] forKey:@"myAccount"];
                if(myAccount) recordModel.myAccount=[[NSString alloc ]initWithUTF8String:myAccount];
                
                char *fullname = (char *)sqlite3_column_text(statement, 10);
                if (fullname) {
                    recordModel.callPhoneFullName = [[NSString alloc] initWithUTF8String:fullname];
                }
                
                [resultList addObject:recordModel];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return [resultList copy];
}

#pragma mark 插入通话记录的方法
- (BOOL) insertRecentContactsRecord:(VETCallRecord *) recordModel{
    //                code=[self openDB];
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"insert into t_phone_record(id, name, account, domain, attribution, callTime, duration, callType, networkType, myAccount, fullname) values(NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [recordModel.name UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [recordModel.account UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [recordModel.domain UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [recordModel.attribution UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 5, [recordModel.callTime UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 6, [recordModel.duration UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 7, recordModel.callType);
            sqlite3_bind_int(statement, 8, recordModel.networkType);
            sqlite3_bind_text(statement, 9, [recordModel.myAccount UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 10, [recordModel.callPhoneFullName UTF8String], -1, NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"通话记录插入失败");
                return NO;
            }
            //删除超过60条的记录
//            [self deleteMoreThan60RecentContactRecordWithLoginMobNum:recordModel.myAccount];
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
    }
    return YES;
}

#pragma mark 删除指定id通话记录的方法
- (BOOL) deleteRecentContactRecordById:(int) dbId{
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_phone_record where id=?";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_int(statement, 1, dbId);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"通话记录删除失败id=%d",dbId);
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordDeletionSuccess" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
        return NO;
    }
    return YES;
}

- (BOOL) deleteMissedContactRecordById:(int) dbId {
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL = @"delete from t_phone_record where id=?";
        sqlite3_stmt *statement;
        int code1 = sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1 == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, dbId);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"通话记录删除失败id=%d",dbId);
                return NO;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordDeletionSuccess" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
        return NO;
    }
    return YES;
}
//
//#pragma mark 根据登陆手机号清空该用户通话记录表的方法
//- (BOOL) deleteAllRecentContactRecordWithLoginMobNum:(NSString *) myAccount{
//    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
//        sqlite3_close(db);
//        LYLog(@"数据库打开失败",nil);
//        return NO;
//    }else{
//        NSString *SQL=@"delete from t_phone_record where myAccount=?";
//        sqlite3_stmt *statement;
//        int code2= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
//        if (code2==SQLITE_OK) {
//            sqlite3_bind_text(statement,1, [myAccount UTF8String],-1,NULL);
//            if (sqlite3_step(statement)!=SQLITE_DONE) {
//                LYLog(@"通话记录清空失败", nil);
//                return NO;
//            }
//            
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(db);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
//    }
//    return YES;
//}
//
#pragma mark Private Methods

#pragma mark 打开ephone数据库的方法
-(int) openDB{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *dbPath = [documents stringByAppendingPathComponent:@"ephone.sqlite3"];
//    return sqlite3_open([dbPath UTF8String], &db);
    NSString *DBPath=[self applicationDocumentsDirectoryFile];
    return sqlite3_open([DBPath UTF8String], &db);
}

-(BOOL) execSql:(NSString *)sql{
    char *err;
    int rc=sqlite3_exec(db, [sql UTF8String], nil, nil, &err);
    if(rc!=SQLITE_OK) {
        LYLog(@"%@:SQL=%@",@"数据库操作失败",sql);
        return NO;
    } else
        return YES;
}

#pragma mark 删除超过60条的早期通话记录
- (BOOL) deleteMoreThan60RecentContactRecordWithLoginMobNum:(NSString *) mobNum{
    //                code=[self openDB];
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_phone_record where (select count(id) from t_phone_record)> 60 and id in (select id from t_phone_record order by id desc limit (select count(id) from t_phone_record) offset 60 ) and myAccount=?";
        sqlite3_stmt *statement;
        int code2= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code2==SQLITE_OK) {
            sqlite3_bind_text(statement,1, [mobNum UTF8String],-1,NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                LYLog(@"超量60通话记录清空失败", nil);
                return NO;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

#pragma mark 创建联系人表
- (BOOL) createContactsTable {
    NSString *SQL=[NSString stringWithFormat:
                   @"CREATE TABLE IF NOT EXISTS t_contact(id integer primary key autoincrement, name varchar(32) UNIQUE NOT NULL, account varchar(32) UNIQUE NOT NULL, domain varchar(32), attribution varchar(20), networkType int, myAccount varchar(32))"];
    BOOL isCreationSuccess = [self execSql:SQL];
    return isCreationSuccess;
    /**
     通话记录数据库表格结构 t_phone_record
     id  int 主键
     name varchar(32) 联系人姓名 UNIQUE
     account varchar(32) 通话号码
     domain varchar(32) remote server address
     attribution varchar(20) 号码归属地
     networkType int 网络类型 0:SIP 1:PSTN
     myAccount varchar(32) 我的当前登录号码
     **/
}

#pragma mark 查询联系人通话记录的方法
- (NSMutableArray *) findAllContactsByLoginMobNum:(NSString *) myAccount {
    NSMutableArray *resultList=[[NSMutableArray alloc]init];
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
    }else{
        NSString *SQL=@"select * from t_contact where myAccount=? order by id DESC";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [myAccount UTF8String], -1, NULL);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                VETCallRecord *contactModel=[[VETCallRecord alloc]init];
                contactModel.dbId=sqlite3_column_int(statement, 0);
                
                char *name=(char *)sqlite3_column_text(statement, 1);
                if(name) contactModel.name=[[NSString alloc ] initWithUTF8String:name];
                
                char *account=(char *)sqlite3_column_text(statement, 2);
                if(account) contactModel.account=[[NSString alloc ] initWithUTF8String:account];
                
                char *domain=(char *)sqlite3_column_text(statement, 3);
                if(domain) contactModel.domain=[[NSString alloc ] initWithUTF8String:domain];
                
                char *attribution=(char *)sqlite3_column_text(statement, 4);
                if(attribution) contactModel.attribution=[[NSString alloc ] initWithUTF8String:attribution];
                
                VETNetworkType networkType=atoi((char*)sqlite3_column_text(statement, 5));
                contactModel.networkType = networkType;
                
                char  *myAccount=(char *)sqlite3_column_text(statement, 9);
                if(myAccount) contactModel.myAccount=[[NSString alloc ]initWithUTF8String:myAccount];
                
                [resultList addObject:contactModel];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return resultList;
}

#pragma mark 模糊联系人
- (NSMutableArray *) findContactsByLoginSearchBarContent:(NSString *) searchText withAccount:(NSString*) myAccount {
    NSMutableArray *resultList=[[NSMutableArray alloc]init];
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
    }else{ //and (name like '%?%' or account like =?)
        NSString *SQL=[NSString stringWithFormat:@"select * from t_contact where myAccount=? and (name like '%%%@%%' or account like '%%%@%%') order by id DESC", searchText, searchText];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [myAccount UTF8String], -1, NULL);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                VETCallRecord *contactModel=[[VETCallRecord alloc]init];
                contactModel.dbId=sqlite3_column_int(statement, 0);
                
                char *name=(char *)sqlite3_column_text(statement, 1);
                if(name) contactModel.name=[[NSString alloc ] initWithUTF8String:name];
                
                char *account=(char *)sqlite3_column_text(statement, 2);
                if(account) contactModel.account=[[NSString alloc ] initWithUTF8String:account];
                
                char *domain=(char *)sqlite3_column_text(statement, 3);
                if(domain) contactModel.domain=[[NSString alloc ] initWithUTF8String:domain];
                
                char *attribution=(char *)sqlite3_column_text(statement, 4);
                if(attribution) contactModel.attribution=[[NSString alloc ] initWithUTF8String:attribution];
                
                VETNetworkType networkType=atoi((char*)sqlite3_column_text(statement, 5));
                contactModel.networkType = networkType;
                
                char  *myAccount=(char *)sqlite3_column_text(statement, 6);
                if(myAccount) contactModel.myAccount=[[NSString alloc ]initWithUTF8String:myAccount];
                
                [resultList addObject:contactModel];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return resultList;
}

#pragma mark 插入联系人的方法
- (BOOL) insertContact:(VETCallRecord *) contactModel {
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"insert into t_contact(id, name, account, domain, attribution, networkType, myAccount) values(NULL, ?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [contactModel.name UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [contactModel.account UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [contactModel.domain UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [contactModel.attribution UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 5, contactModel.networkType);
            sqlite3_bind_text(statement, 6, [contactModel.myAccount UTF8String], -1, NULL);
            
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"联系人插入失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"contactInsertingFailed" object:self];
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"contactInsertingDone" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
    }
    return YES;
}

#pragma mark 修改联系人的方法
- (BOOL) editContactByID:(VETCallRecord *)cm withId:(int)dbId {
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"update t_contact set name=?, account=?, attribution=? where id=?";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [cm.name UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [cm.account UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [cm.attribution UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 4, dbId);
            
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"联系人修改失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"contactEditFailed" object:self];
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);

        [[NSNotificationCenter defaultCenter] postNotificationName:@"contactEditSuccess" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
    }
    return YES;
}

#pragma mark 删除指定id联系人的方法
- (BOOL) deleteContactById:(int) dbId {
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_contact where id=?";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_int(statement, 1, dbId);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"通话记录删除失败id=%d",dbId);
                return NO;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"contactDeletionSuccess" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
    }
    return YES;
}

#pragma mark 根据登陆账号清空该用户联系人的方法
- (BOOL) deleteAllContactsWithLoginMobNum:(NSString *) myAccount {
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL=@"delete from t_contact where myAccount=?";
        sqlite3_stmt *statement;
        int code2= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code2==SQLITE_OK) {
            sqlite3_bind_text(statement,1, [myAccount UTF8String],-1,NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE) {
                LYLog(@"通话记录清空失败", nil);
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
    }
    return YES;
}

#pragma mark 联系人表有改动时更新通话记录表
- (BOOL) updatePhoneRecords {
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL1=@"UPDATE t_phone_record SET name = (SELECT t_contact.name FROM t_contact WHERE t_contact.myAccount=t_phone_record.myAccount AND t_contact.account=t_phone_record.account), attribution = (SELECT t_contact.attribution FROM t_contact WHERE t_contact.myAccount=t_phone_record.myAccount AND t_contact.account=t_phone_record.account) WHERE EXISTS (SELECT * FROM t_contact WHERE t_contact.myAccount=t_phone_record.myAccount AND t_contact.account=t_phone_record.account)";
        BOOL isCreationSuccess = [self execSql:SQL1];
        NSString *SQL2=@"UPDATE t_phone_record SET name = '' WHERE NOT EXISTS (SELECT * FROM t_contact WHERE t_contact.myAccount=t_phone_record.myAccount AND t_contact.account=t_phone_record.account)";
        isCreationSuccess = (isCreationSuccess && [self execSql:SQL2]);
        if(isCreationSuccess) {
            sqlite3_close(db);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
            return YES;
        } else{
            LYLog(@"更新失败");
            return NO;
        }
    }
}

#pragma mark 根据号码查询联系人信息
- (VETCallRecord *) queryContactByAccount:(NSString*) account withAccount:(NSString*) myAccount{
    VETCallRecord *contactModel = [[VETCallRecord alloc]init];
    if ([self openDB]!=SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return nil;
    }else{
        NSString *SQL=@"select * from t_contact where myAccount=? and account = ? limit 1";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [myAccount UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [account UTF8String], -1, NULL);
            while (sqlite3_step(statement)==SQLITE_ROW) {
                contactModel.dbId=sqlite3_column_int(statement, 0);
                
                char *name=(char *)sqlite3_column_text(statement, 1);
                if(name) contactModel.name=[[NSString alloc ] initWithUTF8String:name];
                
                char *account=(char *)sqlite3_column_text(statement, 2);
                if(account) contactModel.account=[[NSString alloc ] initWithUTF8String:account];
                
                char *domain=(char *)sqlite3_column_text(statement, 3);
                if(domain) contactModel.domain=[[NSString alloc ] initWithUTF8String:domain];
                
                char *attribution=(char *)sqlite3_column_text(statement, 4);
                if(attribution) contactModel.attribution=[[NSString alloc ] initWithUTF8String:attribution];
                
                VETNetworkType networkType=atoi((char*)sqlite3_column_text(statement, 5));
                contactModel.networkType = networkType;
                
                char  *myAccount=(char *)sqlite3_column_text(statement, 9);
                if(myAccount) contactModel.myAccount=[[NSString alloc ]initWithUTF8String:myAccount];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return contactModel;
}

- (BOOL)addAccount:(VETAccount *)account
{
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL = @"insert into t_account(username, password, domain, displayname, autologin, encryption, transport) values(?, ?, ?, ?, ?, ?, ?)";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [account.username UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [account.password UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [account.domain UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [account.displayName UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 5, account.autoLogin ? 1 : 0);
            sqlite3_bind_int(statement, 6, account.encryptionType);
            sqlite3_bind_int(statement, 7, account.transportType);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"帐户插入失败");
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:self];
    }
    return YES;
}

- (NSArray *)queryAccount
{
    NSMutableArray *resultList = [[NSMutableArray alloc]init];
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
    }else{
        NSString *SQL = @"select * from t_account";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                VETAccount *account = [[VETAccount alloc]init];
                char *username = (char *)sqlite3_column_text(statement, 0);
                if(username) account.username = [[NSString alloc ] initWithUTF8String:username];
                
                char *password = (char *)sqlite3_column_text(statement, 1);
                if(password) account.password = [[NSString alloc ] initWithUTF8String:password];
                
                char *domain = (char *)sqlite3_column_text(statement, 2);
                if(domain) account.domain = [[NSString alloc ] initWithUTF8String:domain];
                
                char *displayName = (char *)sqlite3_column_text(statement, 3);
                if(displayName) account.displayName = [[NSString alloc ] initWithUTF8String:displayName];
                
                int autoLoginStatus = (int)sqlite3_column_int(statement, 4);
                
                int encryptionType = (int)sqlite3_column_int(statement, 5);

                int transportType = (int)sqlite3_column_int(statement, 6);

                account.autoLogin = autoLoginStatus == 1 ? YES : NO;
                account.encryptionType = encryptionType;
                account.transportType = transportType;
                
                [resultList addObject:account];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return [resultList copy];
}

- (BOOL)updateAccount:(VETAccount *)account
{
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }
    else{
        NSString *SQL = @"update t_account set password=?, domain=?, displayname=?, autologin=?, transport=?, encryption=? where username=?";
        sqlite3_stmt *statement;
        int code1= sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1==SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [account.password UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [account.domain UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [account.displayName UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 4, account.autoLogin ? 1 : 0);
            sqlite3_bind_int(statement, 5, account.transportType);
            sqlite3_bind_int(statement, 6, account.encryptionType);
            sqlite3_bind_text(statement, 7, [account.username UTF8String], -1, NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"修改帐户失败");
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

- (BOOL)deleteAccount:(NSString *)username
{
    if (!username) {
        NSAssert(username, @"delete account is nil");
    }
    if ([self openDB] != SQLITE_OK) {//数据库打开失败
        sqlite3_close(db);
        LYLog(@"数据库打开失败",nil);
        return NO;
    }else{
        NSString *SQL = @"delete from t_account where username = ?";
        sqlite3_stmt *statement;
        int code1 = sqlite3_prepare_v2(db, [SQL UTF8String], -1, &statement, NULL);
        if (code1 == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [username UTF8String], -1, NULL);
            if (sqlite3_step(statement)!=SQLITE_DONE)
            {
                LYLog(@"帐户删除失败:%@",username);
                return NO;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

#pragma mark - 收藏联系人
/// 插入收藏的联系人
- (BOOL)insertFavoriteContact:(VETAppleContact *)contact
{
    if ([self openDB] != SQLITE_OK) {
        sqlite3_close(db);
        LYLog(@"数据库打开失败", nil);
        return NO;
    }
    else {
        
        /*
         *  插入到t_favorite_contact表
         */
        NSString *sqlString = @"insert or replace into t_favorite_contact(fullname, firstname, lastname, searchText) values(?, ?, ?, ?)";
        sqlite3_stmt *statement;
        int sql_prepare = sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, NULL);
        if (sql_prepare == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [contact.fullName UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [contact.firstName UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [contact.lastName UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [contact.searchText UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                LYLog(@"插入收藏联系人失败");
//                return NO;
            }
        }
        for (VETMobileModel *model in contact.mobileArray) {
            [self insertFavoriteContactMobile:model fullName:contact.fullName];
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

- (void)insertFavoriteContactMobile:(VETMobileModel *)mobileModel fullName:(NSString *)fullName
{
    NSString *sqlString2 = @"insert or replace into t_favorite_contact_mobile(fullname, mobiletype, mobilecontent) values(?, ?, ?)";
    sqlite3_stmt *statement2;
    int sql_prepare2 = sqlite3_prepare_v2(db, [sqlString2 UTF8String], -1, &statement2, NULL);
    if (sql_prepare2 == SQLITE_OK) {
        sqlite3_bind_text(statement2, 1, [fullName UTF8String], -1, NULL);
        sqlite3_bind_text(statement2, 2, [mobileModel.mobileType UTF8String], -1, NULL);
        sqlite3_bind_text(statement2, 3, [mobileModel.mobileContent UTF8String], -1, NULL);
        if (sqlite3_step(statement2) != SQLITE_DONE) {
            LYLog(@"插入收藏联系人手机号失败");
        }
    }
    else {
        NSLog(@"sql_prepare2:%d", sql_prepare2);
    }
    sqlite3_finalize(statement2);
}

/// 删除已收藏的联系人
- (BOOL)deleteFavoriteContact:(NSString *)fullName
{
    if ([self openDB] != SQLITE_OK) {
        sqlite3_close(db);
        LYLog(@"数据库打开失败", nil);
        return NO;
    }
    else {
        NSString *sqlString = @"delete from t_favorite_contact where fullname = ?";
        sqlite3_stmt *statement;
        int code = sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, NULL);
        if (code == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [fullName UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                LYLog(@"删除收藏联系人失败");
                return NO;
            }
        }
        
        [self deleteFavoriteContactMobile:fullName];
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return YES;
}

- (void)deleteFavoriteContactMobile:(NSString *)fullName
{
    NSString *sqlString = @"delete from t_favorite_contact_mobile where fullname = ?";
    sqlite3_stmt *statement;
    int code = sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, NULL);
    if (code == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [fullName UTF8String], -1, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            LYLog(@"删除收藏联系人电话失败");
        }
    }
    sqlite3_finalize(statement);
}

/// 查询已收藏的联系人
- (NSArray *)queryFavoritedContact
{
    NSMutableArray *resultArray = [NSMutableArray array];
    if ([self openDB] != SQLITE_OK) {
        sqlite3_close(db);
        LYLog(@"数据库打开失败", nil);
    }
    else {
        NSString *sqlString = [NSString stringWithFormat:@"select *from t_favorite_contact"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                VETAppleContact *appleContact = [VETAppleContact new];
                
                char *fullName = (char *)sqlite3_column_text(statement, 0);
                char *firstName = (char *)sqlite3_column_text(statement, 1);
                char *lastName = (char *)sqlite3_column_text(statement, 2);
                char *searchText = (char *)sqlite3_column_text(statement, 3);
                if(fullName) {
                    appleContact.fullName = [[NSString alloc] initWithUTF8String:fullName];
                }
                if (firstName) {
                    appleContact.firstName = [[NSString alloc] initWithUTF8String:firstName];
                }
                if (lastName) {
                    appleContact.lastName = [[NSString alloc] initWithUTF8String:lastName];
                }
                if (searchText) {
                    appleContact.searchText = [[NSString alloc] initWithUTF8String:searchText];
                }
                NSMutableArray *mobileArray = @[].mutableCopy;
                sqlite3_stmt *statement2;
                NSString *sqlString2 = [NSString stringWithFormat:@"select *from t_favorite_contact_mobile where fullname = ?"];
                
                if (sqlite3_prepare_v2(db, [sqlString2 UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    sqlite3_bind_text(statement2, 1, [appleContact.fullName UTF8String], -1, NULL);
                    while (sqlite3_step(statement2) == SQLITE_ROW) {
                        VETMobileModel *model = [VETMobileModel new];
                        char *mobileType = (char *)sqlite3_column_text(statement2, 1);
                        char *mobileContent = (char *)sqlite3_column_text(statement2, 2);
                        if (mobileType) {
                            model.mobileType = [[NSString alloc ] initWithUTF8String:mobileType];
                        }
                        if (mobileContent) {
                            model.mobileContent = [[NSString alloc ] initWithUTF8String:mobileContent];
                        }
                        [mobileArray addObject:model];
                    }
                }
                else {
                    LYLog(@"获取contact mobile失败");
                }
                appleContact.mobileArray = [mobileArray copy];
                [resultArray addObject:appleContact];
                sqlite3_finalize(statement2);
            }
        }
        sqlite3_finalize(statement);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sqlite3_close(db);
        });
    }
    return [resultArray copy];
}

@end
