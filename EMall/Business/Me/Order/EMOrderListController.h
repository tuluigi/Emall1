//
//  EMOrderListController.h
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "EMOrderModel.h"
@interface EMOrderListController : OCBaseTableViewController <ZJScrollPageViewChildVcDelegate>
@property (nonatomic,assign)EMOrderState orderState;
@end
