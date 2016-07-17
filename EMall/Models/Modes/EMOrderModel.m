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
#define EMOrderStateUnCommentString         @"待评论"
#define EMOrderStateCanceledString         @"已取消"
@implementation EMOrderModel

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
        case EMOrderStateUnComment:{
            stateString=EMOrderStateUnCommentString;
        }break;
            
        default:
            break;
    }
    return stateString;
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
    EMOrderStateModel *stateModel3=[EMOrderStateModel orderStateModelWithState:EMOrderStateUnComment name:EMOrderStateUnCommentString iconName:@"order_comment"];
    
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
    }else if ([stateName isEqualToString:EMOrderStateUnCommentString]){
        state=EMOrderStateUnComment;
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