//
//  EMShopProvienceCityController.h
//  EMall
//
//  Created by Luigi on 16/7/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"

@protocol EMShopProvienceCityControllerDelegate <NSObject>

- (void)shopProvicenceCityControllerDidSelectProvienceID:(NSString *)provienceID
                                           provienceName:(NSString *)provienceName
                                                  cityID:(NSString *)cityID
                                                cityName:(NSString *)cityName;

@end

@interface EMShopProvienceCityController : OCBaseTableViewController
- (instancetype)initWithProvienceID:(NSString *)provienceID provienceName:(NSString *)provienceName;
@property (nonatomic,weak)id <EMShopProvienceCityControllerDelegate> delegate;
@end
