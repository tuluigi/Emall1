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

@end
