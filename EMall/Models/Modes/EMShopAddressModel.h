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
@property (nonatomic,assign)NSInteger userID;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userTel;
@property(nonatomic,copy)NSString *province,*city;
@property(nonatomic,copy)NSString *country;//县，区
//@property(nonatomic,copy)NSString *street;//街道
@property(nonatomic,copy)NSString *detailAddresss;//用户地址
@property(nonatomic,copy)NSString *wechatID;//微信值
@property(nonatomic,assign)BOOL isDefault;//是否默认
@property(nonatomic,assign)NSInteger state;

@property (nonatomic,copy)NSString *fullAdderssString;//完整的详细地址信息
@property (nonatomic,copy)NSString *fullAreaString;//完整的地区信息


@property (nonatomic,assign)CGFloat cellHeight;
@end
