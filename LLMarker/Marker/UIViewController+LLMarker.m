//
//  UIViewController+LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UIViewController+LLMarker.h"
#import "NSObject+LLMarker.h"
#import <objc/runtime.h>
#import "LLMarker.h"

static const char ll_markerAppearTimeKey = '\0';
static const char ll_markerCreateTimeKey = '\0';

@implementation UIViewController (LLMarker)
+ (void)load{
    if (kll_markerOpenStatistics){
        [NSObject ll_markerSwizzle:[self class] originalSelector:@selector(viewDidLoad) swizzledSelector:@selector(ll_markerViewDidLoad)];
        [NSObject ll_markerSwizzle:[self class] originalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(ll_markerViewDidAppear:)];
        [NSObject ll_markerSwizzle:[self class] originalSelector:@selector(viewDidDisappear:) swizzledSelector:@selector(ll_markerViewDidDisappear:)];
    }
    
}


#pragma mark - Associated 属性
-(void)setLl_markerAppearTime:(NSNumber *)ll_markerAppearTime{
    [self willChangeValueForKey:@"lxl_markerAppearTime"];
    objc_setAssociatedObject(self, &ll_markerAppearTimeKey,
                             ll_markerAppearTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"lxl_markerAppearTime"];
}
-(NSNumber *)ll_markerAppearTime{
    return objc_getAssociatedObject(self, &ll_markerAppearTimeKey);
}
-(void)setLl_markerCreateTime:(NSNumber *)ll_markerCreateTime{
    [self willChangeValueForKey:@"lxl_markerCreateTime"];
    objc_setAssociatedObject(self, &ll_markerCreateTimeKey,
                             ll_markerCreateTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"lxl_markerCreateTime"];
}
-(NSNumber *)ll_markerCreateTime{
    return objc_getAssociatedObject(self, &ll_markerCreateTimeKey);
}


#pragma mark - Swizzle 系统函数
// 我们自己实现的方法，也就是和self的viewDidLoad方法进行交换的方法。
- (void)ll_markerViewDidLoad {
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    // 我们在这里加一个判断，将系统的UIViewController的对象剔除掉
    if(![str containsString:@"UI"]){
        self.ll_markerCreateTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        [[LLMarker sharedInstance] ll_markerControllerViewDidLoad:self];
    }
    [self ll_markerViewDidLoad]; //执行的是UIViewController的viewDidLoad方法。
}

-(void)ll_markerViewDidAppear:(BOOL)animated{
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    if(![str containsString:@"UI"]){
        NSTimeInterval inTime = [[NSDate date] timeIntervalSince1970];
        self.ll_markerAppearTime = [NSNumber numberWithDouble:inTime];
        [[LLMarker sharedInstance] ll_markerControllerViewDidAppear:self];
    }
    [self ll_markerViewDidAppear:animated];
}
-(void)ll_markerViewDidDisappear:(BOOL)animated{
    NSString *str = [NSString stringWithFormat:@"%@", self.class];
    if(![str containsString:@"UI"]){
        NSTimeInterval outTime = [[NSDate date] timeIntervalSince1970];
        [[LLMarker sharedInstance] ll_markerControllerViewDidDisappear:self createTime:[self.ll_markerCreateTime doubleValue] stayTime:outTime - [[self ll_markerAppearTime] doubleValue]];
    }
    [self ll_markerViewDidDisappear:animated];
}

//-(void)dealloc{
//    if (kll_markerOpenStatistics){
//        NSString *str = [NSString stringWithFormat:@"%@", self.class];
//        if(![str containsString:@"UI"]){
//            [[LLMarker sharedInstance] ll_markerControllerDealloc:self];
//        }
//    }
//}
@end
