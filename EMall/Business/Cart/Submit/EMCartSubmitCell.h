//
//  EMCartSubmitCell.h
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMShopCartModel;
@class EMOrderGoodsModel;
@interface EMCartSubmitCell : UITableViewCell
/**
 *  购物车，提交订单部分用
 */
@property (nonatomic,strong)EMShopCartModel *shopCartModel;

/**
 *  订单部分用的
 */
@property(nonatomic,strong)EMOrderGoodsModel *orderGoodsModel;
@end
