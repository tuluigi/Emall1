//
//  EMGoodsSpecMaskView.h
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^EMGoodsSpecMaskViewDismissBlock)(BOOL addCart ,NSInteger goodsID,NSInteger buyCount,NSInteger sepecID);
@interface EMGoodsSpecMaskView : UIView
+ (EMGoodsSpecMaskView *)goodsSpecMaskViewWithGoodsInfo:(id)goodsInfo onDismsiBlock:(EMGoodsSpecMaskViewDismissBlock)dismisBlock;
@end
