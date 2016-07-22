//
//  EMCartListCell.h
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMShopCartModel;

@protocol EMCartListCellDelegate <NSObject>
//选择状态改变
- (void)cartListCellDidSelectStateChanged:(EMShopCartModel *)shopCartModel;
//购买熟练改变
- (void)cartListCellDidBuyCountChanged:(EMShopCartModel *)shopCartModel;
@end
@interface EMCartListCell : UITableViewCell
@property (nonatomic,strong)EMShopCartModel *shopCartModel;
@property (nonatomic,weak)id <EMCartListCellDelegate> delegate;
@end
