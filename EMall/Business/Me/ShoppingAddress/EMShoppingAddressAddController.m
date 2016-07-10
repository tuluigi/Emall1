//
//  EMShoppingAddressAddController.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShoppingAddressAddController.h"

@interface EMShoppingAddressAddController ()
@property (nonatomic,strong)EMShopAddressModel *addressModel;
@end

@implementation EMShoppingAddressAddController
+(EMShoppingAddressAddController *)shoppingAddrssControllerWithAddressModel:(EMShopAddressModel *)addressModel{
    EMShoppingAddressAddController *addController=[[EMShoppingAddressAddController alloc]  init];
    addController.addressModel=addressModel;
    return addController;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    if (nil==self.addressModel) {
        self.navigationItem.title=@"添加收获地址";
    }else{
        self.navigationItem.title=@"修改收获地址";
    }
}
@end
