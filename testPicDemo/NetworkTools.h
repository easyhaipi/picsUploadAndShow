//
//  NetworkTools.h
//  FanJiaoShou
//
//  Created by taobaichi on 16/8/2.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

#import "AFNetworking.h"
@interface NetworkTools : AFHTTPSessionManager
+ (instancetype)sharedManager;
@end
