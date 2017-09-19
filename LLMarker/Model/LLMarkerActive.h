//
//  LLMarkerActive.h
//  GrowingIODemo
//
//  Created by Pintec on 21/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLMarkerActive : NSObject
@property (nonatomic,copy) NSString *action;
@property (nonatomic,assign) NSInteger appId;
@property (nonatomic,assign) NSTimeInterval createTime;
@property (nonatomic,copy) NSString *deviceId;
@property (nonatomic,copy) NSString *deviceInfo;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) double longtitude;
@property (nonatomic,assign) double lantitude;
@property (nonatomic,copy) NSString *remark;
+ (instancetype)activeWithAction:(NSString *)action
                           appId:(NSInteger)appId
                      createTime:(NSTimeInterval)createTime
                        deviceId:(NSString *)deviceId
                      deviceInfo:(NSString *)deviceInfo
                          userId:(NSString *)userId
                      longtitude:(double)longtitude
                        latitude:(double)latitude
                          remark:(NSString *)remark;

-(instancetype)initWithAction:(NSString *)action
                        appId:(NSInteger)appId
                   createTime:(NSTimeInterval)createTime
                     deviceId:(NSString *)deviceId
                   deviceInfo:(NSString *)deviceInfo
                       userId:(NSString *)userId
                   longtitude:(double)longtitude
                     latitude:(double)latitude
                       remark:(NSString *)remark;
@end
