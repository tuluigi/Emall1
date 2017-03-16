//
//  EMOrderModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderModel.h"
#define EMOrderStateUnPaiedString           @"待付款"
#define EMOrderStateUnDeliveredString       @"待发货"
#define EMOrderStateUnSignedString           @"待签收"
#define EMOrderStateFinishedString         @"已完成"
#define EMOrderStateCanceledString         @"已取消"
@implementation EMOrderModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"orderID":@"id",
             @"orderNumber":@"serial_number",
             @"orderState":@"state",
             @"subitTime":@"create_time",
             @"payTime":@"pay_time",
             @"pay_type":@"pay_type",
             @"remarks":@"remark",
             @"totalPrice":@"total_amount",
             @"payPrice":@"actual_pay_amounts",
             @"discountPrice":@"discount_amount",
             @"receiver":@"addressee",
             @"receiverTel":@"telephone",
             @"receiverAddresss":@"address_detail",
             @"receiverID":@"mid",
             @"logisticsTypeString":@"logistics_type",
             @"goodsArray":@"detail",
             @"receiverWeChat":@"webchat"};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"goodsArray"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSArray *array;
            if ([value isKindOfClass:[NSArray class]]) {
                array = [MTLJSONAdapter modelsOfClass:[EMOrderGoodsModel class] fromJSONArray:value error:error];
            }
            return array;
        }];
    }else{
        return nil;
    }
}
- (NSString *)orderStateString{
    NSString *stateString=@"";
    switch (_orderState) {
        case EMOrderStateUnPaid:
            stateString=EMOrderStateUnPaiedString;
            break;
        case EMOrderStateCanceled:
            stateString=EMOrderStateCanceledString;
            break;
        case EMOrderStateUnDelivered:{
            stateString=EMOrderStateUnDeliveredString;
        }break;
        case EMOrderStateUnSigned:{
            stateString=EMOrderStateUnSignedString;
        }break;
        case EMOrderStateFinished:{
            stateString=EMOrderStateFinishedString;
        }break;
            
        default:
            break;
    }
    return stateString;
}
@end

@implementation EMOrderGoodsModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"goodsID":@"gid",
             @"orderID":@"oid",
             @"goodsName":@"title",
             @"goodsImageUrl":@"picture",
             @"buyCount":@"quantity",
             @"goodsPrice":@"amount",
             @"discountPrice":@"discount_amount",
             @"goodSpecArray":@"spec",};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"goodSpecArray"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSArray *array;
            if ([value isKindOfClass:[NSArray class]]) {
                array = [MTLJSONAdapter modelsOfClass:[EMSpecModel class] fromJSONArray:value error:error];
            }
            return array;
        }];
    }else{
        return nil;
    }
}
- (NSString *)spec{
    if ([NSString isNilOrEmptyForString:_spec]) {
        for (EMSpecModel *model in self.goodSpecArray) {
            _spec=[NSString stringWithFormat:@"%@ %@",stringNotNil(_spec),stringNotNil(model.name)];
            _spec=[_spec stringByAppendingString:model.name];
        }
        _spec=[_spec stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return _spec;
}
@end


@implementation EMOrderStateModel


+ (EMOrderStateModel *)orderStateModelWithState:(NSInteger)state name:(NSString *)name iconName:(NSString *)iconName{
    EMOrderStateModel *stateModel=[[EMOrderStateModel alloc]  init];
    stateModel.state=state;
    stateModel.stateName=name;
    stateModel.icomName=iconName;
    stateModel.badgeNumber=0;
    return stateModel;
}
+ (NSArray *)orderStateModelArray{
    EMOrderStateModel *stateModel0=[EMOrderStateModel orderStateModelWithState:EMOrderStateUnPaid name:EMOrderStateUnPaiedString iconName:@"order_unpaied"];
    EMOrderStateModel *stateModel1=[EMOrderStateModel orderStateModelWithState:EMOrderStateUnDelivered name:EMOrderStateUnDeliveredString iconName:@"order_delivered"];
    EMOrderStateModel *stateModel2=[EMOrderStateModel orderStateModelWithState:EMOrderStateUnSigned name:EMOrderStateUnSignedString iconName:@"order_sign"];
    EMOrderStateModel *stateModel3=[EMOrderStateModel orderStateModelWithState:EMOrderStateFinished name:EMOrderStateFinishedString iconName:@"order_comment"];
    
   NSArray *orderStateArry=[NSArray arrayWithObjects:stateModel0,stateModel1,stateModel2,stateModel3, nil];
    return orderStateArry;
}
+ (EMOrderState)orderStateWithStateName:(NSString *)stateName{
    EMOrderState state=EMOrderStateNone;
    if ([stateName isEqualToString:EMOrderStateUnPaiedString]) {
        state=EMOrderStateUnPaid;
    }else if ([stateName isEqualToString:EMOrderStateUnSignedString]){
        state=EMOrderStateUnSigned;
    }else if ([stateName isEqualToString:EMOrderStateUnDeliveredString]){
        state=EMOrderStateUnDelivered;
    }else if ([stateName isEqualToString:EMOrderStateFinishedString]){
        state=EMOrderStateFinished;
    }else if ([stateName isEqualToString:EMOrderStateCanceledString]){
        state=EMOrderStateCanceled;
    }
    return state;
}
@end

@implementation EMOrderDetialModel

//+ (NSDictionary *)JSONKeyPathsByPropertyKey{
//    return {@"":@""};
//}

@end
