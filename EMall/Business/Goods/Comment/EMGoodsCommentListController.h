//
//  EMGoodsCommentListController.h
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"

@interface EMGoodsCommentListController : OCBaseTableViewController
- (instancetype)initWithGoodsID:(NSInteger)goodsID star:(NSInteger)star;
- (void)setGoodsID:(NSInteger)goodsID star:(NSInteger)star;
@end
