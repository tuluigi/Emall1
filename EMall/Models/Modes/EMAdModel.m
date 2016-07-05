//
//  EMAdModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMAdModel.h"

@implementation EMAdModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"adID":@"id",
             @"adImageUrl":@"image",
             @"adUrl":@"url"};
}
@end
