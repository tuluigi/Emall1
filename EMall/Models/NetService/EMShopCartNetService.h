//
//  EMShopCartNetService.h
//  EMall
//
//  Created by Luigi on 16/8/12.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseNetService.h"

@interface EMShopCartNetService : OCBaseNetService
/**
 *  添加到购物车
 *
 *  @param useID           用户ID
 *  @param infoID          商品明细ID
 *  @param buyCount        数量
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)addShopCartWithUserID:(NSInteger)useID
                                     infoID:(NSInteger)infoID
                                   buyCount:(NSInteger)buyCount
                          onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
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
                          onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
/**
 *  删除购物车
 *
 *  @param cartID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)deleteShopCartWithCartIDs:(NSArray <NSNumber *>*)cartIDArray
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock;

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
                             onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
@end
