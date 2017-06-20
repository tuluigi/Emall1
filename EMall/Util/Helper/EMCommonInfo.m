//
//  EMCommonInfo.m
//  EMall
//
//  Created by netease on 16/9/8.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCommonInfo.h"

@implementation EMCommonInfo
+ (NSString *)appVersion{
    NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
    
}
+ (NSString *)appBuildVersion{
    NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return appVersion;
    
}
+ (BOOL)compareOldVersion:(NSString *)anOldVersion withNewVersion:(NSString *)aNewVersion
{
    NSArray *oldVersion = [anOldVersion componentsSeparatedByString:@"."];
    NSArray *newVersion = [aNewVersion componentsSeparatedByString:@"."];
    
    NSUInteger count = MAX(oldVersion.count, newVersion.count);
    
    BOOL result = NO;
    for (NSInteger i=0; i < count; i++)
    {
        NSInteger old = 0;
        if (i < oldVersion.count)
        {
            old = [(NSString *)[oldVersion objectAtIndex:i] integerValue];
        }
        
        NSInteger new = 0;
        if (i < newVersion.count)
        {
            new = [(NSString *)[newVersion objectAtIndex:i] integerValue];
        }
        
        if (old < new)
        {
            result = YES;
            break;
        }
        else if (old > new)
        {
            break;
        }
    }
    
    return result;
}
@end
