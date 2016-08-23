//
//  EMHomeNetService.h
//  EMall
//
//  Created by Luigi on 16/7/5.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseNetService.h"

@interface EMHomeNetService : OCBaseNetService
/**
 *  获取首页广告列表
 *
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getHomeAdListOnCompletionBlock:(OCResponseResultBlock)compleitonBlock;

/**
 *  获取首页数据
 *
 *  @param completionBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getHomeDataOnCompletionBlock:(OCResponseResultBlock)completionBlock;

/**
 *  获取系统配置信息接口
 *
 *  @param completionBlock
 *
 *  @return 
 */
+ (NSURLSessionTask *)getSystemConfigCompletionBlock:(OCResponseResultBlock)completionBlock;
@end
