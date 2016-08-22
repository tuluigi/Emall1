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
             @"promotionPrice":@"promotion_price",
             @"goodsPrice":@"amount",
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
-(NSMutableDictionary *)specsDic{
    if (!_specsDic) {
        if (nil==_specsDic) {
            _specsDic=[NSMutableDictionary new];
        }
        for (EMSpecListModel *listModel in self.specListArray) {
            for (EMSpecModel *specModel in listModel.specsArray) {
                [_specsDic setObject:specModel forKey:specModel.name];
            }
        }
    }
    return _specsDic;
}
@end


@interface EMGoodsModel ()
@property (nonatomic,copy)NSString *picture_01,*picture_02,*picture_03,*picture_04,*picture_05;
@property(nonatomic,strong,readwrite)NSMutableArray <NSString *>*goodsImageArray;
@end

@implementation EMGoodsModel
//-(NSString *)videoUrl{
//    if (nil==_videoUrl) {
//        _videoUrl=@"http://mov.bn.netease.com/open-movie/nos/mp4/2016/08/09/SBT4C26SI_sd.mp4";
//    }
//    return _videoUrl;
//}
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
             @"goodsPrice":@"amount",
             @"videoUrl":@"video_url",
             @"promotionPrice":@"promotion_price",
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
@property (nonatomic,strong,readwrite)EMGoodsInfoModel  *defaultGoodsInfo;
@property (nonatomic,strong)NSLock *lock;
@end

@implementation EMGoodsDetailModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock=[[NSLock alloc]  init];
        self.lock.name=@"defaultGoodsInfo";
    }
    return self;
}
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
- (void)setGoodsInfoArray:(NSMutableArray *)goodsInfoArray{
    _goodsInfoArray=goodsInfoArray;
}
- (EMGoodsInfoModel *)defaultGoodsInfo{
    if (!_defaultGoodsInfo) {
        if (self.goodsInfoArray.count) {
            _defaultGoodsInfo=self.goodsInfoArray[0];
            if (self.goodsInfoArray.count>1) {
                NSSortDescriptor *sortDescriptor0 = [NSSortDescriptor sortDescriptorWithKey:@"_promotionPrice" ascending:YES];
                NSArray *tempArray = [self.goodsInfoArray sortedArrayUsingDescriptors:@[sortDescriptor0]];//价钱降序，最小的
                if (tempArray&&tempArray.count) {
                    _defaultGoodsInfo=[tempArray firstObject];
                }
            }else{
                _defaultGoodsInfo=self.goodsInfoArray[0];
            }
        }else{
            _defaultGoodsInfo=nil;
        } 
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
                    NSMutableDictionary *specDic=[NSMutableDictionary dictionary];
                    for (EMSpecModel *specModel in tempArray) {
                        [specDic setObject:specModel forKey:specModel.name];
                    }
                    [resultDic setObject:specDic forKey:pName];
//                    [resultDic setObject:tempArray forKey:pName];
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


@end