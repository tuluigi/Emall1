//
//  EMOrderModel.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderModel.h"

@implementation EMOrderModel

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