//
//  EMMeNetService.m
//  EMall
//
//  Created by Luigi on 16/8/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMeNetService.h"
#import "EMUserModel.h"
#import "EMPersistence.h"
#import "EMAreaModel.h"
#import "EMShopAddressModel.h"
@implementation EMMeNetService
+ (NSURLSessionTask *)userRegisterWithUserName:(NSString *)name
                                         email:(NSString *)email
                                           pwd:(NSString *)pwd
                             OnCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member/register"];
    NSDictionary *postDic=@{@"member.user_name":stringNotNil(name),@"member.e_mail":stringNotNil(email),@"member.password":stringNotNil(pwd)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)userLoginWithUserName:(NSString *)name
                                        pwd:(NSString *)pwd
                          OnCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member/login"];
      NSDictionary *postDic=@{@"member.user_name":stringNotNil(name),@"member.password":stringNotNil(pwd)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMUserModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (responseResult.responseCode==OCCodeStateSuccess) {
                [EMPersistence persistenceWithUserModel:responseResult.responseData];
                [[NSNotificationCenter defaultCenter] postNotificationName:OCLoginSuccessNofication object:nil];
            }
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (void)userLogoutOnCompletionBlock:(void(^)())completionBlock{
    [EMPersistence userLogou];
    
    if (completionBlock) {
        completionBlock();
    }
}
+ (NSURLSessionTask *)getUserInfoWithUserID:(NSInteger)userID onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member/findById"];
    NSDictionary *postDic=@{@"id":@(userID)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMUserModel class] error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (responseResult.responseCode==OCCodeStateSuccess) {
                [EMPersistence persistenceWithUserModel:responseResult.responseData];
            }
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)editUserInfoWithUserID:(NSInteger)userID
                                    UserName:(NSString *)nickName
                                       email:(NSString *)email
                                    birthday:(NSString *)birthday
                                      avatar:(NSString *)avatar
                                      gender:(NSString *)gender
                                    wechatID:(NSString *)weChatID
                                   oldAvatar:(NSString *)oldAvatar
                           OnCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member/update"];
    NSDictionary *postDic=@{@"member.id":@(userID),@"member.member_name":stringNotNil(nickName),@"member.e_mail":stringNotNil(email),@"member.sex":stringNotNil(gender),@"member.birthday":stringNotNil(birthday)};
    NSMutableDictionary *parmDic=[NSMutableDictionary dictionaryWithDictionary:postDic];
    if (![NSString isNilOrEmptyForString:avatar]) {
        [parmDic setObject:stringNotNil(avatar) forKey:@"member.avatar"];
        if (![NSString isNilOrEmptyForString:oldAvatar]) {
          [parmDic setObject:stringNotNil(oldAvatar) forKey:@"old.avatar"];
        }
    }
    if (![NSString isNilOrEmptyForString:weChatID]) {
        [parmDic setObject:weChatID forKey:@"member.webchat"];
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:parmDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (responseResult.responseCode==OCCodeStateSuccess) {
                EMUserModel *userModel=[EMPersistence localUserModel];
                userModel.nickName=nickName;
                userModel.gender=gender;
                userModel.wechatID=weChatID;
                if (![NSString isNilOrEmptyForString:avatar]) {
                    userModel.avatar=avatar;
                }
                [EMPersistence persistenceWithUserModel:userModel];
            }
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)editUserPwdWithUserID:(NSInteger)userID
                                  originPwd:(NSString *)originPwd
                                     newPwd:(NSString *)newPwd
                          onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member/updatePwd"];
    NSDictionary *postDic=@{@"id":@(userID),@"password":originPwd,@"newPwd":newPwd};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
                       if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)findUserPwdWithUserName:(NSString *)userName
                                        email:(NSString *)email
                            onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member/findpwd"];
    NSDictionary *postDic=@{@"username":email,@"email":stringNotNil(userName)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
+ (NSURLSessionTask *)getAreaWithParentID:(NSInteger )parentID
                        onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"area/findById"];
    NSDictionary *postDic;
    if (parentID>0) {
        postDic=@{@"id":@(parentID)};
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMAreaModel class] error:error onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}

+ (NSURLSessionTask *)addOrEditShoppingAddressWithUrseID:(NSInteger)userID
                                               addressID:(NSInteger)addressID
                                                receiver:(NSString *)receiver tel:(NSString *)tel
                                                provicen:(NSString *)provience
                                                    city:(NSString *)city
                                                 country:(NSString *)country
                                           detailAddress:(NSString *)detailaddress
                                                wechatID:(NSString *)wechatID
                                                   state:(NSInteger)state
                                       onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member_address/saveOrUpdate"];
    NSDictionary *postDic=@{@"memberAddress.mid":@(userID),@"memberAddress.telphone":stringNotNil(tel),@"memberAddress.province":stringNotNil(provience),@"memberAddress.city":stringNotNil(city),@"memberAddress.county":stringNotNil(country),@"memberAddress.detail_address":stringNotNil(detailaddress),@"memberAddress.state":@(state),@"memberAddress.addressee":stringNotNil(receiver),@"memberAddress.webchat":stringNotNil(wechatID)};
    NSMutableDictionary *parmDic=[NSMutableDictionary dictionaryWithDictionary:postDic];
    if (addressID) {
        [parmDic setObject:@(addressID) forKey:@"memberAddress.id"];
    }
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:parmDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
/**
 *  获取收货地址列表
 *
 *  @param userID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getShoppingAddressListWithUrseID:(NSInteger)userID
                                     onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member_address"];
    NSDictionary *postDic=@{@"mid":@(userID)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[EMShopAddressModel class] error:error onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;

}
/**
 *  删除收货地址
 *
 *  @param userID
 *  @param addressID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)deleteShoppingAddressWithAddresID:(NSInteger)addressID
                                    onCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member_address/delete"];
    NSDictionary *postDic=@{@"id":@(addressID)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:error onCompletionBlock:^(OCResponseResult *responseResult) {
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
@end
