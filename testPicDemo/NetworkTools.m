//
//  NetworkTools.m
//  FanJiaoShou
//
//  Created by taobaichi on 16/8/2.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

#import "NetworkTools.h"


#import "MBProgressHUD+MJ.h"
@implementation NetworkTools
+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        //#warning 基地址
        //        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.bing.com"]];
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if ((self = [super init])) {
        // 设置超时时间，afn默认是60s
        self.requestSerializer.timeoutInterval = 30;
        // 响应格式添加text/plain
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
        
        // 监听网络状态,每当网络状态发生变化就会调用此block
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:     // 无连线
                      [MBProgressHUD showError:@"无网络连线"];
                    NSLog(@"无连线----AFNetworkReachability Not Reachable");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                    NSLog(@"手机自带网络-----AFNetworkReachability Reachable via WWAN");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
                    NSLog(@"----WiFi-----WiFiAFNetworkReachability Reachable via WiFi");
                    break;
                case AFNetworkReachabilityStatusUnknown:          // 未知网络
                default:
                    NSLog(@"未知网络----AFNetworkReachability Unknown");
                    break;
            }
        }];
        // 开始监听
        [self.reachabilityManager startMonitoring];
    }
    return self;
}
@end
