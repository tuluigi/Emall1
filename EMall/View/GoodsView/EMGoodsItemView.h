//
//  EMGoodsItemView.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  EMGoodsModel;
@interface EMGoodsItemView : UIView
@property (nonatomic,strong)EMGoodsModel *goodsModel;
+ (CGSize)goodsItemViewSize;
@end
