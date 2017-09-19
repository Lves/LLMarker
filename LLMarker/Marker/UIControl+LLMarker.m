//
//  UIControl+LLMarker.m
//  GrowingIODemo
//
//  Created by lixingle on 13/4/7.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UIControl+LLMarker.h"
#import "NSObject+LLMarker.h"
#import <objc/runtime.h>
#import "LLMarker.h"
@implementation UIControl (LLMarker)
+(void)load{
    if (kll_markerOpenStatistics){
        [NSObject ll_markerSwizzle:[self class] originalSelector:@selector(sendAction:to:forEvent:) swizzledSelector:@selector(ll_markerSendAction:to:forEvent:)];
    }
}

-(void)ll_markerSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    [self ll_markerSendAction:action to:target forEvent:event];
    [[LLMarker sharedInstance] ll_markerView:self action:action target:target];
}

@end
