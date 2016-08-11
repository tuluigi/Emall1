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
             @"pid":@"pid",
              @"catName":@"classify_name",
             @"catImageUrl":@"icon_url",};
}
- (NSMutableArray *)childCatArray{
    if (nil==_childCatArray) {
        _childCatArray=[[NSMutableArray alloc]  init];
    }
    return _childCatArray;
}
@end
