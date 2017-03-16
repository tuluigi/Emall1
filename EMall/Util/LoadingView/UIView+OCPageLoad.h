//
//  UIView+OCPageLoad.h
//  OpenCourse
//
//  Created by Luigi on 15/8/31.
//
//

#import <UIKit/UIKit.h>
#import "OCPageLoadViewHeader.h"
#import "OCResponseResult.h"
@interface UIView (OCPageLoad)
/**
 *  显示默认的加载动画页面
 */
-(void)showPageLoadingView;

/**
 *  显示加载动画页面
 *
 *  @param frame 相对俯视图的frame
 */
- (void)showPageLoadingView:(CGRect)frame;

- (void)showPageLoadCustomeView:(UIView *)loadView;
- (void)showPageLoadView:(UIView *)customeView frame:(CGRect)frame delegate:(id)delegate;
/**
 *  带有提示的页面, 默认是没有网络图片，
 *
 *  @param message  提示内容
 *  @param delegate delegate
 */
- (void)showPageLoadedMessage:(NSString *)message delegate:(id)delegate;
- (void)showPageLoadedMessage:(NSString *)message failureCode:(OCCodeState)codeState delegate:(id)delegate;


- (void)showPageLoadedMessage:(NSString *)message frame:(CGRect)frame delegate:(id)delegate;

- (void)showPageLoadedMessage:(NSString *)message image:(UIImage *)image delegate:(id)delegate;
/**
 *  带有提示页面
 *
 *  @param message  提示信息
 *  @param frame    loadView相对于俯视图的frame；如果充满俯视图则可以穿CGRectZero
 *  @param image    提示图
 *  @param delegate delegate
 */
- (void)showPageLoadedMessage:(NSString *)message frame:(CGRect)frame image:(UIImage *)image delegate:(id)delegate;

/**
 *  数据跑丢了
 *
 *  @param delegate 
 */
- (void)showPageNilDataDelegate:(id)delegate;
/**
 *  分类筛选 空白页
 *
 *  @param delegate 
 */
- (void)showFilterPageNilDataDelegate:(id)delegate;
/**
 *  隐藏delegate
 */
-(void)dismissPageLoadView;
/**
 *  当前view上的pageLoadView
 *
 *  @return 
 */
-(OCPageLoadView *)currentPageLoadView;

#pragma mark - 文本提示
/**
 *  hud隐藏之后block
 *
 *  @param message
 *  @param completionBlock
 */
-(MBProgressHUD *)showHUDProgress:(CGFloat)progress message:(NSString *)message;
-(void)showHUDMessage:(NSString *)message completionBlock:(void (^)())completionBlock;
-(void)showHUDMessage:(NSString *)message;
-(void)showHUDMessage:(NSString *)message yOffset:(CGFloat)yOffset;
-(void)showHUDLoading;
-(void)showHUDLoadingWithMessage:(NSString *)message;
-(void)dismissHUDLoading;
-(void)dismissHUDLoadingAnimated:(CGFloat)animated;
@end
