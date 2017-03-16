//
//  UIFont+OCUIUtil.h
//  OpenCourse
//
//  Created by Luigi on 15/11/30.
//
//

#import <UIKit/UIKit.h>
/**
 *  字体管理类，根据屏幕大小等比例缩放
 */
@interface UIFont (OCUIUtil)
// 暂时只用一下两种字体
//正常普通字体
+ (nullable UIFont *)oc_systemFontOfSize:(CGFloat)fontSize;
//正常粗体
+ (nullable UIFont *)oc_systemLightFontOfSize:(CGFloat)fontSize;

//字号不会根据屏幕尺寸变化而变化
+ (nullable UIFont *)oc_constantFontOfSize:(CGFloat)fontSize;


+ (nullable UIFont *)oc_boldSystemFontOfSize:(CGFloat)fontSize;
+ (nullable UIFont *)oc_italicSystemFontOfSize:(CGFloat)fontSize;



+ (nullable UIFont *)oc_monospacedDigitSystemFontOfSize:(CGFloat)fontSize weight:(CGFloat)weight NS_AVAILABLE_IOS(9_0);

@end
