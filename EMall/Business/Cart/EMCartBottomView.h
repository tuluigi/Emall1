//
//  EMCartBottomView.h
//  EMall
//
//  Created by Luigi on 16/7/19.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EMCartBottomViewDelegate <NSObject>
//选中
- (void)cartBottomViewDidSelectAllButtonSelected:(BOOL)selected;
//购物车结算
- (void)cartBottomViewSettlementShopCart;

@end

@interface EMCartBottomView : UIView
@property (nonatomic,weak)id <EMCartBottomViewDelegate> delegate;
- (void)updateCartBottomWithSelectItemCount:(NSInteger)count totalItems:(NSInteger)totalItems totalPrice:(CGFloat)totalPrice;
@end
