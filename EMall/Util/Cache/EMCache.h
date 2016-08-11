//
//  EMCache.h
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMCache : NSObject
+ (void)em_setObject:(id)value forKey:(NSString *)key;
+ (id)em_objectForKey:(NSString *)key;
+ (void)em_removeAllCache;
@end
