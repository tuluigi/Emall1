//
//  EMHomeModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMHomeModel : OCBaseModel
@property (nonatomic,strong)NSMutableArray *catArray;

@property (nonatomic,strong)NSMutableArray *greatGoodsArray;//精品商品的数组
@property (nonatomic,strong)NSMutableArray *hotGoodsArray;//热销商品数组
@end
