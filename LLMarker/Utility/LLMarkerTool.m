//
//  LLMarkerTool.m
//  LLMarkerDemo
//
//  Created by lixingle on 18/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerTool.h"

static BOOL ll_markerOpenStatistics = true;  //是否开启统计
static BOOL ll_markerOpenLog = true;  //是否打印log

@implementation LLMarkerTool
#pragma mark - 是否开启点击事件统计
+(BOOL)openStatistics{
    return ll_markerOpenStatistics;
}
#pragma mark - log
#pragma mark log开关
+(BOOL)openLog{
    return ll_markerOpenLog;
}
#pragma mark 打印log
+(void)log:(id)info{
    if ([LLMarkerTool openLog]){
        NSLog(@"%@",info);
    }
}
@end
