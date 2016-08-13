//
//  EMGoodsSpecMaskView.h
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMGoodsSpecMaskView;
@class EMGoodsSpecView;
@class EMGoodsDetailModel;
typedef void(^EMGoodsSpecMaskViewDismissBlock)(EMGoodsSpecMaskView *aMskView, NSInteger info ,NSInteger buyCount);
@interface EMGoodsSpecMaskView : UIView
+ (EMGoodsSpecMaskView *)goodsMaskViewWithGoodsDetailModel:(EMGoodsDetailModel *)detailModel onDismissBlock:(EMGoodsSpecMaskViewDismissBlock)dismissBlock;

- (void)presemtSpecView;
- (void)dismissSpecView;
- (void)finishedDismiss;
@end
