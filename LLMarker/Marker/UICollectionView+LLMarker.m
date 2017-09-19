//
//  UICollectionView+LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 12/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UICollectionView+LLMarker.h"
#import "NSObject+LLMarker.h"
#import <objc/message.h>
#import "LLMarker.h"

@implementation UICollectionView (LLMarker)
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
    if ([delegate respondsToSelector:NSSelectorFromString(@"ll_markerCollectionViewDidSelectItemAtIndexPath")]){
        return;
    }
    if (class_addMethod([delegate class], NSSelectorFromString(@"ll_markerCollectionViewDidSelectItemAtIndexPath"), (IMP)ll_markerCollectionViewDidSelectItemAtIndexPath, "v@:@@")) {
        
        class_addMethod([delegate class], NSSelectorFromString(@"ll_markerDefaultCollectionViewDidSelectItemAtIndexPath"), (IMP)ll_markerDefaultCollectionViewDidSelectItemAtIndexPath, "v@:@@");
        
        [[delegate class] ll_markerSwizzle:[delegate class] originalSelector:@selector(collectionView:didSelectItemAtIndexPath:) swizzledSelector:NSSelectorFromString(@"ll_markerCollectionViewDidSelectItemAtIndexPath") defaultSelector:NSSelectorFromString(@"ll_markerDefaultCollectionViewDidSelectItemAtIndexPath")];
    }
}
void ll_markerCollectionViewDidSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, id indexPath){
    SEL selector = NSSelectorFromString(@"ll_markerCollectionViewDidSelectItemAtIndexPath");
    ((void (*)(id,SEL,id,id))objc_msgSend)(self,selector,collectionView,indexPath);
    [[LLMarker sharedInstance] ll_markerCollectionView:collectionView didSelctedIndexPath:indexPath target:self];
}
void ll_markerDefaultCollectionViewDidSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, id indexPath){
}

@end
