//
//  FJSRequest.h
//  FanJiaoShou
//
//  Created by taobaichi on 15/10/9.
//  Copyright © 2015年 taobaichi. All rights reserved.
//

#import "HTTPRequestTool.h"

@interface FJSRequest : HTTPRequestTool



/**
 *  上传照片
 *  post
 *  @param logo      图片
 *  @param successBlock
 */
+ (void)uploadImageWithPics:(NSArray *)pics successBlock: (void(^)(BOOL isSuccess, NSDictionary *resultDic))successBlock;



@end
