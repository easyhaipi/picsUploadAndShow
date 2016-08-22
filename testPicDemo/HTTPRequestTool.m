//
//  HTTPRequestTool.m
//  FanJiaoShou
//
//  Created by taobaichi on 15/10/9.
//  Copyright © 2015年 taobaichi. All rights reserved.
//

#import "HTTPRequestTool.h"
#import "NetworkTools.h"
#import "MBProgressHUD+MJ.h"


#define k_FJS_SERVER_URL @"http://food.taobaichi.com/index.php"
@implementation HTTPRequestTool
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *))failure
{

    
    NSString *urlStr = [k_FJS_SERVER_URL stringByAppendingString:url];
    if (urlStr == NULL)
    {
        return;
    }
    
    NetworkTools *sessionManager = [NetworkTools manager];
       sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
     sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    if (params)
    //    {
    //        [self setHeadParameters:params sessionMgr:sessionManager];
    //    }
    //
    [sessionManager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //         告诉外界(外面):我们请求成功了
        if (success) {
            success(responseObject);
        }
        //        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //在这统一告诉请求连接失败
          [MBProgressHUD showError:@"网络请求连接失败"];
//        if (failure) {
//            failure(error);
//        }
    }];
    
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    
    
    // 1.获得请求管理者
    
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
//    
//    
//    // 2.发送一个POST请求
//    NSString *urlStr = [k_FJS_SERVER_URL stringByAppendingString:url];
//    [mgr POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功后会调用
//        // 告诉外界(外面):我们请求成功了
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败后会调用
//        // 告诉外界(外面):我们请求失败了
//        if (failure) {
//            failure(error);
//        }
//    }];
    
    
    NSString *urlStr = [k_FJS_SERVER_URL stringByAppendingString:url];
    if (urlStr == NULL)
    {
        return;
    }
    
    NetworkTools *sessionManager = [NetworkTools sharedManager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",nil];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];

//    
    [sessionManager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//         告诉外界(外面):我们请求成功了
                if (success) {
                    success(responseObject);
                }
//        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [MBProgressHUD showError:@"网络请求连接失败"];
//                if (failure) {
//                    failure(error);
//                }
    }];
}

@end
