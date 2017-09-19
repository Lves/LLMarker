//
//  LLMarkerPage.h
//  GrowingIODemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLMarkerPage : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) NSTimeInterval duration;
@property (nonatomic,assign) NSInteger appId;
@property (nonatomic,assign) NSTimeInterval createTime;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *remark;



+ (instancetype)pageWithName:(NSString *)name
                       title:(NSString *)title
                    duration:(NSTimeInterval)duration
                       appId:(NSInteger)appId
                  createTime:(NSTimeInterval)createTime
                      userId:(NSString *)userId
                      remark:(NSString *)remark;

-(instancetype)initWithName:(NSString *)name
                      title:(NSString *)title
                   duration:(NSTimeInterval)duration
                      appId:(NSInteger)appId
                 createTime:(NSTimeInterval)createTime
                     userId:(NSString *)userId
                   remark:(NSString *)remark;
@end
