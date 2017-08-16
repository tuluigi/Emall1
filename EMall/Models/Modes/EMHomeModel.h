//
//  EMHomeModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"
@class EMGoodsModel;
@class EMCatModel;
@interface EMHomeGoodsModel : OCBaseModel
@property(nonatomic,assign)NSInteger goodsID;
@property(nonatomic,copy)NSString *goodsName;

@property(nonatomic,copy)NSString *goodsImageUrl;//商品主图
@property(nonatomic,assign)NSInteger saleCount;//销售数量
@property(nonatomic,assign)CGFloat goodsPrice;
@end


@interface EMHomeCatModel : OCBaseModel
@property (nonatomic,assign)NSInteger catID;
@property (nonatomic,assign)NSInteger pid;//父类别ID
@property (nonatomic,copy)NSString *catName;
@property (nonatomic,copy)NSString *catImageUrl;
@end

@interface EMHomeModel : OCBaseModel
@property (nonatomic,strong)NSMutableArray <EMCatModel *>*catArray;
@property (nonatomic, copy) NSString *signageImgUrl;//门店图片
@property (nonatomic, copy) NSString *announcementImgUrl;//公告声明
@end
