//
//  EMOrderModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"
#import "EMShopAddressModel.h"
typedef NS_ENUM(NSInteger,EMOrderState) {
    EMOrderStateNone            ,
    EMOrderStateUnPaid          ,//未付款
    EMOrderStateUnDelivered    ,//未发货
    EMOrderStateUnSigned        ,//未签收
    EMOrderStateCanceled        ,//已取消
    EMOrderStateUnComment       ,//待评论
};

@interface EMOrderModel : OCBaseModel
@property(nonatomic,copy)NSString *orderID;
@property(nonatomic,assign)EMOrderState orderState;
@property(nonatomic,copy)NSString *orderStateString;

@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *goodsImageUrl;
@property(nonatomic,assign)CGFloat totalPrice , goodsPrice;
@property (nonatomic,copy)NSString *spec;//规格说明
@property (nonatomic,assign)NSInteger buyCount;//购买数量

@end

//个人中心的每个状态的订单Model
@interface EMOrderStateModel : NSObject
@property (nonatomic,assign)EMOrderState state;
@property (nonatomic,copy)NSString *stateName;
@property (nonatomic,copy)NSString *icomName;
@property (nonatomic,assign)NSInteger badgeNumber;
+ (EMOrderStateModel *)orderStateModelWithState:(NSInteger)state name:(NSString *)name iconName:(NSString *)iconName;

+ (NSArray *)orderStateModelArray;
+ (EMOrderState)orderStateWithStateName:(NSString *)stateName;
@end

@interface EMOrderDetialModel :OCBaseModel
@property (nonatomic,strong)EMOrderModel *orderModel;
@property (nonatomic,strong)EMShopAddressModel *addressModel;
@end
