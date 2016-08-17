//
//  EMOrderListCell.h
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMOrderModel;
@class EMOrderListCell;
@protocol EMOrderListCellDelegate <NSObject>
//重新购买
- (void)orderListCellShouldReBuyThisGoods;
//查看订单详情
- (void)orderListCellShouldCheckOrderDetail;

- (void)updateOrderState:(EMOrderModel *)orderModel state:(NSInteger)state;
@end

@interface EMOrderListCell : UITableViewCell
@property (nonatomic,strong) EMOrderModel *orderModel;
@property (nonatomic,weak) id <EMOrderListCellDelegate> delegate;
@end
