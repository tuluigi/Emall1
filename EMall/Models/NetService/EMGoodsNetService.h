//
//  EMGoodsNetService.h
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseNetService.h"

@interface EMGoodsNetService : OCBaseNetService
/**
 *  获取商品列表数据
 *
 *  @param goodsID         商品id
 *  @param name            商品名称
 *  @param aesc            升降序
 *  @param sortType        排序方式  1 = 销量, 2 = 价格
 *  @param homeType        type 上架类型 1 = 精品, 2 = 热卖 <只用于首页的>
 *  @param pid
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getGoodsListWithSearchGoodsID:(NSInteger )goodsID
                                              catID:(NSInteger)catID
                                         searchName:(NSString *)name
                                               aesc:(BOOL)aesc
                                           sortType:(NSInteger)sortType
                                               homeType:(NSInteger)homeType
                                                pid:(NSInteger )pid
                                           pageSize:(NSInteger)pageSize
                                  onCompletionBlock:(OCResponseResultBlock)compleitonBlock;

/**
 *  获取商品详情接口
 *
 *  @param goodsID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getGoodsDetailWithGoodsID:(NSInteger )goodsID
                                  onCompletionBlock:(OCResponseResultBlock)compleitonBlock;

/**
 *  获取当前商品规格分组
 *
 *  @param goodsID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getGoodsSpeListWithGoodsID:(NSInteger )goodsID
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
@end
