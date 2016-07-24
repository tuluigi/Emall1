//
//  EMCartBottomView.h
//  EMall
//
//  Created by Luigi on 16/7/19.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMCartBottomView;
@protocol EMCartBottomViewDelegate <NSObject>
@optional
//选中
- (void)cartBottomViewDidSelectAllButtonSelected:(BOOL)selected;
//购物车结算
- (void)cartBottomViewSubmitButtonPressed:(EMCartBottomView *)bottomView;

@end

@interface EMCartBottomView : UIView
@property (nonatomic,weak)id <EMCartBottomViewDelegate> delegate;
@property (nonatomic,assign)BOOL isDelete;//是否是删除
@property (nonatomic,assign,readonly)BOOL disableSelect;
/**
 *  创建CartBootomView
 *
 *  @param enableSelect 是否支持选择
 *
 *  @return
 */
+ (EMCartBottomView *)bottomCartViewDisableSelelct:(BOOL)enableSelect;

- (void)updateCartBottomWithSelectItemCount:(NSInteger)count totalItems:(NSInteger)totalItems totalPrice:(CGFloat)totalPrice;
@end
