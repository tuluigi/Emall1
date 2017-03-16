//
//  UIImageView+EduUtils.h
//  Edu901iPhone
//
//  Created by user on 14-3-14.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
typedef void (^EduAsyncImageSuccessBlock_t)(UIImage *image);
typedef void (^EduAsyncImageCompletedBlock_t)(UIImage *image, NSError *error);
@interface UIImageView (EduUtils)
//- (void)setUserImageName:(NSString *)imageName;
//- (void)setUserImageName:(NSString *)imageName
//                 success:(EduAsyncImageSuccessBlock_t)success;
- (void)setCourseImageName:(NSString *)imageName;
- (void)setCourseImageName:(NSString *)imageName
                   success:(EduAsyncImageSuccessBlock_t)success;
- (void)setCourseImageName:(NSString *)imageName
                  animated:(BOOL)animated
                   success:(EduAsyncImageSuccessBlock_t)success;
- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
            original:(BOOL)original
             success:(EduAsyncImageSuccessBlock_t)success;

- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
            original:(BOOL)original
            animated:(BOOL)animated
             success:(EduAsyncImageSuccessBlock_t)success;

- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
                size:(CGSize)size
            animated:(BOOL)animated
             success:(EduAsyncImageSuccessBlock_t)success;

/**
 *  base function
 *
 *  @param imageName            图片资源url
 *  @param placeholderImageName 本地默认图片名称
 *  @param original             是否用原来的图片资源url，优先级大于size参数
 *  @param size                 图片要裁剪成的大小
 *  @param autoReplace          返回的图片是否要替换self.image, 优先级大于animated
 *  @param option               SDWebImageOptions
 *  @param animated             返回图片的替换是否结合动画
 *  @param success              请求图片资源成功的回调block
 */
- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
            original:(BOOL)original
                size:(CGSize)size
         autoReplace:(BOOL)autoReplace
              option:(SDWebImageOptions)option
            animated:(BOOL)animated
             success:(EduAsyncImageSuccessBlock_t)success;

- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
            original:(BOOL)original
                size:(CGSize)size
         autoReplace:(BOOL)autoReplace
            animated:(BOOL)animated
             success:(EduAsyncImageSuccessBlock_t)success;

////////////////////////////////////////////////////////////////////////////////
#pragma mark deprecated only for compatible
- (void)setImageWithURL:(NSString *)url imageSize:(CGSize)size;
@end
