//
//  EMCitySelectViewController.h
//  EMall
//
//  Created by Luigi on 16/8/12.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"
@class EMAreaModel;
@protocol EMCitySelectViewControllerDelegate <NSObject>

- (void)didFinishSelectWithAreaInfoArray:(NSArray <EMAreaModel *>*)aresInoArray;

@end

@interface EMCitySelectViewController : OCBaseViewController
@property (nonatomic,weak)id <EMCitySelectViewControllerDelegate >delegate;
@end
