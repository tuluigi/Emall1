//
//  EMShopAddressListCell.h
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMShopAddressModel;
@protocol EMShopAddressListCellDelegate <NSObject>

- (void)shopAddressListCellDidEditButtonPressed:(EMShopAddressModel *)addressModel;

@end

@interface EMShopAddressListCell : UITableViewCell
@property (nonatomic,strong)EMShopAddressModel *addresssModel;
@property (nonatomic,weak)id<EMShopAddressListCellDelegate>delegate;
@end
