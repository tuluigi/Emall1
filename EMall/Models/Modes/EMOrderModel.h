//
//  EMOrderModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"
#import "EMShopAddressModel.h"
#import "EMGoodsModel.h"
typedef NS_ENUM(NSInteger,EMOrderState) {
    EMOrderStateNone           =-1 ,
    EMOrderStateCanceled        =0,//已取消
    EMOrderStateUnPaid          =1,//未付款
    EMOrderStateUnDelivered    =2,//未发货
    EMOrderStateUnSigned        =3,//未签收
    EMOrderStateFinished          =9,//已完成
};
typedef NS_ENUM(NSInteger,EMOrderLogisticsType) {
    EMOrderLogisticsTypeUnKonwn             =0,//未知
    EMOrderLogisticsTypeExpress             =2,//快递
    EMOrderLogisticsTypeSelfPickUp          =1,//自取
};

@interface EMOrderGoodsModel : OCBaseModel
@property(nonatomic,assign)NSInteger goodsID,orderID;
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *goodsImageUrl;
@property(nonatomic,strong)EMGoodsInfoModel *goodsInfoModel;//规格说明
@property(nonatomic,assign)NSInteger buyCount;//购买数量
@property(nonatomic,assign)CGFloat goodsPrice,discountPrice;
@property(nonatomic,strong)NSMutableArray <EMSpecModel *>*goodSpecArray;

@property (nonatomic,copy)NSString *spec;
@end

@interface EMOrderModel : OCBaseModel
@property(nonatomic,assign)NSInteger orderID;
@property(nonatomic,copy)NSString *orderNumber;
@property(nonatomic,assign)EMOrderState orderState;
@property(nonatomic,copy)NSString *orderStateString;
@property(nonatomic,copy)NSString *subitTime,*payTime;
@property(nonatomic,copy)NSString *remarks;
@property (nonatomic,assign)CGFloat totalPrice;//订单不优惠的总价钱
@property (nonatomic,assign)CGFloat payPrice;//payPrice=totalPrice-promotionPrice+postage
@property (nonatomic,assign)CGFloat discountPrice;//针对这个订单，平台给优惠的价钱
@property(nonatomic,copy)NSString *pay_type;//支付的方式

@property(nonatomic,copy)NSString *receiver,*receiverTel,*receiverAddresss,*receiverWeChat;
@property(nonatomic,assign)NSInteger receiverID;


@property (nonatomic,assign)EMOrderLogisticsType logisticsType;//配送方式
@property(nonatomic,copy)NSString *logisticsTypeString;

@property (nonatomic,strong)NSMutableArray <EMOrderGoodsModel *>*goodsArray;
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
