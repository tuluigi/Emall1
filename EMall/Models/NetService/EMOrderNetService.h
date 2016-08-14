//
//  EMOrderNetService.h
//  EMall
//
//  Created by Luigi on 16/8/14.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseNetService.h"
@class EMShopCartModel;
@interface EMOrderNetService : OCBaseNetService
/**
 *  提交订单
 *
 *  @param useID
 *  @param shopCartArray
 *  @param addressID
 *  @param type            物流方式 1自取，2快递
 *  @param remark
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)submitWithUserID:(NSInteger)useID
                             shopCarts:(NSArray <EMShopCartModel *>*)shopCartArray
                             addressID:(NSInteger)addressID
                          logisticType:(NSInteger)type
                                remark:(NSString *)remark
                     onCompletionBlock:(OCResponseResultBlock)compleitonBlock;

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
                           onCompletionBlock:(OCResponseResultBlock)compleitonBlock;

/**
 * 获取订单详情
 *
 *  @param orderID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getOrderDetailWithOrderID:(NSInteger)orderID
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock;

/**
 *  获取用户订单数量
 *
 *  @param userID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getOrderStateNumWithUserID:(NSInteger)userID
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
@end
