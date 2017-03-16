//
//  UIViewController+OpenCourse.m
//  OpenCourse
//
//  Created by Luigi on 15/9/12.
//
//

#import "UIViewController+OpenCourse.h"
#import "OCNetSessionManager.h"
#import <objc/runtime.h>

static NSString * const OCControllerTaskUniqueArrayKey = @"OCControllerTaskUniqueArrayKey";
@implementation UIViewController (OpenCourse)
- (void)addSessionTask:(NSURLSessionTask *)task{
    if (task) {
            [[self sessionTaskArray] addObject:@(task.taskIdentifier)];
    }
}
- (void)cancelSessionTasks{
    if ([[self sessionTaskArray] count]) {
        [[OCNetSessionManager sharedSessionManager] cancleSessionTasks:[self sessionTaskArray]];
    }
}
- (NSMutableArray *)sessionTaskArray{
   id array=objc_getAssociatedObject(self, &OCControllerTaskUniqueArrayKey);
    if (nil==array) {
        [self setsessionTaskArray:[[NSMutableArray alloc]  init]];
    }
    return array;
}
- (void)setsessionTaskArray:(NSMutableArray *)array{
    objc_setAssociatedObject(self, &OCControllerTaskUniqueArrayKey, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
