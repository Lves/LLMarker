//
//  LLMarkerNetwork.m
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerNetwork.h"

@implementation LLMarkerNetwork
+ (instancetype)networkWithUrl:(NSString *)Url
                        params:(NSString *)params
                        method:(NSString *)method
                        header:(NSString *)header
                      response:(NSString *)response
                         appId:(NSInteger)appId
                    createTime:(NSTimeInterval)createTime
                      duration:(NSTimeInterval)duration
                        userId:(NSString *)userId
                        remark:(NSString *)remark{
    return [[self alloc] initWithUrl:Url params:params method:method header:header response:response appId:appId createTime:createTime duration:duration userId:userId remark:remark];
}

-(instancetype)initWithUrl:(NSString *)url
                    params:(NSString *)params
                    method:(NSString *)method
                    header:(NSString *)header
                  response:(NSString *)response
                     appId:(NSInteger)appId
                createTime:(NSTimeInterval)createTime
                  duration:(NSTimeInterval)duration
                    userId:(NSString *)userId
                    remark:(NSString *)remark{
    
    if (self = [super init]) {
        self.url = url;
        self.params = params;
        self.method = method;
        self.header = header;
        self.response = response;
        self.appId = appId;
        self.createTime = createTime;
        self.duration = duration;
        self.userId = userId;
        self.remark = remark;

    }
    return self;
}
@end
