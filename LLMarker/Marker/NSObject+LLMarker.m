//
//  NSObject+LLMarker.m
//  GrowingIODemo
//
//  Created by lixingle on 13/4/7.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "NSObject+LLMarker.h"
#import <objc/runtime.h>
#import "NSString+LLMarker.h"

@implementation NSObject (LLMarker)
-(void) ll_markerSwizzle:(SEL)originalSelector swizzledSelector:(SEL)toSelector{
    // 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method toMethod = class_getInstanceMethod([self class], toSelector);
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */
    if (!class_addMethod([self class], originalSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(originalMethod, toMethod);
    }else{
        class_replaceMethod([self class],
                            toSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
}
//给非代理方法用
+(void) ll_markerSwizzle:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)toSelector{
    Method toMethod = class_getInstanceMethod(class, toSelector);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!class_addMethod(class, originalSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(originalMethod, toMethod);
    }else{
        class_replaceMethod(class,
                            toSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
}
//给代理方法用，因为代理方法可能没实现所以加了一个默认Selector
+(void) ll_markerSwizzle:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)toSelector defaultSelector:(SEL)defaultSelector{
    Method toMethod = class_getInstanceMethod(class, toSelector);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method defaultMethod = class_getInstanceMethod(class, defaultSelector);
    if (!class_addMethod(class, originalSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(originalMethod, toMethod);
    }else{
        if (originalMethod == nil) {
            class_replaceMethod(class,
                                toSelector,
                                method_getImplementation(defaultMethod),
                                method_getTypeEncoding(defaultMethod));
        }else {
            class_replaceMethod(class,
                                toSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }
    }
}


+(void) ll_markerSwizzleClassMethod:(Class)class originalClassSelector:(SEL)originalSelector swizzledClassSelector:(SEL)toSelector{
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method toMethod = class_getClassMethod(class, toSelector);
    method_exchangeImplementations(originalMethod, toMethod);
    
}
- (nullable id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"ll_marker undefinedValueForKey:%@",key);
    return nil;
}

#pragma mark  对象名

- (NSString *)ll_markerClassName{
    return [NSStringFromClass([self class]) ll_markerRemoveModuleName];
}
#pragma mark - 私有属性
- (id)getPrivateProperty:(NSString *)propertyName
{
    Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
    
    if (iVar == nil) {
        iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@",propertyName] UTF8String]);
    }
    
    id propertyVal = object_getIvar(self, iVar);
    return propertyVal;
}


@end
