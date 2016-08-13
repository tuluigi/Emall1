//
//  OCBaseViewController.h
//  OpenCourse
//
//  Created by Luigi on 15/11/23.
//
//

#import <UIKit/UIKit.h>

@interface OCBaseViewController : UIViewController
/**
 *  分页的页码，default = @""
 */
@property (nonatomic, assign) __block NSInteger cursor;       //记录新加载数据的个数以及在数组中的位置
@end
