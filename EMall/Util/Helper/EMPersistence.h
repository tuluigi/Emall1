//
//  EMPersistence.h
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EMUserModel;
@interface EMPersistence : NSObject
/**
 *  持久化用户信息
 *
 *  @param userModel
 */
+ (void)persistenceWithUserModel:(EMUserModel *)userModel;
+ (void)syncRiInfoWithUserModel:(EMUserModel *)userModel ri:(RunInfo *)ri;
+ (void)userLogou;
+ (EMUserModel *)localUserModel;
@end
