//
//  EMHomeModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMHomeGoodsModel : OCBaseModel
@property(nonatomic,assign)NSInteger goodsID;
@property(nonatomic,copy)NSString *goodsName;

@property(nonatomic,copy)NSString *goodsImageUrl;//商品主图
@property(nonatomic,assign)NSInteger saleCount;//销售数量
@property(nonatomic,assign)CGFloat goodsPrice;
@end

@interface EMHomeModel : OCBaseModel
@property (nonatomic,strong)NSMutableArray *catArray;

@property (nonatomic,strong)NSMutableArray <EMHomeGoodsModel *>*greatGoodsArray;//精品商品的数组
@property (nonatomic,strong)NSMutableArray <EMHomeGoodsModel *>*hotGoodsArray;//热销商品数组
@end
