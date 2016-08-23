//
//  EMOrderNetService.m
//  EMall
//
//  Created by Luigi on 16/8/14.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderNetService.h"
#import "EMShopCartModel.h"
#import "EMOrderModel.h"
@implementation EMOrderNetService
+ (NSURLSessionTask *)submitWithUserID:(NSInteger)useID
                             shopCarts:(NSArray <EMShopCartModel *>*)shopCartArray
                             addressID:(NSInteger)addressID
                          logisticType:(NSInteger)type
                                remark:(NSString *)remark
                     onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"order/placeOrder"];
    
    NSString *parmString=@"?";
    NSString *buyCountString=@"";
    NSString *cartIDString=@"";
    for (NSInteger i=0; i<shopCartArray.count; i++) {
        EMShopCartModel *cartModel=shopCartArray[i];
        NSString *aString=[NSString stringWithFormat:@"%@=%ld",@"gcid",cartModel.cartID];
        cartIDString=[cartIDString stringByAppendingString:aString];
        
        NSString *bString=[NSString stringWithFormat:@"%@=%ld",@"quantity",cartModel.buyCount];
        buyCountString=[buyCountString stringByAppendingString:bString];
        if (i<shopCartArray.count-1) {
            cartIDString=[cartIDString stringByAppendingString:@"&"];
            buyCountString=[buyCountString stringByAppendingString:@"&"];
        }
    }
    parmString=[NSString stringWithFormat:@"?mid=%@&aid=%@&logistics_type=%@&remark=%@&%@&%@",@(useID),@(addressID),@(type),stringNotNil([remark URLEncodedString]),cartIDString,buyCountString];
    apiPath=[apiPath stringByAppendingString:parmString];
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:nil method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMOrderModel class] error:error onCompletionBlock:^(OCResponseResult *responseResult) {
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
 *  获取订单列表
 *
 *  @param useID
 *  @param orderID      order=-1, 则是获取所有的 0 = 无效,已取消，1 = 待支付， 2 = 待发货， 3 = 待签收， 4 = 待取消， 9 = 完成
 *  @param orderState
 *  @param goodsName
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getOrderListWithUserID:(NSInteger)useID
                                     orderID:(NSInteger)orderID
                                  orderState:(NSInteger)orderState
                                   goodsName:(NSString *)goodsName
                                      cursor:(NSInteger)cursor
                                    pageSize:(NSInteger)pageSize
                           onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"order"];
    NSDictionary *postDic=@{@"order.mid":@(useID),@"cursor":@(cursor),@"pageSize":@(pageSize)};
    NSMutableDictionary *parmDic=[NSMutableDictionary dictionaryWithDictionary:postDic];
    if (orderState>=0) {
        [parmDic setObject:@(orderState) forKey:@"order.state"];
    }
    if (![NSString isNilOrEmptyForString:goodsName]) {
        [parmDic setObject:goodsName forKey:@"goods_name"];
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:parmDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMOrderModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}

/**
 * 获取订单详情
 *
 *  @param orderID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getOrderDetailWithOrderID:(NSInteger)orderID
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"order/detail"];
    NSDictionary *postDic=@{@"oid":@(orderID)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMOrderModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)getOrderStateNumWithUserID:(NSInteger)userID
                               onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"order/stateNum"];
    NSDictionary *postDic=@{@"mid":@(userID)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)updateOrderStateWithOrderID:(NSInteger)orderID
                                            state:(EMOrderState)state
                                onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"order/updateState"];
    NSDictionary *postDic=@{@"id":@(orderID),@"state":@(state)};
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
