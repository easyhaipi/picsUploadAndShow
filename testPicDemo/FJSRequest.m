//
//  FJSRequest.m
//  FanJiaoShou
//
//  Created by taobaichi on 15/10/9.
//  Copyright © 2015年 taobaichi. All rights reserved.
//

#import "FJSRequest.h"
#import "MBProgressHUD+MJ.h"
#define k_FJS_SERVER_URL @"http://food.taobaichi.com/index.php"

@implementation FJSRequest

/**
 *  上传照片
 *  post
 *  @param logo      图片
 *  @param successBlock
 */
+ (void)uploadImageWithPics:(NSArray *)pics successBlock: (void(^)(BOOL isSuccess, NSDictionary *resultDic))successBlock
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/FanApi/Record/uploadImg",k_FJS_SERVER_URL];
    if (urlString == NULL)
    {
        return;
    }
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        
                                        for (int i = 0; i< pics.count; i++) {
                                            if (i < 9) {
                                                {
                                                    //                    NSData *data = UIImagePNGRepresentation(pics[i]);
                                                    NSData * data = UIImageJPEGRepresentation(pics[i], 0.8);
                                                    [formData appendPartWithFileData:data name:@"pic[]" fileName:@"test.png" mimeType:@"image/png"];
                                                    
                                                    
                                                }
                                            }
                                        }
                                        
                                        
                                    } error:nil];
    
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      //                      dispatch_async(dispatch_get_main_queue(), ^{
                      //
                      //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      //                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if ([[responseObject objectForKey:@"code"] isEqualToString:@"10020"]) {//发送成功
                          
                          [MBProgressHUD showSuccess:@"上传成功"];
                          
                          successBlock(YES,responseObject);
                          
                      } else
                      {
                          [MBProgressHUD showError:[responseObject objectForKey:@"message"]];
                          successBlock(NO,nil);
                      }
                      
                      
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];//
    
    
    
    
}

@end
