//
//  NSObject+LLMarker.h
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/7.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSObject (LLMarker)
- (NSString *)ll_markerClassName;
- (id)getPrivateProperty:(NSString *)propertyName;
- (void) ll_markerSwizzle:(SEL)originalSelector swizzledSelector:(SEL)toSelector;
+ (void) ll_markerSwizzle:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)toSelector;
+ (void) ll_markerSwizzleClassMethod:(Class)class originalClassSelector:(SEL)originalSelector swizzledClassSelector:(SEL)toSelector;
+ (void) ll_markerSwizzle:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)toSelector defaultSelector:(SEL)defaultSelector;
@end
