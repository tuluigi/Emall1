//
//  EMShoppingAddressAddController.h
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"
@class EMShopAddressModel;
@interface EMShoppingAddressAddController : OCBaseTableViewController
+(EMShoppingAddressAddController *)shoppingAddrssControllerWithAddressModel:(EMShopAddressModel *)addressModel;
@end
