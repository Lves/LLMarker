//
//  UITextField+LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UITextField+LLMarker.h"
#import "NSObject+LLMarker.h"
#import <objc/message.h>
#import "LLMarker.h"
@implementation UITextField (LLMarker)
+(void)load{
    if (kll_markerOpenStatistics){
        [NSObject ll_markerSwizzle:[self class] originalSelector:@selector(setDelegate:) swizzledSelector:@selector(ll_markerSetDelegate:)];
    }
}
-(void)ll_markerSetDelegate:(id<UITextFieldDelegate>)delegate{
    [self ll_markerSetDelegate:delegate];
    if ([delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        if ([delegate respondsToSelector:NSSelectorFromString(@"ll_markerTextFieldDidEndEditing")]) {
            return;
        }
        if (class_addMethod([delegate class], NSSelectorFromString(@"ll_markerTextFieldDidEndEditing"), (IMP)ll_markerTextFieldDidEndEditing, "V@:@")){
            
            class_addMethod([delegate class], NSSelectorFromString(@"ll_markerDefaultTextFieldDidEndEditing"), (IMP)ll_markerDefaultTextFieldDidEndEditing, "V@:@");
            [[delegate class] ll_markerSwizzle:[delegate class] originalSelector:@selector(textFieldDidEndEditing:) swizzledSelector:NSSelectorFromString(@"ll_markerTextFieldDidEndEditing") defaultSelector:NSSelectorFromString(@"ll_markerDefaultTextFieldDidEndEditing")];
        }
    }
}

void ll_markerTextFieldDidEndEditing(id self,SEL _cmd,id textField){
    SEL selector = NSSelectorFromString(@"ll_markerTextFieldDidEndEditing");
    ((void(*)(id,SEL,id))objc_msgSend)(self,selector,textField);
    [[LLMarker sharedInstance] ll_markerTextFieldDidEndEditing:textField delegate:self];
}
void ll_markerDefaultTextFieldDidEndEditing(id self,SEL _cmd,id textField){
}

@end
