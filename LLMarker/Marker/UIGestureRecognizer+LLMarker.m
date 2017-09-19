//
//  UIGestureRecognizer+LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UIGestureRecognizer+LLMarker.h"
#import "NSObject+LLMarker.h"
#import <objc/message.h>
#import "LLMarker.h"
@implementation UIGestureRecognizer (LLMarker)
+(void)load{
    if (kll_markerOpenStatistics){
        [NSObject ll_markerSwizzle:[self class] originalSelector:@selector(initWithTarget:action:) swizzledSelector:@selector(ll_markerInitWithTarget:action:)];
    }
}
-(instancetype)ll_markerInitWithTarget:(id)target action:(SEL)action{
    UIGestureRecognizer *selfGestureRecognizer = [self ll_markerInitWithTarget:target action:action];
    
    if (!target && !action) {
        return selfGestureRecognizer;
    }
    if ([target isKindOfClass:[UIScrollView class]]) {
        return selfGestureRecognizer;
    }
    if (![selfGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) { //只统计UITapGestureRecognizer
        return selfGestureRecognizer;
    }
    
    Class class = [target class];
    
    SEL originalSEL = action;
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"ll_marker%@", NSStringFromSelector(action)]);
    if ([target respondsToSelector:swizzledSEL]) {
        return selfGestureRecognizer;
    }
    
    BOOL isAddMethod = class_addMethod(class, swizzledSEL, (IMP)ll_markergestureAction, "v@:@");
    
    if (isAddMethod) {
        Method originalMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return selfGestureRecognizer;
}

void ll_markergestureAction(id self, SEL _cmd, id sender) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"ll_marker%@", NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);
    
    UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [[LLMarker sharedInstance] ll_markerGuestRecoginzer:sender action:_cmd target:self];
    }
}

@end
