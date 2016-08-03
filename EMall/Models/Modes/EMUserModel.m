//
//  EMUserModel.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMUserModel.h"

static NSString *const kUserID      = @"KUserID";
static NSString *const kUserName    = @"KUserName";
static NSString *const kUserAvatar  = @"kUserAvatar";

@implementation EMUserModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"userID":@"id",
             @"userName":@"user_name",
             @"nickName":@"member_name",
             @"avatar":@"avatar",
             @"email":@"e_mail",
             @"tel":@"telephone",
             @"gender":@"sex",
             @"birtadyDay":@"birthday",
             @"level":@"level",};
}

- (void)syncStorgeUserInfo{
    if (self) {
        [[NSUserDefaults standardUserDefaults] setObject:@(self.userID) forKey:kUserID];
        [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:kUserName];
        [[NSUserDefaults standardUserDefaults] setObject:self.avatar forKey:kUserAvatar];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
+ (BOOL)isLogin{
    BOOL userID=[[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] integerValue];
    if (userID>0) {
        return YES;
    }else{
        return NO;
    }
}
@end
