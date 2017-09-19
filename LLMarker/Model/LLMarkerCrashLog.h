//
//  LLMarkerCrashLog.h
//  LLMarkerDemo
//
//  Created by lixingle on 21/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLMarkerCrashLog : NSObject
@property (nonatomic,copy) NSString *message;
@property (nonatomic,assign) NSInteger appId;
@property (nonatomic,assign) double createTime;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *remark;

+ (instancetype)pageWithMessage:(NSString *)message
                          appId:(NSInteger)appId
                     createTime:(NSTimeInterval)createTime
                         userId:(NSString *)userId
                         remark:(NSString *)remark;

-(instancetype)initWithMessage:(NSString *)message
                         appId:(NSInteger)appId
                    createTime:(NSTimeInterval)createTime
                        userId:(NSString *)userId
                        remark:(NSString *)remark;
@end
