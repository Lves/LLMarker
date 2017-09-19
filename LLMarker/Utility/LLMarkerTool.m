//
//  LLMarkerTool.m
//  GrowingIODemo
//
//  Created by Pintec on 18/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerTool.h"

static BOOL ll_markerOpenStatistics = true;  //是否开启统计
static BOOL ll_markerOpenLog = false;  //是否打印log

@implementation LLMarkerTool
#pragma mark - 是否开启点击事件统计
+(BOOL)openStatistics{
    __block BOOL open = true;
    static dispatch_once_t tableOnceToken;
    dispatch_once(&tableOnceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LLMarkerSetting" ofType:@"plist"];
        NSDictionary *setting = [NSDictionary dictionaryWithContentsOfFile:path];
        NSString *value = setting[@"OpenStatistics"];
        if (value){
            open = [value boolValue];
        }
        ll_markerOpenStatistics = open;
    });
    return ll_markerOpenStatistics;
}
#pragma mark - log
#pragma mark log开关
+(BOOL)openLog{
    __block BOOL open = true;
    static dispatch_once_t logOnceToken;
    dispatch_once(&logOnceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LLMarkerSetting" ofType:@"plist"];
        NSDictionary *setting = [NSDictionary dictionaryWithContentsOfFile:path];
        NSString *value = setting[@"OpenLog"];
        if (value){
            open = [value boolValue];
        }
        ll_markerOpenLog = open;
    });
    return ll_markerOpenLog;
}
#pragma mark 打印log
+(void)log:(id)info{
    if ([LLMarkerTool openLog]){
        NSLog(@"%@",info);
    }
}
@end
