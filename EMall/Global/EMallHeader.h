//
//  EMallHeader.h
//  EMall
//
//  Created by Luigi on 16/7/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#ifndef EMallHeader_h
#define EMallHeader_h

#pragma mark --three lib
#import "Masonry.h"
#import "Mantle.h"
#import "MBProgressHUD.h"
#import "CocoaLumberjack.h"
#import "CCSingleton.h"


#pragma mark --Util
#import "OCUIUtil.h"
#import "RunInfo.h"


#pragma mark --category
#import "UIFont+OCUIUtil.h"
#import "NSString+Addition.h"
#import "UIColor+ILHexStringColor.h"
#import "UIImageView+EduUtils.h"
#import "NSString+Utility.h"
#import "NSString+Encrypt.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "UIColor+ILHexStringColor.h"

#import "UIViewController+OpenCourse.h"
#import "UIViewController+Login.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIView+OCPageLoad.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#pragma mark --Maroc
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define OCWidth ([UIScreen mainScreen].bounds.size.width)
#define OCHeight ([UIScreen mainScreen].bounds.size.height)

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ColorHexString(a) [UIColor colorWithHexString:a]

#define EMDefaultImageName  @"loginheader"
#define EMDefaultImage  [UIImage imageNamed:EMDefaultImageName]

#ifndef stringNotNil
#define stringNotNil(str) ((str)==nil?@"":str)
#endif



#pragma mark - Notification
static NSString * const OCLogoutNofication = @"com.EMMall.logout.success";
static NSString * const OCLoginSuccessNofication = @"com.EMMall.login.success";

static CGFloat const kEMOffX    = 13;
#endif /* EMallHeader_h */
