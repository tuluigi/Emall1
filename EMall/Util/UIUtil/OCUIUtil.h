//
//  OCUIUtil.h
//  OpenCourse
//
//  Created by Luigi on 15/11/30.
//
//

#import <Foundation/Foundation.h>

/**
 *  UI 按比例缩放尺寸
 *
 *  @param a 值
 *
 *  @return 缩放后的值
 */
#define OCUISCALE(a) ([OCUIUtil uiScale:a])

/**
 *  按比例缩放字体
 *
 *  @param a 缩放前字体大小
 *
 *  @return 缩放后字体大小
 */
#define OCUIScaleFontSize(a) ([OCUIUtil scaleFontSize:a])


//适配iPhone 顶部的刘海高度的宏
#define EM_IPhoneXTopAdapt(padding) ([OCUIUtil iPhoneXTopAdapter:padding])
//适配iPhoneX 底部HomeIndicator高度
#define EM_IPhoneXBottomAdapt(padding) ([OCUIUtil iPhoneXBottomAdapter:padding])

@interface OCUIUtil : NSObject
/**
 *  适配各个大小屏幕后的字体大小
 *
 *  @param fontSize 目前iPhone是按照iphone6<750> 的字体大小； iPad 暂时没有适配
 *
 *  @return 适配后的字体大小
 */
+ (CGFloat)scaleFontSize:(CGFloat)fontSize;

/**
 *  UI 缩放比例
 *  该比例是按照iphone6 的尺寸为基准;iPad 暂时没有适配
 *
 *  @return 缩放比例
 */
+ (CGFloat)uiScale:(CGFloat)width;

/**
 *  根据标注图字间距计算出实际的字间距
 *  必须得用long 类型
 *  @param fontSize  字体大小
 *  @param fontRatio 字体比率
 *
 *  @return 实际的字间距
 */
+ (long)kerningWithFontSize:(CGFloat)fontSize fontRatio:(CGFloat)fontRatio;



#pragma mark - iPhoneX 相关
/**
 是否是IPHONX的UI
 
 @return
 */
+ (BOOL)isIPhoneX;

/**
 对iPhoneX 的UI进行适配
 
 @param topPadding
 @return
 */
+ (CGFloat)iPhoneXTopAdapter:(CGFloat)topPadding;

/**
 对iPhoneX 的UI进行适配
 
 @param bottomPadding
 @return
 */
+ (CGFloat)iPhoneXBottomAdapter:(CGFloat)bottomPadding;

@end

