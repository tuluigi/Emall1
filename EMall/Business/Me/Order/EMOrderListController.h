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

@class EMOrderModel;
@protocol EMOrderListControllerDelegate <NSObject>

- (void)orderListControllerDidSelecOrder:(EMOrderModel *)orderModel;

@end

@interface EMOrderListController : OCBaseTableViewController <ZJScrollPageViewChildVcDelegate>
@property (nonatomic,assign)EMOrderState orderState;
@property (nonatomic,copy)NSString *goodsName;//搜索用
@property (nonatomic,weak)id<EMOrderListControllerDelegate>delegate;


- (void)setOrderState:(EMOrderState )orderState goodsName:(NSString *)goodsName;
- (void)reloadDataWithOrderState:(EMOrderState )orderState goodsName:(NSString *)goodsName;
@end
