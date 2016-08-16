//
//  EMGoodsModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsModel.h"


@implementation EMSpecModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"pName":@"p_name",
             @"name":@"name",
             @"specID":@"id",
             @"infoID":@"gdid",
             };
}

@end
@implementation EMSpecListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"pName":@"spec_name",
             @"specsArray":@"detail",
             };
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"specsArray"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            id result;
            if ([value isKindOfClass:[NSArray class]]) {
                result = [MTLJSONAdapter modelsOfClass:[EMSpecModel class] fromJSONArray:value error:error];
            }
            return result;
        }];
    }else{
        return nil;
    }
}
@end
@implementation EMGoodsInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"goodsID":@"gid",
             @"infoID":@"id",
             @"promotePrice":@"promotion_price",
             @"amount":@"amount",
             @"specListArray":@"spec",
             };
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"specListArray"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            id result;
            if ([value isKindOfClass:[NSArray class]]) {
                result = [MTLJSONAdapter modelsOfClass:[EMSpecListModel class] fromJSONArray:value error:error];
            }
            return result;
        }];
    }else{
        return nil;
    }
}

@end


@interface EMGoodsModel ()
@property (nonatomic,copy)NSString *picture_01,*picture_02,*picture_03,*picture_04,*picture_05;
@property(nonatomic,strong,readwrite)NSMutableArray <NSString *>*goodsImageArray;
@end

@implementation EMGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"goodsID":@"id",
             @"goodsName":@"name",
             @"goodsImageUrl":@"picture",
             @"saleCount":@"sales_num",
             @"goodsImageUrl":@"postage",
             @"state":@"state",
             @"postage":@"postage",
             @"commentCount":@"comment_num",
             @"remark":@"remark",
             @"parameter":@"parameter",
             @"commentCount":@"comment_num",
             @"goodsDetails":@"product_details",
             @"userName":@"member_name",
             @"avatar":@"avatar",
             @"userName":@"member_name",
             @"commentContent":@"content",
             @"goodsPrice":@"promotion_price",
                @"picture_01":@"picture_01",
                @"picture_02":@"picture_02",
                @"picture_03":@"picture_03",
                @"picture_04":@"picture_04",
                @"picture_05":@"picture_05",
             @"specArray":@"spec",};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"specArray"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            id result;
            if ([value isKindOfClass:[NSArray class]]) {
                result = [MTLJSONAdapter modelsOfClass:[EMSpecListModel class] fromJSONArray:value error:error];
            }
            return result;
        }];
    }else{
        return nil;
    }
}
-(NSMutableArray<NSString *> *)goodsImageArray{
    if (nil==_goodsImageArray) {
        _goodsImageArray=[[NSMutableArray alloc]  init];
    }
    [_goodsImageArray removeAllObjects];
    if (!_goodsImageArray.count) {
        if (![NSString isNilOrEmptyForString:self.picture_01]) {
            [_goodsImageArray addObject:self.picture_01];
        }
        if (![NSString isNilOrEmptyForString:self.picture_02]) {
            [_goodsImageArray addObject:self.picture_02];
        }
        if (![NSString isNilOrEmptyForString:self.picture_03]) {
            [_goodsImageArray addObject:self.picture_03];
        }
        if (![NSString isNilOrEmptyForString:self.picture_04]) {
            [_goodsImageArray addObject:self.picture_04];
        }
        if (![NSString isNilOrEmptyForString:self.picture_05]) {
            [_goodsImageArray addObject:self.picture_05];
        }
    }
    return _goodsImageArray;
}
@end

@interface EMGoodsDetailModel ()
@property (nonatomic,strong,readwrite)NSMutableDictionary *specDic;
@end

@implementation EMGoodsDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"goodsModel":@"goods",
             @"goodsInfoArray":@"detail",
             };
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"goodsInfoArray"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            id result;
            if ([value isKindOfClass:[NSArray class]]) {
                result = [MTLJSONAdapter modelsOfClass:[EMGoodsInfoModel class] fromJSONArray:value error:error];
            }
            return result;
        }];
    }else if([key isEqualToString:@"goodsModel"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            id result;
            if ([value isKindOfClass:[NSDictionary class]]) {
                result = [MTLJSONAdapter modelOfClass:[EMGoodsModel class] fromJSONDictionary:value error:error];
            }
            return result;
        }];
    }else{
        
        return nil;
    }
}
- (EMGoodsInfoModel *)defaultGoodsInfo{
    NSSortDescriptor *sortDescriptor0 = [NSSortDescriptor sortDescriptorWithKey:@"_promotePrice" ascending:YES];
    NSArray *tempArray = [self.goodsInfoArray sortedArrayUsingDescriptors:@[sortDescriptor0]];//价钱降序，最小的
    if (tempArray&&tempArray.count) {
      _defaultGoodsInfo=[tempArray firstObject];
    }
    return _defaultGoodsInfo;
}

- (NSMutableDictionary *)specDic{
    if (!_specDic) {
        NSMutableArray *allSpecArray=[[NSMutableArray alloc]  init];
        NSMutableSet *specCatSet=[[NSMutableSet alloc]  init];
        for (EMGoodsInfoModel *infoModel in self.goodsInfoArray) {
            for (EMSpecListModel *specListModel in infoModel.specListArray) {
                [specCatSet addObject:specListModel.pName];
                [allSpecArray addObjectsFromArray:specListModel.specsArray];
            }
        }
        if (specCatSet.count) {
            NSMutableDictionary *resultDic=[NSMutableDictionary new];
            NSArray *specNameArray=[specCatSet allObjects];
            for (NSString *pName in specNameArray) {
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"_pName=%@",pName];
                NSArray *tempArray=[allSpecArray filteredArrayUsingPredicate:predicate];
                if (tempArray.count) {
                    [resultDic setObject:tempArray forKey:pName];
                }
            }
            _specDic=resultDic;
        }
    }
    return _specDic;
}
- (NSMutableArray *)goodsSpecListArray{
    if (nil==_goodsSpecListArray) {
        _goodsSpecListArray=[[NSMutableArray alloc]  init];
    }
    
    return _goodsSpecListArray;
}

//- (NSMutableArray *)allSpecArray{
//    if (nil==_allSpecArray) {
//        _allSpecArray=[NSMutableArray new];
//    }
//    if (!_allSpecArray.count) {
//        for (EMSpecListModel *specListModel in self.specListArray) {
//            [_allSpecArray addObjectsFromArray:specListModel.specsArray];
//        }
//    }
//    return _allSpecArray;
//}
@end