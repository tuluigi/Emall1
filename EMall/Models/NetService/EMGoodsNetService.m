//
//  EMGoodsNetService.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsNetService.h"
#import "EMGoodsModel.h"
@implementation EMGoodsNetService
+ (NSURLSessionTask *)getGoodsListWithSearchGoodsID:(NSInteger )goodsID
                                         searchName:(NSString *)name
                                               aesc:(BOOL)asc
                                           sortType:(NSInteger)sortType
                                                pid:(NSInteger )pid
                                  onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods"];
    NSMutableDictionary *postDic=[NSMutableDictionary new];
    if (goodsID) {
        [postDic setObject:@(goodsID) forKey:@"goods.id"];
    }
    if (![NSString isNilOrEmptyForString:name]) {
        [postDic setObject:name forKey:@"goods.name"];
    }
    NSString *aescString=@"asc";
    if (asc) {
        aescString=@"asc";
    }else{
        aescString=@"desc";
    }
    [postDic setObject:aescString forKey:@"order_direction"];
    if (sortType) {
        [postDic setObject:@(sortType) forKey:@"order_field"];
    }
    if (pid) {
        [postDic setObject:@"cursor" forKey:@(pid)];
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMGoodsModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}

/**
 *  获取商品详情接口
 *
 *  @param goodsID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getGoodsDetailWithGoodsID:(NSInteger )goodsID
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods/detail"];
    NSMutableDictionary *postDic=[NSMutableDictionary new];
    if (goodsID) {
        [postDic setObject:@(goodsID) forKey:@"id"];
    }
       NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMGoodsDetailModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)getGoodsSpeListWithGoodsID:(NSInteger )goodsID
                               onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods/spec"];
    NSMutableDictionary *postDic=[NSMutableDictionary new];
    if (goodsID) {
        [postDic setObject:@(goodsID) forKey:@"id"];
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMSpecListModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
@end
