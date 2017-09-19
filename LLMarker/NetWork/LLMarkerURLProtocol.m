//
//  LLMarkerURLProtocol.m
//  GrowingIODemo
//
//  Created by Pintec on 13/4/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

#import "LLMarkerURLProtocol.h"
#import "LLMarker.h"

static NSString * const hasInitKey = @"LLMarkerWebViewProtocolKey";
static NSInteger  const kResponseLength = 100;

@interface LLMarkerURLProtocol ()<NSURLConnectionDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *method;
@property (nonatomic, strong) NSDictionary *headers;
@end
@implementation LLMarkerURLProtocol
#pragma mark - defaultSessionConfiguration
+ (NSURLSessionConfiguration *) defaultSessionConfiguration{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableArray *array = [[config protocolClasses] mutableCopy];
    [array insertObject:[self class] atIndex:0];
    config.protocolClasses = array;
    return config;
}

#pragma mark - NSURLProtocol
+ (void)ll_markerStart
{
    [NSURLProtocol registerClass:[self class]];
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request{
    if ([NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
        return NO;
    }
    return YES;
}
+(BOOL)canInitWithTask:(NSURLSessionTask *)task{
    return YES;
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

-(void)startLoading{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //做下标记，防止递归调用
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableReqeust];
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    _method = mutableReqeust.HTTPMethod;
    _urlStr = mutableReqeust.URL.absoluteString;
    _startTime = [NSDate date];
    _headers = mutableReqeust.allHTTPHeaderFields;
}

-(void)stopLoading{
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:_startTime];
    NSString *str = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSInteger length = MIN(str.length, kResponseLength);
    NSString *responseStr = [str substringToIndex:length];
    [[LLMarker sharedInstance] ll_markerNetWorkingUrl:_urlStr params:nil method:_method header:_headers response:responseStr createTime:[_startTime timeIntervalSince1970] duration:elapsedTime];
    [self.connection cancel];

}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.client URLProtocol:self didFailWithError:error];
}
#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}
@end
