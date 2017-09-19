//
//  LLMarkerCrashLog.m
//  GrowingIODemo
//
//  Created by Pintec on 21/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerCrashLog.h"
@implementation LLMarkerCrashLog
+ (instancetype)pageWithMessage:(NSString *)message
                       appId:(NSInteger)appId
                  createTime:(NSTimeInterval)createTime
                      userId:(NSString *)userId
                      remark:(NSString *)remark{
    return [[self alloc] initWithMessage:message appId:appId createTime:createTime userId:userId remark:remark];
}

-(instancetype)initWithMessage:(NSString *)message
                         appId:(NSInteger)appId
                    createTime:(NSTimeInterval)createTime
                        userId:(NSString *)userId
                        remark:(NSString *)remark{
    
    if (self = [super init]) {
        self.message = message;
        self.appId = appId;
        self.createTime = createTime;
        self.userId = userId;
        self.remark = remark;
    }
    return self;
}
@end
