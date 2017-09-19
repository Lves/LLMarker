//
//  UIView+LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "UIView+LLMarker.h"
#import "NSObject+LLMarker.h"
@implementation UIView (LLMarker)
-(NSString *)ll_markerViewPath{
    UIView *superView = [self superview];
    UIView *currentView = self;
    NSString *viewPath = [self ll_markerClassName];
    NSString *viewId = [NSString stringWithFormat:@"%@",[currentView ll_markerViewIndex]];
    
    if ([superView isKindOfClass:[UINavigationBar class]]) {    //对 UIBarButtonItem 特殊处理
        viewPath = [NSString stringWithFormat:@"%@-%@",[superView ll_markerClassName],viewPath];
        viewId = [NSString stringWithFormat:@"%@-%@",[superView ll_markerViewIndex],viewId];
        id vc = [superView ll_markerViewController]; // 拿到UINavigationController
        
        if ([vc isKindOfClass:[UINavigationController class]]){
            UINavigationController *naviVc = (UINavigationController *)vc;
            //            viewPath = [NSString stringWithFormat:@"UINavigationController-%@",viewPath];
            //            viewId = [NSString stringWithFormat:@"0-%@",viewId];
            UIViewController *topVc = [naviVc topViewController]; //获得当前viewController
            viewPath = [NSString stringWithFormat:@"%@-%@",[topVc  ll_markerClassName],viewPath];
            viewId = [NSString stringWithFormat:@"0-%@",viewId];
            return  [NSString stringWithFormat:@"%@&%@",viewPath,viewId];
        }
        
    }
    
    
    
    while (!([NSStringFromClass([superView class]) isEqualToString:@"UIViewControllerWrapperView"]
             || [NSStringFromClass([superView class]) isEqualToString:@"_UIAlertControllerView"])) {
        viewPath = [NSString stringWithFormat:@"%@-%@",[superView ll_markerClassName],viewPath];
        viewId = [NSString stringWithFormat:@"%@-%@",[superView ll_markerViewIndex],viewId];
        currentView = superView;
        superView = superView.superview;
        if (superView == nil){
            break;
        }
    }
    //拼接上view所在的controller
    NSString *vcName = [self ll_markerViewControllerName];
    viewPath = [vcName stringByAppendingFormat:@"-%@",viewPath];
    viewId = [@"0" stringByAppendingFormat:@"-%@",viewId];
    //path格式  viewController-viewPath&0-viewID
    NSString *viewTree = [NSString stringWithFormat:@"%@&%@",viewPath,viewId];
    
    return viewTree;
}

#pragma mark  在同类型子view中的index 值
-(NSString *)ll_markerViewIndex{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)self;
        UITableView *tableView = (UITableView *) [[cell superview] superview];
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        return [NSString stringWithFormat:@"%ld:%ld",indexPath.section,indexPath.row];
    }else if ([self isKindOfClass:[UICollectionViewCell class]]){
        UICollectionViewCell *cell = (UICollectionViewCell *)self;
        UICollectionView *collectionView = (UICollectionView *) [cell superview];
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        return [NSString stringWithFormat:@"%ld:%ld",indexPath.section,indexPath.row];
    }
    
    
    //获得view的类型
    Class  cls = self.class;
    NSInteger index = 0;
    for (UIView *subView in self.superview.subviews) {
        if ([subView isKindOfClass:cls]) { //与self 同类
            if (subView == self) {
                break;
            }
            index++;
        }
    }
    return [NSString stringWithFormat:@"%ld",index];
}



#pragma mark view所在的Controller
-(id)ll_markerViewController{
    id responder = self.nextResponder;
    while (![responder isKindOfClass: [UIViewController class]] && ![responder isKindOfClass: [UIWindow class]])
    {
        responder = [responder nextResponder];
    }
    if ([responder isKindOfClass: [UIViewController class]])
    {
        // responder就是view所在的控制器
        return responder;
    }else if ([responder isKindOfClass:[UIWindow class]]){
        return ((UIWindow *)responder).rootViewController;
    }
    return responder;
}
-(NSString *)ll_markerViewControllerName{
    id responder = [self ll_markerViewController];
    return [responder  ll_markerClassName];
}
@end
