//
//  LLMarkerDBManager.m
//  GrowingIODemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerDBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define ll_markerDBNameKey     @"ll_markerDB"
#define ll_markerDBKey         [NSString stringWithFormat:@"%@.sqlite",ll_markerDBNameKey]

@interface LLMarkerDBManager ()
@property (nonatomic,strong) FMDatabaseQueue *queue;
@end

@implementation LLMarkerDBManager
#pragma mark 打开数据库
-(FMDatabaseQueue *)queue{
    if (_queue == nil) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        ///数据库沙河路径
        NSString *sqlPath = [documentPath stringByAppendingPathComponent:ll_markerDBKey];
        _queue = [FMDatabaseQueue databaseQueueWithPath:sqlPath];
    }
    return  _queue;
}


#pragma mark - 创建表
- (void)ll_markerCreateTable{
    FMDatabaseQueue *queue = [self queue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL r0 = [db executeUpdate:@"create table if not exists lxlmarker_page(id integer PRIMARY KEY AUTOINCREMENT, name text ,title text, duration double, appId integer, createTime double, userId text, remark text)"];
        BOOL r1 = [db executeUpdate:@"create table if not exists lxlmarker_control(id integer PRIMARY KEY AUTOINCREMENT, name text ,title text, path text,action text ,target text ,tag integer ,frame text,appId integer, createTime double,  userId text, remark text)"];
        BOOL r2 = [db executeUpdate:@"create table if not exists lxlmarker_network(id integer PRIMARY KEY AUTOINCREMENT, url text ,params text, method text ,header text, response text, appId integer,createTime double,duration double,  userId text, remark text)"];
        BOOL r3 = [db executeUpdate:@"create table if not exists lxlmarker_active(id integer PRIMARY KEY AUTOINCREMENT, action text , appId integer, createTime double,deviceId text ,deviceInfo text , userId text,longtitude double ,lantitude double, remark text)"];
        BOOL r4 = [db executeUpdate:@"create table if not exists lxlmarker_crashlog(id integer PRIMARY KEY AUTOINCREMENT, message text , appId integer, createTime double, userId text, remark text)"];
        if (!(r0 && r1 && r2 && r3 && r4)) {
            *rollback = YES;
            return;
        }
    }];
}

#pragma mark - page


- (BOOL)ll_markerInsertPage:(LLMarkerPage *)page{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:
                         @"insert into lxlmarker_page (name , title, duration ,appId ,createTime ,  userId , remark) values(? ,? ,? ,? ,? ,? ,?)"];
        [db executeUpdate:sql,page.name,page.title,@(page.duration),@(page.appId),@(page.createTime), page.userId ,page.remark];
    }];
    return true;
}
- (void)ll_markerGetAllPagesInfo:(void (^)(NSArray *pageArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from lxlmarker_page"];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerPage *page = [[LLMarkerPage alloc] init];
            page.name = [set stringForColumn:@"name"];
            page.title = [set stringForColumn:@"title"];
            page.duration = [set doubleForColumn:@"duration"];
            page.appId = [set intForColumn:@"appId"];
            page.createTime = [set doubleForColumn:@"createTime"];
            page.userId = [set stringForColumn:@"userId"];
            page.remark = [set stringForColumn:@"remark"];
            [result addObject:page];
        }
        resultBlock(result);
    }];
}
- (void)ll_markerGetPagesInfo:(NSInteger)limit  result:(void (^)(NSArray *pageArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from lxlmarker_page limit %ld;",limit];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerPage *page = [[LLMarkerPage alloc] init];
            page.name = [set stringForColumn:@"name"];
            page.title = [set stringForColumn:@"title"];
            page.duration = [set doubleForColumn:@"duration"];
            page.appId = [set intForColumn:@"appId"];
            page.createTime = [set doubleForColumn:@"createTime"];
            page.userId = [set stringForColumn:@"userId"];
            page.remark = [set stringForColumn:@"remark"];
            [result addObject:page];
        }
        resultBlock(result);
    }];
}

-(BOOL) ll_markerDeletePagesBefor:(NSTimeInterval) timeInterval{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_page where createTime <= ?" ,timeInterval];
    }];
    return true;
}
-(BOOL) ll_markerDeleteAllPages{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_page"];
    }];
    return true;
}

#pragma mark - Control
- (BOOL)ll_markerInsertControl:(LLMarkerControl *)control{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"insert into lxlmarker_control (name  ,title , path ,action  ,target ,tag ,frame ,appId , createTime , userId , remark) values(? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,?)"];
        [db executeUpdate:sql,control.name,control.title,control.path,control.action,control.target,@(control.tag),control.frame, @(control.appId),@(control.createTime), control.userId ,control.remark];
    }];
    return true;
}
- (void)ll_markerGetAllControlInfo:(void (^)(NSArray *controlArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from lxlmarker_control"];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerControl *control = [[LLMarkerControl alloc] init];
            control.name = [set stringForColumn:@"name"];
            control.title = [set stringForColumn:@"title"];
            control.path = [set stringForColumn:@"path"];
            control.action = [set stringForColumn:@"action"];
            control.target = [set stringForColumn:@"target"];
            control.tag = [set intForColumn:@"tag"];
            control.frame = [set stringForColumn:@"frame"];
            control.createTime = [set doubleForColumn:@"createTime"];
            control.appId = [set intForColumn:@"appId"];
            control.userId = [set stringForColumn:@"userId"];
            control.remark = [set stringForColumn:@"remark"];
            [result addObject:control];
        }
        resultBlock(result);
    }];
}


- (void)ll_markerGetControlInfo:(NSInteger)limit  result:(void (^)(NSArray *controlArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from lxlmarker_control limit %ld;",limit];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *result = [NSMutableArray array];
        while ([set next]) {
            LLMarkerControl *control = [[LLMarkerControl alloc] init];
            control.name = [set stringForColumn:@"name"];
            control.title = [set stringForColumn:@"title"];
            control.path = [set stringForColumn:@"path"];
            control.action = [set stringForColumn:@"action"];
            control.target = [set stringForColumn:@"target"];
            control.tag = [set intForColumn:@"tag"];
            control.frame = [set stringForColumn:@"frame"];
            control.createTime = [set doubleForColumn:@"createTime"];
            control.appId = [set intForColumn:@"appId"];
            control.userId = [set stringForColumn:@"userId"];
            control.remark = [set stringForColumn:@"remark"];
            [result addObject:control];
        }
        resultBlock(result);
    }];
}

-(BOOL) ll_markerDeleteControlBefor:(NSTimeInterval) timeInterval{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_control where createTime < ?" ,timeInterval];
    }];
    return true;
}
-(BOOL) ll_markerDeleteAllControl{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_control"];
    }];
    return true;
}

#pragma mark - Network

- (BOOL)ll_markerInsertNetwork:(LLMarkerNetwork *)network{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"insert into lxlmarker_network (url ,params , method  ,header , response , appId ,createTime ,duration ,  userId , remark ) values(? ,? ,? ,? ,? ,? ,? ,? ,? ,? )"];
        [db executeUpdate:sql,network.url,network.params,network.method, network.header,network.response,@(network.appId),@(network.createTime),@(network.duration),network.userId ,network.remark];
    }];
    return true;
}
- (void)ll_markerGetAllNetworkInfo:(void (^)(NSArray *networkArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from lxlmarker_network"];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerNetwork *network = [[LLMarkerNetwork alloc] init];
            network.url = [set stringForColumn:@"url"];
            network.params = [set stringForColumn:@"params"];
            network.method = [set stringForColumn:@"method"];
            network.header = [set stringForColumn:@"header"];
            network.response = [set stringForColumn:@"response"];
            network.appId = [set intForColumn:@"appId"];
            network.duration = [set doubleForColumn:@"duration"];
            network.createTime = [set doubleForColumn:@"createTime"];
            network.userId = [set stringForColumn:@"userId"];
            network.remark = [set stringForColumn:@"remark"];
            [result addObject:network];
        }
        resultBlock(result);
    }];
}

- (void)ll_markerGetNetworkInfo:(NSInteger)limit  result:(void (^)(NSArray *networkArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from lxlmarker_network limit %ld;",limit];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerNetwork *network = [[LLMarkerNetwork alloc] init];
            network.url = [set stringForColumn:@"url"];
            network.params = [set stringForColumn:@"params"];
            network.method = [set stringForColumn:@"method"];
            network.header = [set stringForColumn:@"header"];
            network.response = [set stringForColumn:@"response"];
            network.appId = [set intForColumn:@"appId"];
            network.duration = [set doubleForColumn:@"duration"];
            network.createTime = [set doubleForColumn:@"createTime"];
            network.userId = [set stringForColumn:@"userId"];
            network.remark = [set stringForColumn:@"remark"];
            [result addObject:network];
        }
        resultBlock(result);
    }];
}
-(BOOL) ll_markerDeleteNetworkBefor:(NSTimeInterval) timeInterval{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_network where createTime < ?" , timeInterval];
    }];
    return true;
}
-(BOOL) ll_markerDeleteAllNetwork{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_network"];
    }];
    return true;
}
#pragma mark - CrashLog
- (BOOL)ll_markerInsertCrashLog:(LLMarkerCrashLog *)crashLog{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:
                         @"insert into lxlmarker_crashlog (message  , appId , createTime , userId , remark ) values(? ,? ,? ,? ,?)"];
        [db executeUpdate:sql,crashLog.message,@(crashLog.appId),@(crashLog.createTime), crashLog.userId ,crashLog.remark];
    }];
    return true;
}
- (void)ll_markerGetAllCrashLog:(void (^)(NSArray *crashLogArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from lxlmarker_crashlog"];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerCrashLog *crashLog = [[LLMarkerCrashLog alloc] init];
            crashLog.message = [set stringForColumn:@"message"];
            crashLog.appId = [set intForColumn:@"appId"];
            crashLog.createTime = [set doubleForColumn:@"createTime"];
            crashLog.userId = [set stringForColumn:@"userId"];
            crashLog.remark = [set stringForColumn:@"remark"];
            [result addObject:crashLog];
        }
        resultBlock(result);
    }];
}
- (void)ll_markerGetCrashLog:(NSInteger)limit  result:(void (^)(NSArray *crashLogArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from lxlmarker_crashlog limit %ld;",limit];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerCrashLog *crashLog = [[LLMarkerCrashLog alloc] init];
            crashLog.message = [set stringForColumn:@"message"];
            crashLog.appId = [set intForColumn:@"appId"];
            crashLog.createTime = [set doubleForColumn:@"createTime"];
            crashLog.userId = [set stringForColumn:@"userId"];
            crashLog.remark = [set stringForColumn:@"remark"];
            [result addObject:crashLog];
        }
        resultBlock(result);
    }];
}


-(BOOL) ll_markerDeleteCrashLogsBefor:(NSTimeInterval) timeInterval{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_crashlog where createTime < ?" ,timeInterval];
    }];
    return true;
}
-(BOOL) ll_markerDeleteAllCrashLog{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_crashlog"];
    }];
    return true;
}
#pragma mark - Active
- (BOOL)ll_markerInsertActive:(LLMarkerActive *)active{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:
                         @"insert into lxlmarker_active (action, appId , createTime ,deviceId  ,deviceInfo  , userId ,longtitude  ,lantitude , remark) values(? ,? ,? ,? ,?,? ,? ,? ,?)"];
        [db executeUpdate:sql,active.action,@(active.appId), @(active.createTime),active.deviceId , active.deviceInfo ,active.userId,@(active.longtitude),@( active.lantitude),active.remark];
    }];
    return true;
}
- (void)ll_markerGetAllActive:(void (^)(NSArray *activeArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"select * from lxlmarker_active"];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerActive *active = [[LLMarkerActive alloc] init];
            active.action = [set stringForColumn:@"action"];
            active.appId = [set intForColumn:@"appId"];
            active.createTime = [set doubleForColumn:@"createTime"];
            active.deviceId = [set stringForColumn:@"deviceId"];
            active.deviceInfo = [set stringForColumn:@"deviceInfo"];
            active.userId = [set stringForColumn:@"userId"];
            active.longtitude = [set doubleForColumn:@"longtitude"];
            active.lantitude = [set doubleForColumn:@"lantitude"];
            active.remark = [set stringForColumn:@"remark"];
            [result addObject:active];
        }
        resultBlock(result);
    }];
}
- (void)ll_markerGetActive:(NSInteger)limit  result:(void (^)(NSArray *activeArray))resultBlock{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"select * from lxlmarker_active limit %ld;",limit];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *result = [NSMutableArray array];;
        while ([set next]) {
            LLMarkerActive *active = [[LLMarkerActive alloc] init];
            active.action = [set stringForColumn:@"action"];
            active.appId = [set intForColumn:@"appId"];
            active.createTime = [set doubleForColumn:@"createTime"];
            active.deviceId = [set stringForColumn:@"deviceId"];
            active.deviceInfo = [set stringForColumn:@"deviceInfo"];
            active.userId = [set stringForColumn:@"userId"];
            active.longtitude = [set doubleForColumn:@"longtitude"];
            active.lantitude = [set doubleForColumn:@"lantitude"];
            active.remark = [set stringForColumn:@"remark"];
            [result addObject:active];
        }
        resultBlock(result);
    }];
}

-(BOOL) ll_markerDeleteActivesBefor:(NSTimeInterval) timeInterval{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_active where createTime < ?" ,timeInterval];
    }];
    return true;
}
-(BOOL) ll_markerDeleteAllActive{
    FMDatabaseQueue *queue = [self queue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from lxlmarker_active"];
    }];
    return true;
}

@end
