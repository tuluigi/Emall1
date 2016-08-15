//
//  EMUserModel.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMUserModel.h"
#import "AESCrypt.h"
#import "EMPersistence.h"
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
             @"level":@"level",
             @"wechatID":@"webchat"};
}

+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"birtadyDay"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSDateFormatter *formmater=[[NSDateFormatter alloc]  init];
            formmater.dateFormat=@"yyyy-MM-dd HH:mm:ss";
            NSDate *aDate=[formmater dateFromString:value];
            return aDate;
        }];
    }else{
        return nil;
    }
}
-(NSString *)genderString{
    if ([self.gender isEqualToString:@"1"]) {
        _genderString= @"男";
    }else{
        _genderString= @"女";
    }
    return _genderString;
}
+ (EMUserModel *)loginUserModel{
    EMUserModel *userModel=[EMPersistence localUserModel];
    return userModel;
}
@end
