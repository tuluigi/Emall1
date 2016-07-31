//
//  EMGoodsModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsModel.h"


@implementation EMGoodsObjectItemModel



@end

@implementation EMGoodsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"goodsID":@"id",
             @"goodsName":@"name",
             @"goodsPrice":@"price",
             @"saleCount":@"sales",
             @"goodsImageUrl":@"image",};
}
@end
