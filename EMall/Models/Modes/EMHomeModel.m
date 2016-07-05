//
//  EMHomeModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeModel.h"
@class EMCatModel;
@class EMGoodsModel;
#import "EMCatModel.h"
#import "EMGoodsModel.h"
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
                    EMGoodsModel *goodModel=[MTLJSONAdapter modelOfClass:[EMGoodsModel class] fromJSONDictionary:item error:&aError];
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
