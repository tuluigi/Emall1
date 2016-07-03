//
//  EMOrderModel.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseModel.h"

typedef NS_ENUM(NSInteger,EMOrderState) {
    EMOrderStateUnPaid          ,//未付款
    EMOrderStateUnDelivered    ,//未发货
    EMOrderStateUnSigned        ,//未签收
    EMOrderStateCanceled        ,//已取消
};

@interface EMOrderModel : OCBaseModel
@property(nonatomic,copy)NSString *orderID;
@property(nonatomic,assign)EMOrderState orderState;
@property(nonatomic,copy)NSString *orderStateString;

@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *goodsImageUrl;
@property(nonatomic,assign)CGFloat totalPrice;

@end
