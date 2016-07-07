//
//  EMHomeGoodsCell.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMGoodsModel;
@interface EMHomeGoodsCell : UICollectionViewCell


- (void)setGoodsModel:(EMGoodsModel *)goodsModel dataSource:(NSArray *)dataSource;
@end
