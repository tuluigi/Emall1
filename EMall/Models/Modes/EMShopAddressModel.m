//
//  EMShopAddressModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShopAddressModel.h"

@implementation EMShopAddressModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"addressID":@"id",
             @"userName":@"addressee",
             @"userTel":@"telphone",
             @"province":@"province",
             @"city":@"city",
             @"country":@"",
             @"detailAddresss":@"detail_address",
             @"isDefault":@"state",
             @"state":@"state"};
}
-(NSString *)fullAdderssString{
     NSString *address=[NSString stringWithFormat:@"%@%@%@%@",stringNotNil(self.city),stringNotNil(self.city),stringNotNil(self.country),stringNotNil(self.detailAddresss)];
    return address;
}
@end
