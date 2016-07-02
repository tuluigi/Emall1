//
//  UIViewController+OCImagePickerAuthorization.m
//  OpenCourse
//
//  Created by 姜苏珈 on 16/6/21.
//
//

#import "UIViewController+OCImagePickerAuthorization.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>

static const NSInteger kOCNImagePickerAuthorizationTag = 4321;
@implementation UIViewController (OCImagePickerAuthorization)
- (BOOL)tellImagePickerAuthorization:(OCNImageAuthorizationType)type {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    switch (author) {
        case ALAuthorizationStatusNotDetermined:{
            if (type == OCNImageAuthorizationTypeLibrary) {
                NSString *tips = @"获取照片失败，请重新授权";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = kOCNImagePickerAuthorizationTag;
                [alert show];
                return NO;

            }
            break;
        }
            
        case ALAuthorizationStatusRestricted:{
            if (type == OCNImageAuthorizationTypeTakePhoto) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机。",appName];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
           
            break;
        }
            
        case ALAuthorizationStatusDenied:{
            if (type == OCNImageAuthorizationTypeSaveImage) {
                NSString *tips = @"需要保存图片到相册\n请授权本App可以访问相册\n设置方式:手机设置->隐私->照片\n允许本App访问相册";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片保存失败！" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
                [alert show];
                return NO;

            }
            
            break;
        }
            
        case ALAuthorizationStatusAuthorized:
            break;
            
        default:
            break;
    }
    return YES;
    
}

- (BOOL)imagePickerAuthorization {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    switch (author) {
        case ALAuthorizationStatusNotDetermined:{
            NSString *tips = @"获取照片失败，请重新授权";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = kOCNImagePickerAuthorizationTag;
            [alert show];
            return NO;
            break;
        }
            
        case ALAuthorizationStatusRestricted:{
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机。",appName];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return NO;
            break;
        }
            
        case ALAuthorizationStatusDenied:{
            NSString *tips = @"需要保存图片到相册\n请授权本App可以访问相册\n设置方式:手机设置->隐私->照片\n允许本App访问相册";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片保存失败！" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
            [alert show];
            return NO;
            break;
        }
            
        case ALAuthorizationStatusAuthorized:
            break;
            
        default:
            break;
    }
    return YES;
}
@end
