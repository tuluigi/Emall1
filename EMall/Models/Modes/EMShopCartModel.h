//
//  EMShopCartModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"
@class EMSpecListModel;
@interface EMShopCartModel : OCBaseModel
@property(nonatomic,assign)NSInteger cartID;
@property(nonatomic,assign)NSInteger goodsID,gdid,userID;//分别是商品id和规格id
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *goodsImageUrl;

@property(nonatomic,assign)CGFloat goodsPrice,promotionPrice;//分别是原价和优惠金额和优惠后的价格
@property (nonatomic,assign)NSInteger goodsAmount;//库存数量
@property (nonatomic,assign)CGFloat postage;//运费
@property(nonatomic,assign)NSInteger buyCount;
@property (nonatomic,assign)CGFloat totalPrice;
@property (nonatomic,copy)NSString *spec;//尺寸
@property (nonatomic,strong)NSArray *specListArray;
@property (nonatomic,assign)BOOL unSelected;//default is no
@end
