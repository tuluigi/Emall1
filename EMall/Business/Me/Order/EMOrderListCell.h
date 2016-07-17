//
//  EMOrderListCell.h
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMOrderModel;
@interface EMOrderListCell : UITableViewCell
@property (nonatomic,strong) EMOrderModel *orderModel;
@end
