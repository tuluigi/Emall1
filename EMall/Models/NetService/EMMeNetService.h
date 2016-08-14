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


/**
 *  修改用户密码
 *
 *  @param userID
 *  @param originPwd
 *  @param newPwd
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)editUserPwdWithUserID:(NSInteger)userID
                                  originPwd:(NSString *)originPwd
                                     newPwd:(NSString *)newPwd
                          onCompletionBlock:(OCResponseResultBlock)compleitonBlock;


/**
 *  用户找回密码
 *
 *  @param userName
 *  @param email
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)findUserPwdWithUserName:(NSString *)userName
                                        email:(NSString *)email
                            onCompletionBlock:(OCResponseResultBlock)compleitonBlock;

/**
 *  获取地区列表
 *
 *  @param parentID        父类别id(获取省的话，传空)
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getAreaWithParentID:(NSInteger )parentID
                        onCompletionBlock:(OCResponseResultBlock)compleitonBlock;

/**
 *  添加或者修改收货地址
 *
 *  @param userID
 *  @param addressID
 *  @param receiver
 *  @param tel
 *  @param provience
 *  @param city
 *  @param country
 *  @param detailaddress
 *  @param state
 *  @param compleitonBlock <#compleitonBlock description#>
 *
 *  @return
 */
+ (NSURLSessionTask *)addOrEditShoppingAddressWithUrseID:(NSInteger)userID
                                               addressID:(NSInteger)addressID
                                                receiver:(NSString *)receiver tel:(NSString *)tel
                                                provicen:(NSString *)provience
                                                    city:(NSString *)city
                                                 country:(NSString *)country
                                           detailAddress:(NSString *)detailaddress
                                                wechatID:(NSString *)wechatID
                                                   state:(NSInteger)state
                                       onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
/**
 *  获取收货地址列表
 *
 *  @param userID
 *  @param compleitonBlock
 *
 *  @return
 */
+ (NSURLSessionTask *)getShoppingAddressListWithUrseID:(NSInteger)userID
                                     onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
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
                                      onCompletionBlock:(OCResponseResultBlock)compleitonBlock;
@end
