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
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"/member/findById"];
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
                                    UserName:(NSString *)name
                                       email:(NSString *)email
                                    birthday:(NSString *)birthday
                                      avatar:(NSString *)avatar
                                      gender:(NSString *)gender
                           OnCompletionBlock:(OCResponseResultBlock)compleitonBlock{
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member/update"];
    NSDictionary *postDic=@{@"member.id":@(userID),@"member.user_name":stringNotNil(name),@"member.e_mail":stringNotNil(email),@"member.sex":stringNotNil(gender),@"member.birthday":stringNotNil(birthday)};
    NSURLSessionTask *task=[[OCNetSessionManager sharedSessionManager] requestWithUrl:apiPath parmars:postDic method:NETGET onCompletionHander:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:nil error:nil onCompletionBlock:^(OCResponseResult *responseResult) {
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
    NSString *apiPath=[EMMeNetService urlWithSuffixPath:@"member/findpwd"];
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
@end
