//
//  EMOrderModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderModel.h"

@implementation EMOrderModel

- (NSString *)orderStateString{
    NSString *stateString=@"";
    switch (_orderState) {
        case EMOrderStateUnPaid:
            stateString=@"未付款";
            break;
        case EMOrderStateCanceled:
            stateString=@"已取消";
            break;
        case EMOrderStateUnDelivered:{
            stateString=@"已发送";
        }break;
        case EMOrderStateUnSigned:{
            stateString=@"已签收";
        }break;
        case EMOrderStateUnComment:{
            stateString=@"已评论";
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

@end