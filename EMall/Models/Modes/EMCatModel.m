//
//  EMCatModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCatModel.h"

@implementation EMCatModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"catID":@"id",
             @"catName":@"name",
             @"catImageUrl":@"logo",};
}
- (NSString *)catImageUrl{
    return    @"http://pic24.nipic.com/20121015/9095554_135805004000_2.jpg";
}
@end
