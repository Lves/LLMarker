//
//  LLMarkerTool.h
//  GrowingIODemo
//
//  Created by Pintec on 18/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kll_markerOpenStatistics [LLMarkerTool openStatistics]
#define LLMarkerLog(info)  [LLMarkerTool log:info];

@interface LLMarkerTool : NSObject
/// 点击事件统计开关
+(BOOL)openStatistics;
///log
+(void)log:(id)info;
@end
