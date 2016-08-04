//
//  EMImagePickBrowserHelper.h
//  EMall
//
//  Created by Luigi on 16/8/4.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWPhoto.h>
//imagesArray  <OLFacebookImage>

typedef NS_ENUM(NSInteger, EMTakePictureType) {
    EMTakePictureTypeNone       ,
    EMTakePictureTypeCamrea     ,//相机
    EMTakePictureTypePhotoAblum ,//相册
    EMTakePictureTypeAll        ,//相机和相册
};


typedef void(^EMImagePickerCompletionBlock)(UIImage *editImage,UIImage *originImage,NSURL *fileUrl);

@interface EMImagePickBrowserHelper : NSObject
/**
 *  显示图片
 *
 *  @param controller
 *  @param completionBlock
 */
+ (void)showImagePickerOnController:(UIViewController *)controller
                           takeType:(EMTakePictureType)takePictureType
                  onCompletionBlock:(EMImagePickerCompletionBlock)completionBlock;

/**
 *  浏览图片
 *
 *  @param controller
 *  @param imageArray
 *  @param index
 */
+ (void)showImageBroswerOnController:(UIViewController *)controller
                      withImageArray:(NSArray *)imageArray
                        currentIndex:(NSInteger)index;
@end
