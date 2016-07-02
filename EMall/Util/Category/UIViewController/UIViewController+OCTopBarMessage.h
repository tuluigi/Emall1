//
//  UIViewController+OCTopBarMessage.h
//  OpenCourse
//
//  Created by 姜苏珈 on 15/12/4.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (OCTopBarMessage)
/**
 *  弹出框
 *
 *  @param message
 *  @param delay
 *  @param tapHandler 
 */
- (void)showTopMessage:(NSString *)message dismissDelay:(CGFloat)delay withTapBlock:(dispatch_block_t)tapHandler;


- (void)showTopMessage:(NSString *)message dismissDelay:(CGFloat)delay  startOffset:(NSInteger)startOffset upView:(UIView *)upView withTapBlock:(dispatch_block_t)tapHandler;

- (void)showTopMessage:(NSString *)message dismissDelay:(CGFloat)delay  startOffset:(NSInteger)startOffset withTapBlock:(dispatch_block_t)tapHandler;

- (void)showRefreshMessage:(NSString *)message dismissDelay:(CGFloat)delay withTapBlock:(dispatch_block_t)tapHandler;
@end
