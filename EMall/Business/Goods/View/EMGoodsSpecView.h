//
//  EMGoodsSpecView.h
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMGoodsModel;
@class EMGoodsSpecView;
typedef void(^EMGoodsSpecViewDismissBlock)(EMGoodsSpecView *specView, BOOL addCart ,NSInteger goodsID,NSInteger buyCount,NSInteger sepecID);
@interface EMGoodsSpecView : UIView

+ (CGRect)specFrame;
+(EMGoodsSpecView *)specGoodsViewWithGoodInfo:(id)goodInfo onDismsiBlock:(EMGoodsSpecViewDismissBlock)dismisBlock;
@end
