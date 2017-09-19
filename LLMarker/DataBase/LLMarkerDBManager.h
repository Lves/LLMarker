//
//  LLMarkerDBManager.h
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLMarkerPage.h"
#import "LLMarkerControl.h"
#import "LLMarkerNetwork.h"
#import "LLMarkerCrashLog.h"
#import "LLMarkerActive.h"

@interface LLMarkerDBManager : NSObject
- (void)ll_markerCreateTable;
#pragma mark - page
- (BOOL)ll_markerInsertPage:(LLMarkerPage *)page;
- (void)ll_markerGetAllPagesInfo:(void (^)(NSArray *pageArray))resultBlock;
- (void)ll_markerGetPagesInfo:(NSInteger)limit  result:(void (^)(NSArray *pageArray))resultBlock;
-(BOOL) ll_markerDeletePagesBefor:(NSTimeInterval) timeInterval;
-(BOOL) ll_markerDeleteAllPages;
#pragma mark - control
- (BOOL) ll_markerInsertControl:(LLMarkerControl *)control;
- (void)ll_markerGetAllControlInfo:(void (^)(NSArray *controlArray))resultBlock;
- (void)ll_markerGetControlInfo:(NSInteger)limit  result:(void (^)(NSArray *controlArray))resultBlock;
-(BOOL) ll_markerDeleteControlBefor:(NSTimeInterval) timeInterval;
- (BOOL) ll_markerDeleteAllControl;
#pragma mark - Network
- (BOOL)ll_markerInsertNetwork:(LLMarkerNetwork *)network;
- (void)ll_markerGetAllNetworkInfo:(void (^)(NSArray *networkArray))resultBlock;
- (void)ll_markerGetNetworkInfo:(NSInteger)limit  result:(void (^)(NSArray *networkArray))resultBlock;
-(BOOL) ll_markerDeleteNetworkBefor:(NSTimeInterval) timeInterval;
-(BOOL) ll_markerDeleteAllNetwork;
#pragma mark - CrashLog
- (BOOL)ll_markerInsertCrashLog:(LLMarkerCrashLog *)crashLog;
- (void)ll_markerGetAllCrashLog:(void (^)(NSArray *crashLogArray))resultBlock;
- (void)ll_markerGetCrashLog:(NSInteger)limit  result:(void (^)(NSArray *crashLogArray))resultBlock;
-(BOOL) ll_markerDeleteCrashLogsBefor:(NSTimeInterval) timeInterval;
-(BOOL) ll_markerDeleteAllCrashLog;
#pragma mark - Active
- (BOOL)ll_markerInsertActive:(LLMarkerActive *)active;
- (void)ll_markerGetAllActive:(void (^)(NSArray *activeArray))resultBlock;
- (void)ll_markerGetActive:(NSInteger)limit  result:(void (^)(NSArray *activeArray))resultBlock;
-(BOOL) ll_markerDeleteActivesBefor:(NSTimeInterval) timeInterval;
-(BOOL) ll_markerDeleteAllActive;
@end
