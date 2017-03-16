//
//  RunInfo.m
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "RunInfo.h"
#import "EMPersistence.h"
#import "EMUserModel.h"
@interface RunInfo ()
@property (nonatomic,assign,readwrite)BOOL isLogined;
@end

@implementation RunInfo
CC_SYNTHESIZE_SINGLETON_FOR_CLASS(RunInfo)
- (instancetype)init{
    self=[super init];
    if (self) {
        EMUserModel *userModel=[EMPersistence localUserModel];
        [EMPersistence syncRiInfoWithUserModel:userModel ri:self];
    }
    return self;
}
- (void)setUserID:(NSInteger)userID{
    _userID=userID;
    if (_userID) {
        _isLogined=YES;
    }else{
        _isLogined=NO;
    }
}
-(void)userLogout{
    [EMPersistence userLogou];
}
@end
