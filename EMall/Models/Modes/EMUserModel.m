//
//  EMUserModel.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMUserModel.h"

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
@end
