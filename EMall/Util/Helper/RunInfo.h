//
//  RunInfo.h
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//


#import <Foundation/Foundation.h>

#ifndef RI
#define RI ([RunInfo sharedInstance])
#endif

@interface RunInfo : NSObject
CC_DECLARE_SINGLETON_FOR_CLASS(RunInfo)
@property (nonatomic,assign,readonly)BOOL isLogined;
@property(nonatomic,assign) NSInteger userID;
@property(nonatomic,copy)   NSString *userName;
@property(nonatomic,copy)   NSString *avatar;
@end
