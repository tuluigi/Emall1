//
//  EMShoppingAddressAddController.h
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"
@class EMShopAddressModel;

@protocol EMShoppingAddressAddControllerDelegate <NSObject>

- (void)shoppingAddressAddOrEditControllerDidShopingAddressChanged:(EMShopAddressModel *)shopAddress;

@end

@interface EMShoppingAddressAddController : OCBaseTableViewController
+(EMShoppingAddressAddController *)shoppingAddrssControllerWithAddressModel:(EMShopAddressModel *)addressModel;
@property(nonatomic,weak)id<EMShoppingAddressAddControllerDelegate>delegate;
@end
