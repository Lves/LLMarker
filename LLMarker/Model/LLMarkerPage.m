//
//  LLMarkerPage.m
//  GrowingIODemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerPage.h"

@implementation LLMarkerPage
+ (instancetype)pageWithName:(NSString *)name
                       title:(NSString *)title
                    duration:(NSTimeInterval)duration
                       appId:(NSInteger)appId
                  createTime:(NSTimeInterval)createTime
                      userId:(NSString *)userId
                      remark:(NSString *)remark{
    return [[self alloc] initWithName:name title:title duration:duration appId:appId createTime:createTime userId:userId remark:remark];
}

-(instancetype)initWithName:(NSString *)name
                      title:(NSString *)title
                   duration:(NSTimeInterval)duration
                      appId:(NSInteger)appId
                 createTime:(NSTimeInterval)createTime
                     userId:(NSString *)userId
                     remark:(NSString *)remark{
    
    if (self = [super init]) {
        self.name = name;
        self.title = title;
        self.duration = duration;
        self.createTime = createTime;
        self.appId = appId;
        self.userId = userId;
        self.remark = remark;
    }
    return self;
}
@end
