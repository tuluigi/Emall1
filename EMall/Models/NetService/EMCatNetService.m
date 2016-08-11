//
//  EMCatNetService.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCatNetService.h"
#import "EMCatModel.h"
@implementation EMCatNetService
+ (NSURLSessionTask *)getCatListWithParentID:(NSInteger)pid
                           onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods_classify"];
    NSMutableDictionary *postDic=[NSMutableDictionary new];
    if (pid) {
        [postDic setObject:@(pid) forKey:@"pid"];
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMCatModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
@end
