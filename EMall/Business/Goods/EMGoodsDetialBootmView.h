//
//  EMGoodsDetialBootmView.h
//  EMall
//
//  Created by Luigi on 16/7/26.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EMGoodsDetialBootmViewDelegate <NSObject>
@optional
//购物车
- (void)goodsDetialBootmViewSubmitButtonPressed;

@end
@interface EMGoodsDetialBootmView : UIView
@property (nonatomic,weak)id <EMGoodsDetialBootmViewDelegate> delegate;
@end
