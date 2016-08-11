//
//  EMHomeModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeModel.h"
@class EMCatModel;

#import "EMCatModel.h"
#import "EMGoodsModel.h"


@implementation EMHomeGoodsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"goodsID":@"id",
             @"goodsName":@"name",
             @"goodsImageUrl":@"image",
             @"goodsPrice":@"price",
             @"saleCount":@"sales",};
}

@end

@implementation EMHomeCatModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"catID":@"id",
             @"catName":@"name",
             @"catImageUrl":@"logo",};
}


@end

@implementation EMHomeModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"catArray":@"category",
             @"hotGoodsArray":@"hots",
             @"greatGoodsArray":@"prime",};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"catArray"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSMutableArray *sessions=[[NSMutableArray alloc]  init];
            for (id item in value) {
                NSError *aError;
                EMCatModel *catModel=[MTLJSONAdapter modelOfClass:[EMHomeCatModel class] fromJSONDictionary:item error:&aError];
                if (catModel&&nil==aError) {
                    [sessions addObject:catModel];
                }
            }
            return sessions;
        }];
        
    }else if ([key isEqualToString:@"hotGoodsArray"]||[key isEqualToString:@"greatGoodsArray"]){
            return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
                NSMutableArray *sessions=[[NSMutableArray alloc]  init];
                for (id item in value) {
                    NSError *aError;
                    EMHomeGoodsModel *goodModel=[MTLJSONAdapter modelOfClass:[EMHomeGoodsModel class] fromJSONDictionary:item error:&aError];
                    if (goodModel&&nil==aError) {
                        [sessions addObject:goodModel];
                    }
                }
                return sessions;
            }];
    }
    else{
        return nil;
    }
}
@end
