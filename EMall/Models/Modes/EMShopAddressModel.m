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
             @"country":@"county",
             @"detailAddresss":@"detail_address",
             @"isDefault":@"state",
             @"state":@"state",
             @"wechatID":@"webchat"};
}
-(NSString *)fullAreaString{
    NSString *address=[NSString stringWithFormat:@"%@%@%@",stringNotNil(self.province),stringNotNil(self.city),stringNotNil(self.country)];
    return address;

}
-(NSString *)fullAdderssString{
     NSString *address=[NSString stringWithFormat:@"%@%@",[self fullAreaString],stringNotNil(self.detailAddresss)];
    return address;
}
@end
