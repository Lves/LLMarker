//
//  UIApplication+LLMarker.m
//  GrowingIODemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UIApplication+LLMarker.h"

@implementation UIApplication (LLMarker)
//childViewCOntroller是不是使用？？？？？？？？？？？？？？？？？
- (UIViewController *)ll_markerCurrentViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] lastObject];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = [self getTopFromVc:nextResponder];
    } else {
        if (window.rootViewController != nil) {
            result = [self getTopFromVc:window.rootViewController];
        }else {
            return nil;
        }
    }
    
    return result;
}

-(UIViewController *)getTopFromVc:(UIViewController *)vc{
    UIViewController *topController = vc;
    while (topController.presentedViewController != nil) {
        topController = topController.presentedViewController;
    }
    if ([topController isKindOfClass:[UINavigationController class]]) {
        topController = ((UINavigationController *)topController).viewControllers.lastObject;
    }else if ([topController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)topController;
        UIViewController *selected = tab.selectedViewController;
        if ([selected isKindOfClass:[UINavigationController class]]){
            return  ((UINavigationController *)selected).viewControllers.lastObject;
        }else {
            return tab;
        }
    }
    return topController;
}

@end
