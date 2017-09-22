//
//  LLMarker.m
//  LLMarkerDemo
//
//  Created by lixingle on 12/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarker.h"
#import "UIView+LLMarker.h"
#import "NSString+LLMarker.h"
#import "LLMarkerDBManager.h"
#import "NSObject+LLMarker.h"
#import "NSDictionary+LLMarker.h"
#include <mach/mach.h>

static LLMarker *ll_markerInstance = nil;
//当前线程数
int getThreadsCount()
{
    thread_array_t threadList;
    mach_msg_type_number_t threadCount;
    task_t task;
    
    kern_return_t kernReturn = task_for_pid(mach_task_self(), getpid(), &task);
    if (kernReturn != KERN_SUCCESS) {
        return -1;
    }
    
    kernReturn = task_threads(task, &threadList, &threadCount);
    if (kernReturn != KERN_SUCCESS) {
        return -1;
    }
    vm_deallocate (mach_task_self(), (vm_address_t)threadList, threadCount * sizeof(thread_act_t));
    
    return threadCount;
}

@interface LLMarker ()<UIApplicationDelegate>
@property (nonatomic,strong) LLMarkerDBManager *dbManager;
@property (nonatomic,copy) NSString *uuid;
@property (nonatomic,strong) dispatch_queue_t ll_queue;
@end

@implementation LLMarker
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ll_markerInstance = [[self alloc] init];
        ll_markerInstance.dbManager = [[LLMarkerDBManager alloc] init];
        [ll_markerInstance.dbManager ll_markerCreateTable];
    });
    return ll_markerInstance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ll_markerInstance = [super allocWithZone:zone];
        ll_markerInstance.dbManager = [[LLMarkerDBManager alloc] init];
        [ll_markerInstance.dbManager ll_markerCreateTable];
    });
    return ll_markerInstance;
}

- (instancetype)copyWithZone:(struct _NSZone *)zone{
    return ll_markerInstance;
}

-(void)ll_markerStart{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ll_markerApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ll_markerApplicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        LLMarkerActive *active = [LLMarkerActive activeWithAction:@"Launch"
                                                            appId:weakSelf.appId
                                                       createTime:[[NSDate date] timeIntervalSince1970]
                                                         deviceId:weakSelf.uuid
                                                       deviceInfo:weakSelf.deviceInfo
                                                           userId:weakSelf.userId
                                                       longtitude:0
                                                         latitude:0
                                                           remark:nil];
        
        [weakSelf.dbManager ll_markerInsertActive:active];
    });
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 并行队列
- (dispatch_queue_t)ll_queue{
    if (_ll_queue == nil) {
        _ll_queue = dispatch_queue_create("com.ll.marker", DISPATCH_QUEUE_CONCURRENT);
    }
    return _ll_queue;
}

#pragma mark - Handle URL
+ (BOOL) handle:(NSURL *)url{
    NSString *urlStr = url.absoluteString;
    if ([urlStr hasPrefix:@"llmarker://"]) {
        [[LLMarkerChooseView sharedInstance] addToWindow];
        return true;
    }
    return false;
}

#pragma mark - application


- (void)ll_markerApplicationDidEnterBackground:(NSNotification *)notification{
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        LLMarkerActive *active = [LLMarkerActive activeWithAction:@"In"
                                                            appId:weakSelf.appId
                                                       createTime:[[NSDate date] timeIntervalSince1970]
                                                         deviceId:weakSelf.uuid
                                                       deviceInfo:weakSelf.deviceInfo
                                                           userId:weakSelf.userId
                                                       longtitude:0
                                                         latitude:0
                                                           remark:nil];
        
        [weakSelf.dbManager ll_markerInsertActive:active];
    });

}
- (void)ll_markerApplicationWillEnterForeground:(NSNotification *)notification{
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        LLMarkerActive *active = [LLMarkerActive activeWithAction:@"Out"
                                                            appId:weakSelf.appId
                                                       createTime:[[NSDate date] timeIntervalSince1970]
                                                         deviceId:weakSelf.uuid
                                                       deviceInfo:weakSelf.deviceInfo
                                                           userId:weakSelf.userId
                                                       longtitude:0
                                                         latitude:0
                                                           remark:nil];
        
        [weakSelf.dbManager ll_markerInsertActive:active];
    });

}
#pragma mark - getter
-(NSString *)uuid{
    if (_uuid == nil) {
        _uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return _uuid;
}


#pragma mark - Action
-(void)ll_markerView:(UIView *)view action:(SEL)action target:(id)target{
    //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
    NSString *title = @"";
    if ([view isKindOfClass:[UIButton class]]) {
        title = [(UIButton *)view titleLabel].text;
    }else if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]){
        UILabel *lable = [view getPrivateProperty:@"label"];
        title = lable.text;
        /***
         * UITabBarButton 会进来3次，action分别是:_buttonDown:、_sendAction:withEvent:、_buttonUp:
         * 这里只收录 _sendAction:withEvent:
         */
        if (![NSStringFromSelector(action) isEqualToString:@"_sendAction:withEvent:"]) {
            return;
        }
        
    }
    NSInteger tag = view.tag;
    NSString *frameStr = NSStringFromCGRect(view.frame);
     NSString *path = [view ll_markerViewPath];
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        LLMarkerLog(path)
        LLMarkerControl *control = [LLMarkerControl controlWithName:[view ll_markerClassName]
                                   title:title
                                    path:path
                                  action:NSStringFromSelector(action)
                                  target:[target ll_markerClassName]
                                     tag:tag
                                   frame:frameStr
                                   appId:weakSelf.appId
                              createTime:[[NSDate date] timeIntervalSince1970]
                                  userId:weakSelf.userId
                                  remark:nil];
        [weakSelf.dbManager ll_markerInsertControl:control];
    });
    
}

#pragma mark -  TableViewCell selected

- (void) ll_markerTableView:(UITableView *)tableView didSelctedIndexPath:(NSIndexPath *)indexPath target:(id)target{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    NSString *path = [cell ll_markerViewPath];
    NSInteger tag = cell.tag;
    NSString *frameStr = NSStringFromCGRect(cell.frame);
    
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        
        LLMarkerLog(path);
        LLMarkerControl *control = [LLMarkerControl controlWithName:[cell ll_markerClassName]
                                                              title:title
                                                               path:path
                                                             action:@"tableView:didSelectRowAtIndexPath:"
                                                             target:[target ll_markerClassName]
                                                                tag:tag
                                                              frame:frameStr
                                                              appId:weakSelf.appId
                                                         createTime:[[NSDate date] timeIntervalSince1970]
                                                             userId:weakSelf.userId
                                                             remark:nil];
        [weakSelf.dbManager ll_markerInsertControl:control];
    });
}
#pragma mark -  CollectionCell selected
- (void) ll_markerCollectionView:(UICollectionView *)collectionView didSelctedIndexPath:(NSIndexPath *)indexPath target:(id)target{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSString *path = [cell ll_markerViewPath];
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        
        LLMarkerLog(path)
        LLMarkerControl *control = [LLMarkerControl controlWithName:[cell ll_markerClassName]
                                                              title:@""
                                                               path:path
                                                             action:@"collectionView:didSelectItemAtIndexPath:"
                                                             target:[target ll_markerClassName]
                                                                tag:cell.tag
                                                              frame:NSStringFromCGRect(cell.frame)
                                                              appId:weakSelf.appId
                                                         createTime:[[NSDate date] timeIntervalSince1970]
                                                             userId:weakSelf.userId
                                                             remark:nil];
        [weakSelf.dbManager ll_markerInsertControl:control];
    });
}
#pragma mark - UIAlertAction
/**
 * AlertAction 的路径比较特殊，因为他不是继承自UIView所以无法追溯出其路径，所以采用：
 * CurrentViewController-UIAlertAction-Title
 */
- (void) ll_markerAlertActionClick:(UIAlertAction *)action currentVc:(UIViewController *)currentVc{
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        NSString *actionPath = [NSString stringWithFormat:@"%@-%@-%@",[currentVc ll_markerClassName],[action ll_markerClassName],action.title];
        LLMarkerLog(actionPath);
        LLMarkerControl *control = [LLMarkerControl controlWithName:[action ll_markerClassName]
                                                              title:action.title
                                                               path:actionPath
                                                             action:@""
                                                             target:[currentVc ll_markerClassName]
                                                                tag:0
                                                              frame:@""
                                                              appId:weakSelf.appId
                                                         createTime:[[NSDate date] timeIntervalSince1970]
                                                             userId:weakSelf.userId
                                                             remark:nil];
        [weakSelf.dbManager ll_markerInsertControl:control];
    });
}
#pragma mark - GuestRecoginzer

- (void) ll_markerGuestRecoginzer:(UIGestureRecognizer *)guestRecoginzer action:(SEL)action target:(id)target{
    
    NSInteger tag = guestRecoginzer.view.tag;
    NSString *frameStr = NSStringFromCGRect(guestRecoginzer.view.frame);
    NSString *path = [guestRecoginzer.view ll_markerViewPath];
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        LLMarkerLog(path)
        NSString *title = @"";
        if ([guestRecoginzer.view isKindOfClass:[UILabel class]]) {
            UILabel *lable = (UILabel *)guestRecoginzer.view;
            title = lable.text;
        }
        LLMarkerControl *control = [LLMarkerControl controlWithName:[guestRecoginzer.view ll_markerClassName]
                                                              title:title
                                                               path:path
                                                             action:NSStringFromSelector(action)
                                                             target:[target ll_markerClassName]
                                                                tag:tag
                                                              frame:frameStr
                                                              appId:weakSelf.appId
                                                         createTime:[[NSDate date] timeIntervalSince1970]
                                                             userId:weakSelf.userId
                                                             remark:nil];
        [weakSelf.dbManager ll_markerInsertControl:control];
    });
}
#pragma mark - UITexField delegate
-(void) ll_markerTextFieldDidEndEditing:(UITextField *)textField delegate:(id)delegate{
    NSString *path = [textField ll_markerViewPath];
    NSString *frameStr = NSStringFromCGRect(textField.frame);
    NSInteger tag = textField.tag;
    NSString *text = textField.text;
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        LLMarkerLog(path);
        LLMarkerControl *control = [LLMarkerControl controlWithName:[textField ll_markerClassName]
                                                              title:text
                                                               path:path
                                                             action:@"textFieldDidEndEditing:"
                                                             target:[delegate ll_markerClassName]
                                                                tag:tag
                                                              frame:frameStr
                                                              appId:weakSelf.appId
                                                         createTime:[[NSDate date] timeIntervalSince1970]
                                                             userId:weakSelf.userId
                                                             remark:nil];
        [weakSelf.dbManager ll_markerInsertControl:control];
    });
}
#pragma mark - UIViewController

- (void) ll_markerControllerViewDidLoad:(UIViewController *) controller{
    
}
- (void) ll_markerControllerViewDidAppear:(UIViewController *) controller{
    
}
- (void) ll_markerControllerViewDidDisappear:(UIViewController *)controller createTime:(NSTimeInterval)createTime stayTime:(NSTimeInterval)time{
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        NSString *log = [NSString stringWithFormat:@"stay:%@ time:%f", [controller ll_markerClassName],time];
        LLMarkerLog(log)
        LLMarkerPage *page = [LLMarkerPage pageWithName:[controller ll_markerClassName]
                             title:controller.title
                          duration:time
                             appId:weakSelf.appId
                        createTime:createTime
                            userId:weakSelf.userId
                            remark:nil];
        [weakSelf.dbManager ll_markerInsertPage:page];
    });
}
- (void) ll_markerControllerDealloc:(UIViewController *) controller{
    NSString *str = [NSString stringWithFormat:@"dealloc:%@",[controller ll_markerClassName]];
    LLMarkerLog(str)
}

#pragma mark - NetWorking
- (void) ll_markerNetWorkingUrl:(NSString *)url
                          params:(NSDictionary *)params
                          method:(NSString *)method
                          header:(NSDictionary *)header
                        response:(NSString *)responseString
                      createTime:(NSTimeInterval) createTime
                        duration:(NSTimeInterval)duration{
   
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.ll_queue, ^{
        //NSLog(@"count %d %@",getThreadsCount(),[NSThread currentThread]);
        NSString *log = [NSString stringWithFormat:@"%@ %@[%.4f] -->%@",method,url,duration,responseString];
        LLMarkerLog(log)
        LLMarkerNetwork *network = [LLMarkerNetwork networkWithUrl:url
                                                            params:[params ll_markerData2JsonString]
                                                            method:method
                                                            header:[header ll_markerData2JsonString]
                                                          response:responseString
                                                             appId:weakSelf.appId
                                                        createTime:createTime
                                                          duration:duration
                                                            userId:weakSelf.userId
                                                            remark:nil];
        [weakSelf.dbManager ll_markerInsertNetwork:network];
    });
}


@end

