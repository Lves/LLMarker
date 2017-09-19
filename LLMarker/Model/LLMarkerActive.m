//
//  LLMarkerActive.m
//  GrowingIODemo
//
//  Created by Pintec on 21/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerActive.h"

@implementation LLMarkerActive

+ (instancetype)activeWithAction:(NSString *)action
                           appId:(NSInteger)appId
                      createTime:(NSTimeInterval)createTime
                        deviceId:(NSString *)deviceId
                      deviceInfo:(NSString *)deviceInfo
                          userId:(NSString *)userId
                      longtitude:(double)longtitude
                        latitude:(double)latitude
                          remark:(NSString *)remark{
    return [[self alloc] initWithAction:action appId:appId createTime:createTime deviceId:deviceId deviceInfo:deviceInfo userId:userId longtitude:longtitude latitude:latitude remark:remark];
}

-(instancetype)initWithAction:(NSString *)action
                      appId:(NSInteger)appId
                   createTime:(NSTimeInterval)createTime
                      deviceId:(NSString *)deviceId
                 deviceInfo:(NSString *)deviceInfo
                     userId:(NSString *)userId
                     longtitude:(double)longtitude
                     latitude:(double)latitude
                       remark:(NSString *)remark{
    
    if (self = [super init]) {
        self.action = action;
        self.appId = appId;
        self.createTime = createTime;
        self.deviceId = deviceId;
        self.deviceInfo = deviceInfo;
        self.userId = userId;
        self.remark = remark;
        self.longtitude = longtitude;
        self.lantitude = latitude;
        self.remark = remark;
    }
    return self;
}
@end
