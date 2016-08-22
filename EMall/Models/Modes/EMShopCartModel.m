//
//  EMShopCartModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShopCartModel.h"
#import "EMGoodsModel.h"
@implementation EMShopCartModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"cartID":@"id",
             @"goodsID":@"gid",
             @"gdid":@"gdid",
             @"userID":@"mid",
             @"goodsName":@"name",
             @"goodsImageUrl":@"picture",
             @"goodsPrice":@"amount",
              @"promotionPrice":@"promotion_price",
             @"buyCount":@"quantity",
             @"postage":@"postage",
             @"goodsAmount":@"amount",
             @"specListModel":@"spec",};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"specListModel"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSArray *array;
            id reslut;
            if ([value isKindOfClass:[NSArray class]]) {
                array = [MTLJSONAdapter modelsOfClass:[EMSpecListModel class] fromJSONArray:value error:error];
            }
            if (array.count&&[array isKindOfClass:[NSArray class]]) {
                reslut=[array firstObject];
            }
            return reslut;
        }];
    }else{
        return nil;
    }
}
- (NSString *)spec{
    if ([NSString isNilOrEmptyForString:_spec]) {
        _spec=@"";
        for (EMSpecModel *model in self.specListModel.specsArray) {
            _spec=[_spec stringByAppendingString:model.name];
        }
        _spec=[_spec stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return _spec;
}
@end
