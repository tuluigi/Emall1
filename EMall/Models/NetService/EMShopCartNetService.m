//
//  EMShopCartNetService.m
//  EMall
//
//  Created by Luigi on 16/8/12.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShopCartNetService.h"
#import "EMShopCartModel.h"
@implementation EMShopCartNetService
+ (NSURLSessionTask *)addShopCartWithUserID:(NSInteger)useID
                                     infoID:(NSInteger)infoID
                                   buyCount:(NSInteger)buyCount
                          onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods_cart/save"];
    NSDictionary *postDic=@{@"goodsCart.mid":@(useID),@"goodsCart.gdid":@(infoID),@"goodsCart.quantity":@(buyCount)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (responseResult.responseCode==OCCodeStateSuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kEMShopCartShouldUpdateNotification object:nil];
            }
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
/**
 *  获取购物车列表
 *
 *  @param useID
 *  @param pid
 *  @param pageSize
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getShopCartListWithUserID:(NSInteger)useID
                                            pid:(NSInteger )pid
                                       pageSize:(NSInteger)pageSize
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods_cart"];
    NSDictionary *postDic=@{@"mid":@(useID),@"cursor":@(pid),@"pageSize":@(pageSize)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMShopCartModel class] error:error onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
/**
 *  删除购物车
 *
 *  @param cartID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)deleteShopCartWithCartIDs:(NSArray <NSNumber *>*)cartIDArray
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods_cart/delete"];
    NSString *parmString=@"?";
    for (NSInteger i=0; i<cartIDArray.count; i++) {
        NSString *aString=[NSString stringWithFormat:@"%@=%@",@"id",cartIDArray[i]];
        parmString=[parmString stringByAppendingString:aString];
        if (i<cartIDArray.count-1) {
            parmString=[parmString stringByAppendingString:@"&"];
        }
    }
    apiPath=[apiPath stringByAppendingString:parmString];
//    NSDictionary *postDic=@{@"goodsCart.id":@(0)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:nil method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}

/**
 *  修改购物车购买数量
 *
 *  @param cartID
 *  @param buyCount
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)editShopCartWithCartID:(NSInteger)cartID
                                    buyCount:(NSInteger)buyCount
                           onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods_cart/update"];
    NSDictionary *postDic=@{@"goodsCart.id":@(cartID),@"goodsCart.quantity":@(buyCount)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
@end
