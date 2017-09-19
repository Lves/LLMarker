//
//  LLMarkerNetwork.h
//  GrowingIODemo
//
//  Created by Pintec on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLMarkerNetwork : NSObject
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *params;
@property (nonatomic,copy) NSString *method;
@property (nonatomic,copy) NSString *header;
@property (nonatomic,copy) NSString *response;
@property (nonatomic,assign) NSInteger appId;
@property (nonatomic,assign) double createTime;
@property (nonatomic,assign) double duration;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *remark;

+ (instancetype)networkWithUrl:(NSString *)Url
                        params:(NSString *)params
                        method:(NSString *)method
                        header:(NSString *)header
                      response:(NSString *)response
                         appId:(NSInteger)appId
                    createTime:(NSTimeInterval)createTime
                      duration:(NSTimeInterval)duration
                        userId:(NSString *)userId
                        remark:(NSString *)remark;

-(instancetype)initWithUrl:(NSString *)url
                    params:(NSString *)params
                    method:(NSString *)method
                    header:(NSString *)header
                  response:(NSString *)response
                     appId:(NSInteger)appId
                createTime:(NSTimeInterval)createTime
                  duration:(NSTimeInterval)duration
                    userId:(NSString *)userId
                    remark:(NSString *)remark;
@end
