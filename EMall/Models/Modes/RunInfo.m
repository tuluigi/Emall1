//
//  RunInfo.m
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "RunInfo.h"


@interface RunInfo ()
@property (nonatomic,assign,readwrite)BOOL isLogin;
@end

@implementation RunInfo
CC_SYNTHESIZE_SINGLETON_FOR_CLASS(RunInfo)
- (void)setUserID:(NSInteger)userID{
    _userID=userID;
    if (_userID) {
        _isLogin=YES;
    }else{
        _isLogin=NO;
    }
}
@end
