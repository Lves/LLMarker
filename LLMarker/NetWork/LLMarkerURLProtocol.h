//
//  LLMarkerURLProtocol.h
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLMarkerURLProtocol : NSURLProtocol
+ (void)ll_markerStart;
///给AFNetworking、SDWebImageView 和 Alamofire.SessionManger使用
+ (NSURLSessionConfiguration *) defaultSessionConfiguration;
@end
