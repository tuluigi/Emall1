//
//  UIScrollView+OCRefresh.h
//  OpenCourse
//
//  Created by Luigi on 15/9/11.
//
//

#import <UIKit/UIKit.h>




typedef void(^OpenCourseRefreshBlock)(void);
@interface UIScrollView (OCRefresh)<UIScrollViewDelegate>

#pragma mark - 下拉刷新
/**
 *  添加下拉刷新
 *
 *  @param url    图片地址
 *  @param handle
 */
- (void)addOCPullDownResreshWithImageUrl:(NSString *)url onHandler:(OpenCourseRefreshBlock)handle;
/**
 *  顶部下拉刷新View
 *
 *  @return
 */
- (UIView *)refreshHeadView;
/**
 *  设置下拉刷新背景图片地址
 *
 *  @param url
 */
- (void)setPullDownResfreshBackgroudImageUrl:(NSString *)url;
/**
 *  添加下拉刷新
 *
 *  @param handle
 */
- (void)addOCPullDownResreshHandler:(OpenCourseRefreshBlock)handle;
/**
 *  开始下拉刷新(会将正在加载更多的动画停掉)
 */
- (void)startPullDownRefresh;

/**
 *  停止下拉动画
 *  同时会将加载更多动画停掉
 */
- (void)stopPullDownRefresh;


#pragma  mark - 上拉加载更多
/**
 *  添加加载更多
 *
 *  @param handle
 */
- (void)addOCPullInfiniteScrollingHandler:(OpenCourseRefreshBlock)handle;
/**
 *  开始加载更多动画(同时会将下拉刷新动画停掉)
 */
- (void)startInfiniteScrolling;
/**
 *  停止加载更多动画
 *  同时会将下拉刷新动画停掉
 */
- (void)stopInfiniteScrolling;
/**
 *  是否显示加载更多View
 *
 *  @param enable
 */
- (void)enableInfiniteScrolling:(BOOL)enable;
/**
 *  停止动画，切换到点击重试状态
 *
 *  @param msg 点击重试信息，msg=nil/@"" 则用默认的信息
 *  @param enableRetry 是否允许点击重试
 */
- (void)endRefreshingWithMessage:(NSString *)msg eanbleRetry:(BOOL)enableRetry;
/**
 *  暂无更多数据 下拉展出
 *
 */
- (void)endRefreshingWithNoData;
/**
 *  底部加载更多View
 *
 *  @return 
 */
- (UIView *)infiniteFootView;

#pragma mrak -停止下拉上拉动画
/**
 *  停止下拉和上拉动画<暂时没用>
 */
-(void)stopRefreshAndInfiniteScrolling;
@end
