//
//  UIImageView+EduUtils.m
//  Edu901iPhone
//
//  Created by user on 14-3-14.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import "UIImageView+EduUtils.h"

#define DEFAULT_COURSE_IMAGE @"pic_default2"

@implementation UIImageView (EduUtils)

//- (void)setUserImageName:(NSString *)imageName
//{
//    [self setImageName:imageName
//  placeholderImageName:DEFAULT_USER_IMAGE
//              original:NO
//               success:nil];
//}
//
//- (void)setUserImageName:(NSString *)imageName
//                 success:(EduAsyncImageSuccessBlock_t)success
//{
//    [self setImageName:imageName
//  placeholderImageName:DEFAULT_USER_IMAGE
//              original:NO
//               success:success];
//}

- (void)setCourseImageName:(NSString *)imageName
{
    [self setImageName:imageName
  placeholderImageName:DEFAULT_COURSE_IMAGE
              original:NO
               success:nil];
}

- (void)setCourseImageName:(NSString *)imageName
                   success:(EduAsyncImageSuccessBlock_t)success
{
    [self setImageName:imageName
  placeholderImageName:DEFAULT_COURSE_IMAGE
              original:NO
               success:success];
}

- (void)setCourseImageName:(NSString *)imageName
                  animated:(BOOL)animated
                   success:(EduAsyncImageSuccessBlock_t)success
{
    [self setImageName:imageName
  placeholderImageName:DEFAULT_COURSE_IMAGE
              original:NO
              animated:animated
               success:success];
}

- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
            original:(BOOL)original
             success:(EduAsyncImageSuccessBlock_t)success
{
    [self setImageName:imageName
  placeholderImageName:placeholderImageName
              original:original
              animated:YES
               success:success];
}

- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
            original:(BOOL)original
            animated:(BOOL)animated
             success:(EduAsyncImageSuccessBlock_t)success
{
    [self setImageName:imageName
  placeholderImageName:placeholderImageName
              original:original
                  size:CGSizeZero
              animated:animated
               success:success];
}


- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
                size:(CGSize)size
            animated:(BOOL)animated
             success:(EduAsyncImageSuccessBlock_t)success
{
    [self setImageName:imageName
  placeholderImageName:placeholderImageName
              original:NO
                  size:size
              animated:animated
               success:success];
}

- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
            original:(BOOL)original
                size:(CGSize)size
            animated:(BOOL)animated
             success:(EduAsyncImageSuccessBlock_t)success
{
    [self setImageName:imageName
  placeholderImageName:placeholderImageName
              original:original
                  size:size
           autoReplace:YES
              animated:animated
               success:success];
}

- (void)setImageName:(NSString *)imageName
placeholderImageName:(NSString *)placeholderImageName
            original:(BOOL)original
                size:(CGSize)size
         autoReplace:(BOOL)autoReplace
            animated:(BOOL)animated
             success:(EduAsyncImageSuccessBlock_t)success
{
    [self setImageName:imageName
  placeholderImageName:placeholderImageName
              original:original
                  size:size
           autoReplace:autoReplace
                option:SDWebImageRetryFailed
              animated:animated
               success:success];
     
}

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
             success:(EduAsyncImageSuccessBlock_t)success
{
    UIImage *placeHolderImage = nil;
    if ([NSString isNilOrEmptyForString:placeholderImageName]) {
        placeHolderImage = nil;
    }
    else {
        placeHolderImage = [UIImage imageNamed:placeholderImageName];
    }

    if ([NSString isNilOrEmptyForString:imageName]) {
        if (placeHolderImage) {
            self.image = placeHolderImage;
        }
        return;
    }
    
    NSString* imageNewName = nil;
    //add by tujinguo ,gif动图的话，只直接显示原图
    if ([imageName.pathExtension isEqualToString:@"gif"]) {
        original=YES;
    }
    /*
    if (original) {
        imageNewName = imageName;
    }
    else {
        NSInteger scale = 1;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale >= 2.0)) {
            scale = [UIScreen mainScreen].scale;
        }
        
//        NSRange range = [imageName rangeOfString:@"http://imgsize.ph.126.net/?enlarge=true&imgurl="];
        NSRange range = [imageName rangeOfString:[NSString stringWithFormat:@"%@%@/thumbnail/", PROTOCOL_HTTP,COURSERA_ZONE_HOST]];
        if (range.location != NSNotFound) {
            NSString *tmp = [imageName substringFromIndex:range.length];
            NSString *pattern = @"_\\d+x\\d+x\\d+x\\d+.jpg$";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            range = [regex rangeOfFirstMatchInString:tmp
                                             options:0
                                               range:NSMakeRange(0, tmp.length)];
            if (range.location != NSNotFound) {
                imageName = [tmp substringToIndex:range.location];
            }
        }
        
        if (CGSizeEqualToSize(size, CGSizeZero)) {
//            imageNewName = [NSString stringWithFormat:@"http://imgsize.ph.126.net/?enlarge=true&imgurl=%@_%ldx%ldx1x85.jpg",
//                            imageName, (NSInteger)self.frame.size.width * scale, (NSInteger)self.frame.size.height * scale];
            if (self.frame.size.width==0||self.frame.size.height==0) {//用autolayout有可能初始化的size  是(0,0)
                imageNewName=imageName;
            }else{
                imageNewName =[NSString stringWithFormat:@"%@%@/thumbnail/?url=%@&w=%ld&h=%ld&f=0&q=85", PROTOCOL_HTTP,COURSERA_ZONE_HOST,imageName,(NSInteger)self.frame.size.width * scale, (NSInteger)self.frame.size.height * scale];
            }
        }
        else {
//            imageNewName = [NSString stringWithFormat:@"http://imgsize.ph.126.net/?enlarge=true&imgurl=%@_%ldx%ldx1x85.jpg",
//                            imageName, (NSInteger)size.width * scale, (NSInteger)size.height * scale];
               imageNewName =[NSString stringWithFormat:@"%@%@/thumbnail/?url=%@&w=%ld&h=%ld&f=0&q=85", PROTOCOL_HTTP,COURSERA_ZONE_HOST,imageName,(NSInteger)size.width * scale, (NSInteger)size.height * scale];
        }
    }
    */
    imageNewName=imageName;
   
    [self sd_setImageWithURL:[NSURL URLWithString:imageNewName]
            placeholderImage:placeHolderImage
                     options:option
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
         if (image) {
             UIImage * toImage = image;
             if (autoReplace) {
                 if (!animated) {
                     self.image = toImage;
                     if (success) {
                         success(toImage);
                     }
                 }
                 else {
                     [UIView transitionWithView:self
                                       duration:0.25
                                        options:UIViewAnimationOptionTransitionCrossDissolve
                                     animations:^
                      {
                          self.image = toImage;
                      } completion:^ (BOOL finished) {
                          if (success) {
                              success(toImage);
                          }
                      }];
                 }
             }
             else {
                 if (success) {
                     success(toImage);
                 }
             }
         }
     }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark deprecated only for compatible
- (void)setImageWithURL:(NSString *)url imageSize:(CGSize)size {
    [self setCourseImageName:url];
}
@end


















