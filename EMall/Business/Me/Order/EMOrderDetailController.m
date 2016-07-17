//
//  EMOrderDetailController.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderDetailController.h"
#import "EMOrderModel.h"
@interface EMOrderDetailController ()
@property (nonatomic,copy)NSString *orderID;
@property (nonatomic,strong)EMOrderModel *orderModel;
@end

@implementation EMOrderDetailController
- (instancetype)initWithOrderID:(NSString *)orderID{
    self=[super init];
    if (self) {
        self.orderID=orderID;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}
- (void)getOrderDetailWithOrderID:(NSString *)orderID{
    
}




@end
