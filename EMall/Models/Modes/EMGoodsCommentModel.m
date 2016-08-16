//
//  EMGoodsCommentModel.m
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsCommentModel.h"

@implementation EMCommentStarModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"star":@"star",
             @"startNum":@"star_num"};
}
-(NSString *)starString{
    _starString=[EMCommentStarModel starStringWithStar:self.star];
    if (self.startNum) {
        _starString=[NSString stringWithFormat:@"%@(%ld)",_starString,self.startNum];
    }
    return _starString;
}
+(NSString *)starStringWithStar:(NSInteger)star{
    NSString *_levelString=@"";
    switch (star) {
        case 1:
            _levelString=@"差评";
            break;
        case 2:
            _levelString=@"中评";
            break;
        case 3:
            _levelString=@"好评";
            break;
        default:
            _levelString=@"全部";
            break;
    }
    return _levelString;
}
@end


@interface EMGoodsCommentModel ()
@property (nonatomic,copy,readwrite)NSString *levelString;
@end

@implementation EMGoodsCommentModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"commentID":@"id",
             @"goodsID":@"gid",
             @"userID":@"mid",
             @"nickName":@"member_name",
             @"userAvatar":@"avatar",
             @"content":@"content",
             @"commentTime":@"comment_time",
             @"level":@"star"};
}


-(NSString *)levelString{
    _levelString=[EMCommentStarModel starStringWithStar:self.level];
    return _levelString;
}
@end


@implementation EMGoodsCommentHomeModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"startArray":@"star",
             @"commentArray":@"comment",};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"startArray"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            id result;
            if ([value isKindOfClass:[NSArray class]]) {
                result = [MTLJSONAdapter modelsOfClass:[EMCommentStarModel class] fromJSONArray:value error:error];
            }
            return result;
        }];
    }else if([key isEqualToString:@"commentArray"]){
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            id result;
            if ([value isKindOfClass:[NSArray class]]) {
                result = [MTLJSONAdapter modelsOfClass:[EMGoodsCommentModel class] fromJSONArray:value error:error];
            }
            return result;
        }];
    }else{
        
        return nil;
    }
}
@end