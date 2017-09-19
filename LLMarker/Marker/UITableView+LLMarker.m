//
//  UITableView+LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 12/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UITableView+LLMarker.h"
#import "NSObject+LLMarker.h"
#import <objc/message.h>
#import "LLMarker.h"
@implementation UITableView (LLMarker)
+(void)load{
    if (kll_markerOpenStatistics){
        static dispatch_once_t tableOnceToken;
        dispatch_once(&tableOnceToken, ^{
            [NSObject ll_markerSwizzle:[self class] originalSelector:@selector(setDelegate:) swizzledSelector:@selector(ll_markerSetDelegate:)];
        });
    }
}
-(void)ll_markerSetDelegate:(id<UITableViewDelegate>)delegate{
    [self ll_markerSetDelegate:delegate];
    if ([delegate respondsToSelector:NSSelectorFromString(@"ll_markerTableViewDidSelectRowAtIndexPath")]){
        return;
    }
    if(class_addMethod([delegate class], NSSelectorFromString(@"ll_markerTableViewDidSelectRowAtIndexPath"), (IMP)ll_markerTableViewDidSelectRowAtIndexPath, "v@:@@")){
        class_addMethod([delegate class], NSSelectorFromString(@"ll_markerDefaultTableViewDidSelectRowAtIndexPath"), (IMP)ll_markerDefaultTableViewDidSelectRowAtIndexPath, "v@:@@");
        
        [[delegate class] ll_markerSwizzle:[delegate class] originalSelector:@selector(tableView:didSelectRowAtIndexPath:) swizzledSelector:NSSelectorFromString(@"ll_markerTableViewDidSelectRowAtIndexPath") defaultSelector:NSSelectorFromString(@"ll_markerDefaultTableViewDidSelectRowAtIndexPath")];
        
    }
}

void ll_markerTableViewDidSelectRowAtIndexPath(id self , SEL _cmd ,id tableView ,id indexPath){
     SEL selector = NSSelectorFromString(@"ll_markerTableViewDidSelectRowAtIndexPath");
     ((void(*)(id, SEL, id, id))objc_msgSend)(self,selector,tableView,indexPath);
    [[LLMarker sharedInstance] ll_markerTableView:tableView didSelctedIndexPath:indexPath target:self];
}
void ll_markerDefaultTableViewDidSelectRowAtIndexPath(id self , SEL _cmd ,id tableView ,id indexPath){
    
}

@end
