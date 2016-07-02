//
//  UIImage+OCFixIssue.h
//  OpenCourse
//
//  Created by 姜苏珈 on 16/5/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (OCFixIssue)
- (UIImage *)fixOrientation:(UIImage *)aImage;
- (UIImage *)fixOrientation;

//图片大小 - 单位是KB
- (CGFloat)sizeKBOfImage;

//图片大小 - 单位是MB
- (CGFloat)sizeMBOfImage;

//压缩图片大小 -- topSize:图片大小 unit:单位 KB MB ..
- (NSData *)fixImageUploadSize:(CGFloat)topSize unit:(NSString *)unit;

//直接裁剪
- (NSData *)dataByComperssionImage;
@end
