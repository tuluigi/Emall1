//
//  EMSystemConfigModel.m
//  EMall
//
//  Created by Luigi on 16/8/23.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMSystemConfigModel.h"

@implementation EMSystemConfigModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"bsb":@"bsb",
             @"acc":@"acc",
             @"accName":@"accName",
             @"serviceTel":@"customerTel",
             @"qrCodeUrl":@"qr",};
}
@end
