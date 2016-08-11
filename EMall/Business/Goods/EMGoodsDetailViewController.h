//
//  EMGoodsDetailViewController.h
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"
@class  EMGoodsModel;
@interface EMGoodsDetailViewController : OCBaseTableViewController
- (instancetype)initWithGoodsID:(NSInteger )goodsID;
- (instancetype)initWithGoodsModel:(EMGoodsModel * )goodsModel;
@end
