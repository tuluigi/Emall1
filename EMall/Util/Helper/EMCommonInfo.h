//
//  EMCommonInfo.h
//  EMall
//
//  Created by netease on 16/9/8.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMCommonInfo : NSObject
+ (NSString *)appVersion;
+ (NSString *)appBuildVersion;

/**
 版本号比较

 @param anOldVersion 旧版本号
 @param aNewVersion 新版本号
 @return  newVersion>oldVersion == YES   else = NO
 */
+ (BOOL)compareOldVersion:(NSString *)anOldVersion withNewVersion:(NSString *)aNewVersion;
@end
