//
//  EMCache.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCache.h"
#import <TMCache/TMCache.h>
@implementation EMCache
+ (void)em_setObject:(id)value forKey:(NSString *)key{
    [[TMCache sharedCache] setObject:value forKey:key];
}
+ (id)em_objectForKey:(NSString *)key{
    id value=[[TMCache sharedCache] objectForKey:key];
    return value;
}
+ (void)em_removeAllCache{
    [[TMCache sharedCache] removeAllObjects:^(TMCache *cache) {
        
    }];
}
@end
