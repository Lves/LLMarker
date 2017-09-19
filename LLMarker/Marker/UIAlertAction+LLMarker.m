//
//  UIAlertAction+LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UIAlertAction+LLMarker.h"
#import "NSObject+LLMarker.h"
#import "LLMarker.h"
#import "UIApplication+LLMarker.h"
@implementation UIAlertAction (LLMarker)
+(void)load{
    if (kll_markerOpenStatistics){
        [NSObject ll_markerSwizzleClassMethod:[self class] originalClassSelector:@selector(actionWithTitle:style:handler:) swizzledClassSelector:@selector(ll_markerActionWithTitle:style:handler:)];
    }
}

+(instancetype)ll_markerActionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction * _Nonnull))handler{
    
    return [[self class] ll_markerActionWithTitle:title style:style handler:^(UIAlertAction *action) {
        if (handler) {
            handler(action);
            UIViewController *currentVc = [[UIApplication sharedApplication] ll_markerCurrentViewController];
            [[LLMarker sharedInstance] ll_markerAlertActionClick:action currentVc:currentVc];
        }
    }];
}

@end
