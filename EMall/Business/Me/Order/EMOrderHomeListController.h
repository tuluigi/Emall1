//
//  EMOrderHomeListController.h
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"
#import "EMOrderModel.h"
@interface EMOrderHomeListController : OCBaseTableViewController

- (instancetype)initWithOrderState:(EMOrderState)orderState;
@end
