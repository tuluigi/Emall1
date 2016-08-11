//
//  EMHomeGoodsCell.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMHomeGoodsModel;
@interface EMHomeGoodsCell : UICollectionViewCell


- (void)setGoodsModel:(EMHomeGoodsModel *)goodsModel dataSource:(NSArray *)dataSource;
@end
