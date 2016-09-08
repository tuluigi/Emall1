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
             @"specListArray":@"spec",};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"specListArray"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSArray *array;
            if ([value isKindOfClass:[NSArray class]]) {
                array = [MTLJSONAdapter modelsOfClass:[EMSpecListModel class] fromJSONArray:value error:error];
            }
            return array;
        }];
    }else{
        return nil;
    }
}
- (NSString *)spec{
    if ([NSString isNilOrEmptyForString:_spec]) {
        _spec=@"";
        for (EMSpecListModel *listModel in self.specListArray) {
            for (EMSpecModel *model in listModel.specsArray) {
                _spec=[_spec stringByAppendingString:model.name];
            }
        }
        
        _spec=[_spec stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return _spec;
}
@end
