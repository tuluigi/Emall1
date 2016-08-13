//
//  EMShopAddressModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

@interface EMShopAddressModel : OCBaseModel
@property(nonatomic,assign)NSInteger addressID;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userTel;
@property(nonatomic,copy)NSString *province,*city;
@property(nonatomic,copy)NSString *country;//县，区
@property(nonatomic,copy)NSString *street;//街道
@property(nonatomic,copy)NSString *detailAddresss;//用户地址
@property(nonatomic,copy)NSString *wechatID;//微信值
@property(nonatomic,assign)BOOL isDefault;//是否默认
@end
