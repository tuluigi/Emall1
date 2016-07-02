//
//  UIViewController+OCImagePickerAuthorization.h
//  OpenCourse
//
//  Created by 姜苏珈 on 16/6/21.
//
//

#import <UIKit/UIKit.h>

//相机访问权限
typedef NS_OPTIONS(NSInteger, OCNImageAuthorizationType) {
    OCNImageAuthorizationTypeLibrary, //相册
    OCNImageAuthorizationTypeTakePhoto,//照相机
    OCNImageAuthorizationTypeSaveImage//保存图片
};
@interface UIViewController (OCImagePickerAuthorization)
- (BOOL)tellImagePickerAuthorization:(OCNImageAuthorizationType)type;
@end
