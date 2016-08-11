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
typedef void(^EMGoodsSpecMaskViewDismissBlock)(EMGoodsSpecMaskView *aSpecMaskView);
@interface EMGoodsSpecMaskView : UIView
+ (EMGoodsSpecMaskView *)goodsMaskViewOnDismissBlock:(EMGoodsSpecMaskViewDismissBlock)dismissBlock;

- (void)presemtSpecView;
- (void)dismissSpecView;
- (void)finishedDismiss;
@end
