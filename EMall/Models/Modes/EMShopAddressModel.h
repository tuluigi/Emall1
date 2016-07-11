//
//  EMShopAddressModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMShopAddressModel : OCBaseModel
@property(nonatomic,copy)NSString *addressID;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userTel;
@property(nonatomic,copy)NSString *userCity;
@property(nonatomic,copy)NSString *userStreet;
@property(nonatomic,copy)NSString *userAddress;//用户地址
@property(nonatomic,copy)NSString *wechatID;//微信值
@property(nonatomic,assign)BOOL isDefault;//是否默认
@end
