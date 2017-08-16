//
//  EMCache.h
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *const EMCache_HomeDataSourceKey        =@"EMCache_HomeDataSourceKey_v1";//首页数据
static NSString *const EMCache_HomeADDataSourceKey      =@"EMCache_HomeADDataSourceKey";//首页广告

static NSString *const EMCache_DiscoveryDataSourceKey    =@"EMCache_DiscoveryDataSourceKey";//发现


static NSString *const EMCache_SystemConfigKey    =@"EMCache_SystemConfigKey";//系统配置缓存数据
@interface EMCache : NSObject
+ (void)em_setObject:(id)value forKey:(NSString *)key;
+ (id)em_objectForKey:(NSString *)key;
+ (void)em_removeAllCache;
@end
