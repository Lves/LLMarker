//
//  LLMarkerChooseView.m
//  GrowingIODemo
//
//  Created by lixingle on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerChooseView.h"
#import "UIApplication+LLMarker.h"
#import "UIView+LLMarker.h"
#import "LLMarker.h"

static LLMarkerChooseView *ll_markerChooseView = nil;

@interface LLMarkerChooseView ()
@property (nonatomic,strong) CAShapeLayer *circularLayer;
@property (nonatomic,strong) UIView *currentView;
@end



@implementation LLMarkerChooseView

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ll_markerChooseView = [[self alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
        ll_markerChooseView.backgroundColor = [UIColor redColor];
        ll_markerChooseView.layer.cornerRadius = 50/2.f;
        ll_markerChooseView.layer.masksToBounds = YES;
    });
    return ll_markerChooseView;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ll_markerChooseView = [super allocWithZone:zone];
    });
    return ll_markerChooseView;
}


- (instancetype)copyWithZone:(struct _NSZone *)zone{
    return ll_markerChooseView;
}

-(CAShapeLayer *)circularLayer{
    if (_circularLayer == nil) {
        _circularLayer = [CAShapeLayer new];
        _circularLayer.backgroundColor = [UIColor colorWithRed:20/255.0 green:200/255.0 blue:20/255.0 alpha:0.5].CGColor;
        _circularLayer.masksToBounds = YES;
        _circularLayer.cornerRadius = 5.f;
        
    }
    return _circularLayer;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.currentView){
        NSString *log = [NSString stringWithFormat:@"choose: %@",[self.currentView ll_markerViewPath]];
        LLMarkerLog(log)
    }
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint nextP = [touch previousLocationInView:self.superview];
    self.center = nextP;
    //圈选
    UIView *currentView = [[UIApplication sharedApplication] ll_markerCurrentViewController].view;
    if ([self findTouchActionView:currentView event:@"Moved"] == false){
        UIViewController *currentVc = [[UIApplication sharedApplication] ll_markerCurrentViewController];
        UINavigationBar *naviBar = currentVc.navigationController.navigationBar;
        [self findTouchBar:naviBar];
    }
}

-(void)addToWindow{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}


#pragma mark - 递归查找
- (BOOL) findTouchActionView:(UIView *)actionView event:(NSString *)type{
    //frame转换
    CGPoint point = [[UIView new] convertPoint:self.center toView:actionView];
    NSArray *subViews = actionView.subviews;
    if ([actionView isKindOfClass:[UITableView class]]) {
        subViews = actionView.subviews.firstObject.subviews;
    }
    for (UIView *nextView in subViews) {
        if (CGRectContainsPoint(nextView.frame, point)){
            //递归进去继续查找！！！！！！！！！！！！
            if ([nextView isKindOfClass:[UIControl class]] ||
                ([nextView isKindOfClass:[UITableViewCell class]]) ||
                [nextView isKindOfClass:[UICollectionViewCell class]]  ||
                (nextView.gestureRecognizers.count > 0 && ![nextView isKindOfClass:NSClassFromString(@"UITableViewWrapperView")] && ![nextView isKindOfClass:[UICollectionView class]])){
                
                self.circularLayer.frame = nextView.bounds;
                [nextView.layer addSublayer:self.circularLayer];
                self.currentView = nextView;
                return true;
            }else {
                return [self findTouchActionView:nextView event:type];
            }
        }
    }
    self.currentView = nil;
    [self.circularLayer removeFromSuperlayer];
    return false;
}

-(BOOL) findTouchBar:(UINavigationBar *)bar{
    //frame转换
    CGPoint point = [[UIView new] convertPoint:self.center toView:bar];
    UINavigationItem *currentItem = bar.items.lastObject;
    
    for (UIBarButtonItem *barButton in currentItem.leftBarButtonItems) {
        UIView *nextView = [barButton valueForKey:@"view"];
        if (CGRectContainsPoint(nextView.frame, point)){
            self.circularLayer.frame = nextView.bounds;
            [nextView.layer addSublayer:self.circularLayer];
            self.currentView = nextView;
            return true;
        }
    }
    for ( UIBarButtonItem *barButton in currentItem.rightBarButtonItems) {
        UIView *nextView = [barButton valueForKey:@"view"];
        if (CGRectContainsPoint(nextView.frame, point)){
            self.circularLayer.frame = nextView.bounds;
            [nextView.layer addSublayer:self.circularLayer];
            self.currentView = nextView;
            return true;
        }
    }
    self.currentView = nil;
    [self.circularLayer removeFromSuperlayer];
    return false;
}

@end
