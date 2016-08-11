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
 *  @param pid
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getGoodsListWithSearchGoodsID:(NSInteger )goodsID
                                         searchName:(NSString *)name
                                               aesc:(BOOL)aesc
                                           sortType:(NSInteger)sortType
                                                pid:(NSString *)pid
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

@end
