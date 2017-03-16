//
//  EMAreaModel.m
//  EMall
//
//  Created by Luigi on 16/8/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMAreaModel.h"

@implementation EMAreaModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"areaName":@"areaname",
             @"shortname":@"shortname",
             @"parentID":@"parentid",
             @"areaID":@"id",
             @"lng":@"lng",
             @"lat":@"lat",};
}
- (NSMutableArray<EMAreaModel *> *)childAreaArray{
    if (nil==_childAreaArray) {
        _childAreaArray=[NSMutableArray new];
    }
    return _childAreaArray;
}
@end
