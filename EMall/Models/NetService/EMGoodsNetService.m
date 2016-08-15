//
//  EMGoodsNetService.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsNetService.h"
#import "EMGoodsModel.h"
#import "EMGoodsCommentModel.h"
@implementation EMGoodsNetService
+ (NSURLSessionTask *)getGoodsListWithSearchGoodsID:(NSInteger )goodsID
                                              catID:(NSInteger)catID
                                         searchName:(NSString *)name
                                               aesc:(BOOL)aesc
                                           sortType:(NSInteger)sortType
                                           homeType:(NSInteger)homeType
                                                pid:(NSInteger )pid
                                           pageSize:(NSInteger)pageSize
                                  onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods"];
    NSMutableDictionary *postDic=[NSMutableDictionary new];
    if (goodsID) {
        [postDic setObject:@(goodsID) forKey:@"goods.id"];
    }
    if (![NSString isNilOrEmptyForString:name]) {
        [postDic setObject:name forKey:@"goods.name"];
    }
    NSString *aescString=@"asc";
    if (aesc) {
        aescString=@"asc";
    }else{
        aescString=@"desc";
    }
    [postDic setObject:aescString forKey:@"order_direction"];
    if (sortType) {
        [postDic setObject:@(sortType) forKey:@"order_field"];
    }
    pid=MIN(1, pid);
    if (pid) {
        [postDic setObject:@"cursor" forKey:@(pid)];
    }
    if (pageSize) {
        [postDic setObject:@(pageSize) forKey:@"pageSize"];
    }
    if (catID) {
        [postDic setObject:@(catID) forKey:@"goods.cid"];
    }
    if (homeType) {
        [postDic setObject:@(homeType) forKey:@"type"];
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMGoodsModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            
            /*
            NSArray *imageArray1=@[@"http://m.360buyimg.com/babel/s350x350_jfs/t2587/290/524206809/143694/a6cf67a0/5717240eN8bb3ce05.jpg!q70.jpg",
                                   @"http://img11.360buyimg.com/da/jfs/t2956/321/2204693458/27713/9aa56e04/579ea99dN25160330.jpg",
                                   @"http://m.360buyimg.com/babel/s350x350_jfs/t2530/265/1340818545/115126/2823db05/56c02071N15288acb.jpg!q70.jpg",
                                   ];
            if (responseResult.responseCode==OCCodeStateSuccess) {
                NSArray *goodsArray=(NSArray *)responseResult.responseData;
                for (EMGoodsModel *goodsModel in goodsArray) {
                    NSInteger index=[goodsArray indexOfObject:goodsModel];
                    index=index%imageArray1.count;
                    goodsModel.goodsImageUrl=[imageArray1 objectAtIndex:index];
                }
            }
*/
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}

/**
 *  获取商品详情接口
 *
 *  @param goodsID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getGoodsDetailWithGoodsID:(NSInteger )goodsID
                              onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods/detail"];
    NSMutableDictionary *postDic=[NSMutableDictionary new];
    if (goodsID) {
        [postDic setObject:@(goodsID) forKey:@"id"];
    }
       NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMGoodsDetailModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)getGoodsSpeListWithGoodsID:(NSInteger )goodsID
                               onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"goods/spec"];
    NSMutableDictionary *postDic=[NSMutableDictionary new];
    if (goodsID) {
        [postDic setObject:@(goodsID) forKey:@"id"];
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMSpecListModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
        if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}

+ (NSURLSessionTask *)writeComemntWithUsrID:(NSInteger)userID
                                    orderID:(NSInteger)orderID
                                     goodID:(NSInteger)goodsID
                                    content:(NSString *)content
                                       star:(NSInteger)star
                          onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"order_comment/save"];
    NSDictionary *postDic=@{@"orderComment.mid":@(userID),@"orderComment.oid":@(orderID),@"orderComment.gid":@(goodsID),@"orderComment.star":@(star),@"orderComment.content":stringNotNil(content)};
    
    
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}


+ (NSURLSessionTask *)getGoodsComemntsWithUserID:(NSInteger)userID
                                         goodsID:(NSInteger )goodsID
                                            star:(NSInteger)star
                                          cursor:(NSInteger)cursor
                                        pageSize:(NSInteger)pageSize
                               onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[self urlWithSuffixPath:@"order_comment"];
    cursor=MIN(1, cursor);
    NSDictionary *postDic=@{@"orderComment.mid":@(userID),@"orderComment.gid":@(goodsID),@"orderComment.star":@(star),@"cusor":@(cursor),@"pageSize":@(pageSize)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMGoodsCommentModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;

}
@end
