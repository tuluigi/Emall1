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
             @"signageImgUrl":@"signageImg",
             @"announcementImgUrl":@"announcementImg"};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"catArray"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSMutableArray *sessions=[[NSMutableArray alloc]  init];
            for (id item in value) {
                NSError *aError;
                EMCatModel *catModel=[MTLJSONAdapter modelOfClass:[EMCatModel class] fromJSONDictionary:item error:&aError];
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
                    EMHomeGoodsModel *goodModel=[MTLJSONAdapter modelOfClass:[EMGoodsModel class] fromJSONDictionary:item error:&aError];
                    if (goodModel&&nil==aError) {
                        [sessions addObject:goodModel];
                    }
                }
                return sessions;
            }];
    }else if ([key isEqualToString:@"signageImgUrl"]||[key isEqualToString:@"announcementImgUrl"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                return [(NSDictionary *)value objectForKey:@"image"];
            }else if ([value isKindOfClass:[NSString class]]){
                NSDictionary *reslut =[NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:4] options:NSJSONReadingMutableContainers error:nil];
                if (reslut && [reslut isKindOfClass:[NSDictionary class]]) {
                    return  [(NSDictionary *)reslut objectForKey:@"image"];
                }else{
                    return nil;
                }
            }else{
                return nil;
            }
        }];
    }
    else{
        return nil;
    }
}
@end
