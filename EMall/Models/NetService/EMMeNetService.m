//
//  EMMeNetService.m
//  EMall
//
//  Created by Luigi on 16/8/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMeNetService.h"
#import "EMUserModel.h"
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
            if (compleitonBlock) {
                compleitonBlock(responseResult);
            }
        }];
    }];
    return task;
}
@end
