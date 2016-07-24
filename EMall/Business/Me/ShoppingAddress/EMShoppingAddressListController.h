//
//  EMShoppingAddressListController.h
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"
@class EMShopAddressModel;
@protocol EMShoppingAddressListControllerDelegate <NSObject>

- (void)shopAddressListControlerDidSelectAddress:(EMShopAddressModel *)addressModel;

@end
@interface EMShoppingAddressListController : OCBaseTableViewController
@property (nonatomic,weak)id<EMShoppingAddressListControllerDelegate>delegate;
@end
