//
//  LLMarker.h
//  LLMarkerDemo
//
//  Created by lixingle on 12/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

/*
 集成方式：
 1. 添加fmdb:
 pod 'FMDB', '~> 2.6.2'
 2. 在Bridging-Header.h中添加：
 #import "LLMarker.h"
 3. appdelegate 中
 LLMarker.sharedInstance().ll_markerStart()
 LLMarkerAlamofire.sharedMarkerAlamofire.ll_markerStart()
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LLMarkerChooseView.h"
#import "LLMarkerTool.h"
#import "LLMarkerURLProtocol.h"
#import "LLMarkerDBManager.h"


@interface LLMarker : NSObject
/// 需要外部传过来
@property (nonatomic, copy) NSString *deviceInfo;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger appId;
+ (BOOL) handle:(NSURL *)url;
-(void)ll_markerStart;

/// 包内可用
+(instancetype)sharedInstance;
- (void) ll_markerView:(UIView *)view action:(SEL)action target:(id)target;
- (void) ll_markerTableView:(UITableView *)tableView didSelctedIndexPath:(NSIndexPath *)indexPath target:(id)target;
- (void) ll_markerCollectionView:(UICollectionView *)collectionView didSelctedIndexPath:(NSIndexPath *)indexPath target:(id)target;
- (void) ll_markerAlertActionClick:(UIAlertAction *)action currentVc:(UIViewController *)currentVc;
- (void) ll_markerGuestRecoginzer:(UIGestureRecognizer *)gesture action:(SEL)action target:(id)target;
- (void) ll_markerTextFieldDidEndEditing:(UITextField *)textField delegate:(id)delegate;
- (void) ll_markerControllerViewDidLoad:(UIViewController *) controller;
- (void) ll_markerControllerViewDidAppear:(UIViewController *) controller;
- (void) ll_markerControllerViewDidDisappear:(UIViewController *)controller createTime:(NSTimeInterval)createTime stayTime:(NSTimeInterval)time;
- (void) ll_markerControllerDealloc:(UIViewController *) controller;
- (void) ll_markerNetWorkingUrl:(NSString *)url
                          params:(NSDictionary *)params
                          method:(NSString *)method
                         header:(NSDictionary *)header
                        response:(NSString *)responseString
                      createTime:(NSTimeInterval) createTime
                        duration:(NSTimeInterval)duration;
@end
