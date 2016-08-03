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
@end
