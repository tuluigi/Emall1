//
//  EMCatNetService.h
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseNetService.h"

@interface EMCatNetService : OCBaseNetService
/**
 *  获取商品类别
 *
 *  @param pid pid =0 获取一级类别
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getCatListWithParentID:(NSInteger)pid
                           onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
@end
