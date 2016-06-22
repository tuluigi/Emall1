//
//  UIViewController+OpenCourse.h
//  OpenCourse
//
//  Created by Luigi on 15/9/12.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (OpenCourse)


/**
 *  add net work operation uniqueIdenfier
 *
 *  @param uniqueIdentifer
 */
- (void)addSessionTask:(NSURLSessionTask *)task;
/**
 *  取消当前页面中尚未完成的网络请求
 */
- (void)cancelSessionTasks;
- (NSMutableArray *)sessionTaskArray;



@end
