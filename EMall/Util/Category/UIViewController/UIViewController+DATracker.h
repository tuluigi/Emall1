//
//  UIViewController+DATracker.h
//  OpenCourse
//
//  Created by Luigi on 16/3/30.
//
//

#import <UIKit/UIKit.h>
/**
 *  DA页面停留时长统计
 */
@interface UIViewController (DATracker)
/**
 *  页面停留时长统计，需要页面统计的地方，实现该方法就可以
 *
 *  @param isBackground 主要是为了去除App进入后台的时间。如果在ViewWillApear viewWillDisapear 中直接传NO 就行。
 *  @param isBegin      是否是开始统计，YES -- 开始统计 ； NO 结束统计
 */
- (void)trackPageUseDurationInBackgroundModel:(BOOL)isBackground isBegining:(BOOL)isBegin;
@end
