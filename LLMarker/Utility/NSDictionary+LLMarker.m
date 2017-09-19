//
//  NSDictionary+LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/10.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "NSDictionary+LLMarker.h"

@implementation NSDictionary (LLMarker)
-(NSString*)ll_markerData2JsonString
{
    NSString *jsonString = @"";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0 // NSJSONWritingPrettyPrinted: 有换位符;0：无换位符
                                                         error:&error];
    if (! jsonData) {
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
