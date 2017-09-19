//
//  NSString+LLMarker.m
//  GrowingIODemo
//
//  Created by lixingle on 12/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "NSString+LLMarker.h"

@implementation NSString (LLMarker)
///去除swift项目的ModuleName
- (NSString *)ll_markerRemoveModuleName{
    NSString * bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    NSString *prefix = [NSString stringWithFormat:@"%@.",bundleName];
    if ([self hasPrefix:prefix]) {
        return [self substringFromIndex:prefix.length];
    }
    return self;
}

@end
