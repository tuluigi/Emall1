//
//  EMMeNetService.h
//  EMall
//
//  Created by Luigi on 16/8/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseNetService.h"

@interface EMMeNetService : OCBaseNetService
/**
 *  用户注册
 *
 *  @param name
 *  @param email
 *  @param pwd
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)userRegisterWithUserName:(NSString *)name
                                         email:(NSString *)email
                                           pwd:(NSString *)pwd
                             OnCompletionBlock:(OCResponseResultBlock)compleitonBlock;
/**
 *  用户登陆
 *
 *  @param name
 *  @param pwd
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)userLoginWithUserName:(NSString *)name
                                        pwd:(NSString *)pwd
                          OnCompletionBlock:(OCResponseResultBlock)compleitonBlock;
/**
 *  用户退出登陆
 *
 *  @param completionBlock
 */
+ (void)userLogoutOnCompletionBlock:(void(^)())completionBlock;
/**
 *  获取用户信息
 *
 *  @param userID          用户id
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getUserInfoWithUserID:(NSInteger)userID onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
/**
 *  修改用户信息
 *
 *  @param userID
 *  @param name
 *  @param email
 *  @param birthday
 *  @param avatar
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)editUserInfoWithUserID:(NSInteger)userID
                                    UserName:(NSString *)name
                                       email:(NSString *)email
                                    birthday:(NSString *)birthday
                                      avatar:(NSString *)avatar
                                      gender:(NSString *)gender
                           OnCompletionBlock:(OCResponseResultBlock)compleitonBlock;

@end
