//
//  LLMarkerControl.m
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerControl.h"

@implementation LLMarkerControl
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
                         remark:(NSString *)remark{
    return [[self alloc] initWithName:name title:title path:path action:action target:target tag:tag frame:frame appId:appId createTime:createTime userId:userId remark:remark];
}

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
                     remark:(NSString *)remark{
    
    if (self = [super init]) {
        self.action = action;
        self.target = target;
        self.name = name;
        self.title = title;
        self.path = path;
        self.tag = tag;
        self.frame = frame;
        self.appId = appId;
        self.createTime = createTime;
        self.userId = userId;
        self.remark = remark;
    }
    return self;
}
@end
