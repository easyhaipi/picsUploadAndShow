//
//  ViewController.m
//  testPicDemo
//
//  Created by taobaichi on 16/8/21.
//  Copyright © 2016年 taobaichi. All rights reserved.
//

#import "ViewController.h"

#import "QBImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "MBProgressHUD+MJ.h"



/// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define aboutInterval 10.0
#define marginX aboutInterval
#define marginY aboutInterval
#define photoCountOneRow 4
#define photoWidth  (kScreenWidth-aboutInterval*5)/photoCountOneRow
#define JYBMaxNumberOfDescriptionChars 150
#define k_FJS_SERVER_Image @"http://food.taobaichi.com"

#import "FJSRequest.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "MyCustomButton.h"
@interface ViewController ()<QBImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
        UIButton *updataButton;// 添加图片的按钮
}

// 上传图片相关
@property int pictureCounts;// 设置上传的图片限制
@property (nonatomic,strong) NSMutableArray *pictureArray;//最多上传的图片数量
@property (nonatomic,strong) NSMutableArray *everyNeedPicArray;//最多上传的图片数量
@property(nonatomic,strong)NSMutableArray *needUploadPicArray;// 最终要上传的图片数组
- (IBAction)upload:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *photosView;// 盛放图片的视图View

@property(nonatomic,strong) NSString*pictureID;
@property (nonatomic,strong) UIImageView *pictureImageView;
@property (nonatomic,strong) UIButton *pictureImageViewButton;



@property (nonatomic,strong) UIButton *deletePictureButton;


@property (strong, nonatomic) IBOutlet UILabel *numberCountLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始的图片数组
    self.pictureArray = [[NSMutableArray alloc] initWithCapacity:100];
    self.needUploadPicArray = [[NSMutableArray alloc] initWithCapacity:100];

    self.everyNeedPicArray = [[NSMutableArray alloc] initWithCapacity:100];
    
    
    updataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updataButton.frame = CGRectMake(marginX,marginY,photoWidth,photoWidth);
    [updataButton setBackgroundImage:[UIImage imageNamed:@"jiahaoanniu"] forState:UIControlStateNormal];
    [updataButton addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.photosView addSubview:updataButton];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addPhotoAction
{
    if (self.pictureCounts<10) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照",@"从本地相册上传",@"视频",@"从本地视频上传",nil];
        [actionSheet showInView:self.view];
    }else{
        NSLog(@"上传图片已到上限");//用UIAlertView;
    }

}


#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.pictureArray.count == 9) {
        [MBProgressHUD showError:@"最多选择九张图片"];
        NSLog(@"最多选择九张图片");
        
    }else{
        
        switch (buttonIndex) {
            case 0://照相机
            {
              
                
            }
                break;
            case 1://本地相簿
            {
                //                    NSLog(@"-----本地相簿-----");
                QBImagePickerController *imagePickerController = [QBImagePickerController new];
                imagePickerController.delegate = self;
                imagePickerController.mediaType = QBImagePickerMediaTypeImage;
                imagePickerController.allowsMultipleSelection = YES;
                imagePickerController.maximumNumberOfSelection = YES;
                imagePickerController.maximumNumberOfSelection = 9 - self.pictureArray.count;
                imagePickerController.showsNumberOfSelectedAssets = YES;
                
                [self presentViewController:imagePickerController animated:YES completion:NULL];
                
                
          
                
            }
                break;
                
            case 2://视频
            {
                
             
                
            }
                break;
                
            case 3://从本地选择视频
            {
                
                
            }
                break;
              
            case 4:{
                NSLog(@"取消");
            }
                break;
                
            default:
                break;
        }
        
    }
}
#pragma UIImagePickerController Delegate



//
#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    //
    
    
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        for (PHAsset *asset in assets)
        {
            
//            PHAsset
   
            //通过ALAsset获取相对应的资源，获取图片的等比缩略图，原图的等比缩略
//            CGImageRef ratioThum = [asset aspectRatioThumbnail];
//            UIImage* result = [UIImage imageWithCGImage:ratioThum];
            
//         UIImage* result=   [UIImage imageWithCGImage:[asset thumbnail]];
         
            
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                UIImage* resultImage = result;
                if (self.pictureArray.count<9) {
                    [self.pictureArray addObject:resultImage];
                    [self.everyNeedPicArray addObject:resultImage];
                }

                
                
                NSLog(@"------result--%@-----every-------%@",result,self.everyNeedPicArray);
                
                UIImage  *imageTemp=[UIImage sd_animatedGIFNamed:@"progress_loading"];
                UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,imageTemp.size.width, imageTemp.size.height)];
                gifview.image = imageTemp;
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.color = [UIColor clearColor];
                hud.dimBackground = YES;
                hud.mode = MBProgressHUDModeCustomView;
                hud.customView=gifview;
                
                
                [FJSRequest uploadImageWithPics:self.everyNeedPicArray successBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
                    if (isSuccess)
                    {
                        
                        
                        [hud hide:YES];
                        [MBProgressHUD showSuccess:@"上传成功"];
                        
                        [self.needUploadPicArray addObjectsFromArray:[[resultDic objectForKey:@"result"] objectForKey:@"pic_url"]];
                        
                        
                        
                        NSLog(@"存到数据库的图片数组--qb_imagePickerController--%@",self.needUploadPicArray);
                        NSLog(@"--%@",self.pictureArray);
                        
                        
                        [self.everyNeedPicArray removeAllObjects];
                        
                        [self addTheLocalPicture];
                        [hud hide:YES];
                        
                        
                        
                    } else
                    {// 上传失败
                        
                        [hud hide:YES];
                        
                     
                            
                            UIImage* resultImage = result;
                            if (self.pictureArray.count<9) {
                                if (result) {
                                    [self.pictureArray removeObject:resultImage];
                                    [self.everyNeedPicArray removeObject:resultImage];
                                }
                                
                            }
                            
                        
                        
                        
                    }
                }];
                

                
            }];
            
            
            
            
        }
        
        
       
        
    }];
    
    
}



//#pragma mark - QBImagePickerControllerDelegate
//
//- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
//{
//    //
//
//    [self dismissViewControllerAnimated:YES completion:^{
//        for (ALAsset *asset in assets)
//        {
//            // Do something with the asset
//            // 在资源的集合中获取第一个集合，并获取其中的图片
//            
//            //通过ALAsset获取相对应的资源，获取图片的等比缩略图，原图的等比缩略
//            CGImageRef ratioThum = [asset aspectRatioThumbnail];
//            UIImage* result = [UIImage imageWithCGImage:ratioThum];
//            
//         
//            if (self.pictureArray.count<9) {
//                [self.pictureArray addObject:result];
//                [self.everyNeedPicArray addObject:result];
//            }
//            
//            
//        }
//        
//        
//        UIImage  *imageTemp=[UIImage sd_animatedGIFNamed:@"progress_loading"];
//        UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,imageTemp.size.width, imageTemp.size.height)];
//        gifview.image = imageTemp;
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//        hud.color = [UIColor clearColor];
//        hud.dimBackground = YES;
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.customView=gifview;
//        
//        
//        [FJSRequest uploadImageWithPics:self.everyNeedPicArray successBlock:^(BOOL isSuccess, NSDictionary *resultDic) {
//            if (isSuccess)
//            {
//                
//                
//                [hud hide:YES];
//                [MBProgressHUD showSuccess:@"上传成功"];
//                
//                [self.needUploadPicArray addObjectsFromArray:[[resultDic objectForKey:@"result"] objectForKey:@"pic_url"]];
//                
//                
//                
//                NSLog(@"存到数据库的图片数组--qb_imagePickerController--%@",self.needUploadPicArray);
//                NSLog(@"--%@",self.pictureArray);
//                
//                
//                [self.everyNeedPicArray removeAllObjects];
//                
//                [self addTheLocalPicture];
//                [hud hide:YES];
//                
//                
//                
//            } else
//            {// 上传失败
//                
//                [hud hide:YES];
//                
//                
//                for (ALAsset *asset in assets)
//                {
//                    // Do something with the asset
//                    // 在资源的集合中获取第一个集合，并获取其中的图片
//                    
//                    //通过ALAsset获取相对应的资源，获取图片的等比缩略图，原图的等比缩略
//                    CGImageRef ratioThum = [asset aspectRatioThumbnail];
//                    UIImage* result = [UIImage imageWithCGImage:ratioThum];
//                    
//                   
//                    if (self.pictureArray.count<9) {
//                        if (result) {
//                            [self.pictureArray removeObject:result];
//                            [self.everyNeedPicArray removeObject:result];
//                        }
//                        
//                    }
//                    
//                }
//            }
//        }];
//        
//    }];
//    
//    
//}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark ----显示要上传的照片
#pragma mark ----显示图片
-(void)addTheLocalPicture{
    
    for (int i=0; i<self.pictureArray.count; i++)
    {
        
        if([[self.pictureArray objectAtIndex:i] isKindOfClass:[NSString class]]) // 如果是缓存的图片
        {
            
            UIButton *backgroundButton ;
            NSString *picString = [self.pictureArray objectAtIndex:i];
            // 获得加载出来的图片
            self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*(i%photoCountOneRow),marginY+(photoWidth+aboutInterval)*(i/photoCountOneRow), photoWidth, photoWidth)];
            self.pictureImageView.tag = 100+i;
            self.pictureImageView.backgroundColor =[UIColor clearColor];
            [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_FJS_SERVER_Image,picString]] placeholderImage:[UIImage imageNamed:@"smallMapPlaceholderImage1"]];
            
            
            [self.photosView addSubview:self.pictureImageView];
            
            
            backgroundButton = [[UIButton alloc] initWithFrame:self.pictureImageView.frame];
            backgroundButton.tag = 300+i;
            [backgroundButton addTarget:self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            self.pictureImageViewButton = backgroundButton;
            [self.photosView insertSubview:backgroundButton aboveSubview:self.pictureImageView];
            
            
            //添加删除按钮
            self.deletePictureButton=[MyCustomButton buttonWithType:UIButtonTypeCustom];
            self.deletePictureButton.frame=CGRectMake(0, 0, 20, 20);
            self.deletePictureButton.center=CGPointMake(self.pictureImageView.frame.origin.x+self.pictureImageView.frame.size.width, self.pictureImageView.frame.origin.y);
            self.deletePictureButton.tag=200+i;
            
            self.deletePictureButton.backgroundColor=[UIColor clearColor];
            [self.deletePictureButton setBackgroundImage:[UIImage imageNamed:@"deleteredBtn"] forState:UIControlStateNormal];
            [self.deletePictureButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.photosView addSubview:self.deletePictureButton];
            
            
            [updataButton setFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*(self.pictureArray.count%photoCountOneRow) ,marginY+(photoWidth+aboutInterval)*(self.pictureArray.count/photoCountOneRow), photoWidth, photoWidth)];
            self.pictureCounts=(int)self.pictureArray.count;
            
            
            
        }else
        {// 如果没有缓存的数据
            
            UIImageView *oldImageView = (UIImageView *)[self.photosView viewWithTag:100+i];
            if (!oldImageView.image) {
                
                // 获得加载出来的图片
                self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*(i%photoCountOneRow),marginY+(photoWidth+aboutInterval)*(i/photoCountOneRow), photoWidth, photoWidth)];
                self.pictureImageView.tag = 100+i;
                self.pictureImageView.backgroundColor =[UIColor clearColor];
                if ([[self.pictureArray objectAtIndex:i] isKindOfClass:[UIImage class]]) {
                    
                    self.pictureImageView.image=[self.pictureArray objectAtIndex:i];
                    
                }
                [self.photosView addSubview:self.pictureImageView];
                
                
                
                
                UIButton * backgroundButton = [[UIButton alloc] initWithFrame:self.pictureImageView.frame];
                    backgroundButton.tag = 300+i;
                    [backgroundButton addTarget:self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];
                    
              
                self.pictureImageViewButton = backgroundButton;
                [self.photosView insertSubview:backgroundButton aboveSubview:self.pictureImageView];
                
                
                //添加删除按钮
                self.deletePictureButton = [MyCustomButton buttonWithType:UIButtonTypeCustom];
                self.deletePictureButton.frame=CGRectMake(0, 0, 20, 20);
                self.deletePictureButton.center=CGPointMake(self.pictureImageView.frame.origin.x+self.pictureImageView.frame.size.width, self.pictureImageView.frame.origin.y);
                self.deletePictureButton.tag=200+i;
                
                self.deletePictureButton.backgroundColor=[UIColor clearColor];
                [self.deletePictureButton setBackgroundImage:[UIImage imageNamed:@"deleteredBtn"] forState:UIControlStateNormal];
                [self.deletePictureButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.photosView addSubview:self.deletePictureButton];
                
                
                
                
                
                [updataButton setFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*(self.pictureArray.count%photoCountOneRow) ,marginY+(photoWidth+aboutInterval)*(self.pictureArray.count/photoCountOneRow), photoWidth, photoWidth)];
                self.pictureCounts=(int)self.pictureArray.count;
                
            }
            
            
        }
    }

 
    
    
    
}
#pragma mark ----点击删除按钮
-(void)clickDeleteButton:(MyCustomButton *)bt{
    
    int buttonTag=(int)bt.tag-200;
    
    
    int playButtonTag = 999;
    

 
    
    if (buttonTag > self.pictureArray.count || buttonTag > self.needUploadPicArray.count) {
        return;
    }
    
    [self.pictureArray removeObjectAtIndex:buttonTag];
    [self.needUploadPicArray removeObjectAtIndex:buttonTag];// 需要上传的图片也要删除
    

    
  
    
    if (buttonTag == self.pictureArray.count) {  // 删除最后一个 图片  不用怎么修改与重建
 
        for (UIView *view in self.photosView.subviews) {
            if (view.tag == (buttonTag +100) ) {
                [view removeFromSuperview];
            }
            if (view.tag == (buttonTag +300) ) {
                [view removeFromSuperview];
            }
            if (view.tag == (buttonTag +200) ) {
                [view removeFromSuperview];
            }
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            [updataButton setFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*(buttonTag%photoCountOneRow),(photoWidth+aboutInterval)*(buttonTag/photoCountOneRow)+ marginY, photoWidth, photoWidth)];
            
            NSLog(@"---updataButton--%@",updataButton);
        }];
        
    }else{

        
        for (UIView *view in self.photosView.subviews) {
            if (view.tag > 0 ) {
                [view removeFromSuperview];
            }
            
        }
        
        //重新创建
        
        for (int j= 0; j< self.pictureArray.count; j++) {
            if (j<buttonTag) { // 删除的那个视图前面的那两个
                
                
                self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*(j%photoCountOneRow),(photoWidth+aboutInterval)*(j/photoCountOneRow)+marginY, photoWidth, photoWidth)];
                self.pictureImageView.tag = 100+j;
                self.pictureImageView.backgroundColor =[UIColor clearColor];
                if ([[self.pictureArray objectAtIndex:j] isKindOfClass:[UIImage class]])
                {//如果是图片
                    self.pictureImageView.image=[self.pictureArray objectAtIndex:j];
                } else
                  if([[self.pictureArray objectAtIndex:j] isKindOfClass:[NSString class]])// 如果是网络缓存图片
                        {
                            NSString *picString = [self.pictureArray objectAtIndex:j];
                            
                            [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_FJS_SERVER_Image,picString]] placeholderImage:[UIImage imageNamed:@"smallMapPlaceholderImage1"]];
                        }
                
                
                [self.photosView addSubview:self.pictureImageView];
                
                self.deletePictureButton=[MyCustomButton buttonWithType:UIButtonTypeCustom];
                self.deletePictureButton.frame=CGRectMake(0, 0, 20, 20);
                self.deletePictureButton.center=CGPointMake(self.pictureImageView.frame.origin.x+self.pictureImageView.frame.size.width, self.pictureImageView.frame.origin.y);
                self.deletePictureButton.tag=200+j;
                self.deletePictureButton.backgroundColor=[UIColor clearColor];
                [self.deletePictureButton setBackgroundImage:[UIImage imageNamed:@"deleteredBtn"] forState:UIControlStateNormal];
                [self.deletePictureButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                
                            //   图片预览添加手势
                    
                    self.pictureImageViewButton = [[UIButton alloc] initWithFrame:self.pictureImageView.frame];
                    self.pictureImageViewButton.tag = 300+j;
                    
                    [self.pictureImageViewButton addTarget:self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];
                    
              
                
                [self.photosView insertSubview:self.pictureImageViewButton aboveSubview:self.pictureImageView];
                
                [self.photosView addSubview:self.deletePictureButton];
                
                
            }else{
                
                //好像有点不对 j     0,1
                self.pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*((j+1)%photoCountOneRow), marginY+(photoWidth+aboutInterval)*((j+1)/photoCountOneRow), photoWidth, photoWidth)];
                self.pictureImageView.tag = 100+j;
                
                self.pictureImageView.backgroundColor =[UIColor clearColor];
                
                if ([[self.pictureArray objectAtIndex:j] isKindOfClass:[UIImage class]]) {//如果是图片
                    self.pictureImageView.image =[self.pictureArray objectAtIndex:j];
                } else
                    
                        if([[self.pictureArray objectAtIndex:j] isKindOfClass:[NSString class]])// 如果是网络缓存图片
                        {
                            NSString *picString = [self.pictureArray objectAtIndex:j];
                            
                            [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_FJS_SERVER_Image,picString]] placeholderImage:[UIImage imageNamed:@"smallMapPlaceholderImage1"]];
                        }
                
                
                [self.photosView addSubview:self.pictureImageView];
                
                
                
                
                
                
                
//             图片预览添加手势
                
                    self.pictureImageViewButton = [[UIButton alloc] initWithFrame:self.pictureImageView.frame];
                    self.pictureImageViewButton.tag = 300+j;
                    
                    [self.pictureImageViewButton addTarget:self action:@selector(buttonTapAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                             self.deletePictureButton=[MyCustomButton buttonWithType:UIButtonTypeCustom];
                self.deletePictureButton.frame=CGRectMake(0, 0, 20, 20);
                self.deletePictureButton.center=CGPointMake(self.pictureImageView.frame.origin.x+self.pictureImageView.frame.size.width, self.pictureImageView.frame.origin.y);
                self.deletePictureButton.tag=200+j;
                self.deletePictureButton.backgroundColor=[UIColor clearColor];
                [self.deletePictureButton setBackgroundImage:[UIImage imageNamed:@"deleteredBtn"] forState:UIControlStateNormal];
                [self.deletePictureButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.photosView insertSubview:self.pictureImageViewButton aboveSubview:self.pictureImageView];
                [self.photosView addSubview:self.deletePictureButton];
            }
            
        }
        
        //想要一个动画
        
        for (int thatButton= buttonTag; thatButton<= self.pictureArray.count; thatButton++) {
            
            UIImageView *nextImageView=(UIImageView *)[self.photosView viewWithTag:thatButton+100];
            UIButton *nextButton=(UIButton *)[self.photosView viewWithTag:thatButton+200];
            UIButton *pictureImageViewButton=(UIButton *)[self.photosView viewWithTag:thatButton+300];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [nextImageView setFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*(thatButton%photoCountOneRow), marginY+(photoWidth+aboutInterval)*(thatButton/photoCountOneRow), photoWidth, photoWidth)];
                nextButton.center=CGPointMake(nextImageView.frame.origin.x+nextImageView.frame.size.width, nextImageView.frame.origin.y);
                
                [pictureImageViewButton setFrame:nextImageView.frame];
            }];
            
        }
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        [updataButton setFrame:CGRectMake(marginX+(photoWidth+aboutInterval)*(self.pictureArray.count%photoCountOneRow),(photoWidth+aboutInterval)*(self.pictureArray.count/photoCountOneRow)+marginY, photoWidth, photoWidth)];
    }];
    
    self.pictureCounts=self.pictureCounts-1;
    

    
    
    
    
}








-(void)buttonTapAction:(UIButton *)button
{
    NSLog(@"预览图片");
}

- (IBAction)upload:(id)sender {
    if (self.pictureCounts<10) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照",@"从本地相册上传",@"视频",@"从本地视频上传",nil];
        [actionSheet showInView:self.view];
    }else{
        NSLog(@"上传图片已到上限");//用UIAlertView;
    }
}
@end
