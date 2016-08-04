//
//  EMImagePickBrowserHelper.m
//  EMall
//
//  Created by Luigi on 16/8/4.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMImagePickBrowserHelper.h"
#import <MWPhotoBrowser.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
static EMImagePickBrowserHelper *sharedEMHelper;

@interface EMImagePickBrowserHelper ()<UINavigationControllerDelegate,
MWPhotoBrowserDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,copy)EMImagePickerCompletionBlock imagePickerCompletionBlock;
@property (nonatomic,strong)NSArray *phototBrowserImagesArray;
@end

@implementation EMImagePickBrowserHelper
+ (instancetype)sharedHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil==sharedEMHelper) {
            sharedEMHelper=[[EMImagePickBrowserHelper alloc]   init];
        }
    });
    return sharedEMHelper;
}
- (instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}
+ (void)showImagePickerOnController:(UIViewController *)controller takeType:(EMTakePictureType)takePictureType onCompletionBlock:(EMImagePickerCompletionBlock)completionBlock{
    [EMImagePickBrowserHelper sharedHelper].imagePickerCompletionBlock=completionBlock;
    if (takePictureType==EMTakePictureTypeCamrea) {//相机
        BOOL isAvable=[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (isAvable) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
                AVAuthorizationStatus  authoStatus=[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) && (authoStatus==AVAuthorizationStatusDenied)) {
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    // app名称
                    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                    NSString *message=[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中,允许%@访问你的相机",app_Name];
                    
                    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *menAction=[UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *womenAction=[UIAlertAction actionWithTitle:@"立即更改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=Photos"]];
                    }];
                    
                    [alertController addAction:menAction];
                    [alertController addAction:womenAction];
                    
                    [controller presentViewController:alertController  animated:YES completion:^{
                    }];
                }else{
                    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]  init];
                    imagePickerController.delegate=[EMImagePickBrowserHelper sharedHelper];
                    imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
                    imagePickerController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
                    imagePickerController.showsCameraControls=YES;
                    imagePickerController.allowsEditing=YES;
                    [controller presentViewController:imagePickerController animated:YES completion:nil];
                }
            }
        }else{
            UIAlertView *alerView=[[UIAlertView alloc]  initWithTitle:@"提示" message:@"该设备不支持照相功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alerView show];
        }
    }else if (takePictureType==EMTakePictureTypePhotoAblum){//相册
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
            ALAuthorizationStatus authoStatus = [ALAssetsLibrary authorizationStatus];
            if (([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) && (authoStatus==ALAuthorizationStatusDenied)) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                // app名称
                NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                NSString *message=[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中,允许%@访问你的相册",app_Name];
                
                UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *menAction=[UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *womenAction=[UIAlertAction actionWithTitle:@"立即更改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=Photos"]];
                }];
                
                [alertController addAction:menAction];
                [alertController addAction:womenAction];
                
                [controller presentViewController:alertController  animated:YES completion:^{
                }];

                
            }else{
                UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]  init];
                imagePickerController.navigationBar.barTintColor=controller.navigationController.navigationBar.barTintColor;
                 imagePickerController.navigationBar.tintColor=controller.navigationController.navigationBar.tintColor;
                imagePickerController.delegate=[EMImagePickBrowserHelper sharedHelper];
                imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
                imagePickerController.allowsEditing=YES;
                [controller presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }else if (takePictureType==EMTakePictureTypeAll){//相机和相册
        
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"" message:nil
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *menAction=[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [EMImagePickBrowserHelper showImagePickerOnController:controller takeType:EMTakePictureTypeCamrea onCompletionBlock:completionBlock];
        }];
        UIAlertAction *womenAction=[UIAlertAction actionWithTitle:@"相册上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [EMImagePickBrowserHelper showImagePickerOnController:controller takeType:EMTakePictureTypePhotoAblum onCompletionBlock:completionBlock];
        }];
        UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:menAction];
        [alertController addAction:womenAction];
        [alertController addAction:cancleAction];
        [controller presentViewController:alertController  animated:YES completion:^{
            
        }];
    }
}

#pragma mark imagePickerController Delegate
#pragma mark -选取照片并上传
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
     UIImage *editImages;
     if (picker.allowsEditing) {
         editImages=[info objectForKey:@"UIImagePickerControllerEditedImage"];
     }else{
         editImages=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
     }
     UIImage *originImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
     NSURL *fileUrl=[info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    WEAKSELF
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.imagePickerCompletionBlock) {
            weakSelf.imagePickerCompletionBlock(editImages,originImage,fileUrl);
        }
    }];
}
#pragma mark- actionSheetDelegate


+ (void)showImageBroswerOnController:(UIViewController *)controller withImageArray:(NSArray *)imageArray currentIndex:(NSInteger)index{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:[EMImagePickBrowserHelper sharedHelper]];
    [EMImagePickBrowserHelper sharedHelper].phototBrowserImagesArray=imageArray;
    // Set options
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:1];
    browser.enableSwipeToDismiss=YES;
    // Prsent
    [controller.navigationController pushViewController:browser animated:YES];
    browser.navigationController.navigationBar.barTintColor=browser.navigationController.navigationBar.barTintColor;
    browser.navigationController.navigationBar.tintColor=controller.navigationController.navigationBar.tintColor;
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:index];
}


#pragma mark - photo browser delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [EMImagePickBrowserHelper sharedHelper].phototBrowserImagesArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [EMImagePickBrowserHelper sharedHelper].phototBrowserImagesArray.count) {
        return [[EMImagePickBrowserHelper sharedHelper].phototBrowserImagesArray objectAtIndex:index];
    }
    return nil;
}
@end
