//
//  LLMarkerControl.h
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLMarkerControl : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *target;
@property (nonatomic,assign) long tag;
@property (nonatomic,copy) NSString *frame;
@property (nonatomic,assign)NSInteger appId;
@property (nonatomic,assign) double createTime;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *remark;

-(instancetype)initWithName:(NSString *)name
                      title:(NSString *)title
                       path:(NSString *)path
                      action:(NSString *)action
                       target:(NSString *)target
                        tag:(long)tag
                      frame:(NSString *)frame
                      appId:(NSInteger)appId
                 createTime:(NSTimeInterval)createTime
                     userId:(NSString *)userId
                 remark:(NSString *)remark;
+ (instancetype)controlWithName:(NSString *)name
                          title:(NSString *)title
                           path:(NSString *)path
                         action:(NSString *)action
                         target:(NSString *)target
                            tag:(long)tag
                          frame:(NSString *)frame
                          appId:(NSInteger)appId
                     createTime:(NSTimeInterval)createTime
                         userId:(NSString *)userId
                         remark:(NSString *)remark;
@end
