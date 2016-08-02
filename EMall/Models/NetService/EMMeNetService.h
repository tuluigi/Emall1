//
//  EMMeNetService.h
//  EMall
//
//  Created by Luigi on 16/8/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseNetService.h"

@interface EMMeNetService : OCBaseNetService
+ (NSURLSessionTask *)userRegisterWithUserName:(NSString *)name
                                         email:(NSString *)email
                                           pwd:(NSString *)pwd
                             OnCompletionBlock:(OCResponseResultBlock)compleitonBlock;
+ (NSURLSessionTask *)userLoginWithUserName:(NSString *)name
                                           pwd:(NSString *)pwd
                             OnCompletionBlock:(OCResponseResultBlock)compleitonBlock;
@end
