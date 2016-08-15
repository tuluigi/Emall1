//
//  EMHomeNetService.m
//  EMall
//
//  Created by Luigi on 16/7/5.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeNetService.h"
#import "EMAdModel.h"
#import "EMGoodsModel.h"
#import "EMHomeModel.h"
@implementation EMHomeNetService
+ (NSURLSessionTask *)getHomeAdListOnCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"spread"];
//    NSString *apiPath=@"http://static.duapp.com/app/shopping/api/homeSpread";
    NSDictionary *postDic=@{@"type":@(1)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMAdModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}

/**
 *  获取首页数据
 *
 *  @param completionBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getHomeDataOnCompletionBlock:(OCResponseResultBlock)completionBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"list"];
//NSString *apiPath=@"http://static.duapp.com/app/shopping/api/home";
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:nil method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMHomeModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (completionBlock) {
                completionBlock(responseResult);
            }
        }];
    }];
    return task;
}
@end
