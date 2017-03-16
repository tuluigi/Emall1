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
#import "PayPalMobile.h"

#pragma mark --Util
#import "OCUIUtil.h"
#import "RunInfo.h"
#import "EMCache.h"
#import "EMCommonInfo.h"

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
#import "UIImage+OCColorImage.h"
#import "UIScrollView+OCRefresh.h"
#import "UIResponder+Router.h"
#import "NSString+RemoveEmoji.h"

#import "UIViewController+OpenCourse.h"
#import "UIViewController+Login.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIView+OCPageLoad.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "UICollectionViewLeftAlignedLayout.h"


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

static NSString * const kEMShopCartCountChangedNotification = @"EMShopCartCountChangedNotification";//购物车数量变化
static NSString * const kEMShopCartShouldUpdateNotification= @"kEMShopCartShouldUpdateNotification";//添加购物车，提交订单之后，购物车数量变化
#define  EMGoodsMaxBuyCount     50 //每件商品最大购买数量

static CGFloat const kEMOffX    = 13;
//整个app中默认的浅色字体颜色
#define kEM_GrayDarkTextColor [UIColor colorWithHexString:@"#272727"]
//整个app中默认深色字体颜色
#define kEM_LightDarkTextColor [UIColor colorWithHexString:@"#5d5c5c"]
#endif /* EMallHeader_h */

#define  kEM_RedColro       (RGB(229, 26, 30))



#pragma mark - ResponderEvent
#define kEMOrderShoudBuyAgainEvent      @"kEMOrderShoudBuyAgainEvent"
#define kEMOrderGotoOrderDetailEvent  @"kEMOrderGotoOrderDetailEvent"
#define kEMOrderDetailGoodsCommentEvent  @"kEMOrderDetailGoodsCommentEvent"
