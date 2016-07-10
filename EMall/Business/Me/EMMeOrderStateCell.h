//
//  EMMeOrderStateCell.h
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCUTableViewCell.h"
@class EMOrderStateModel;
@protocol EMMeOrderStateCellDelegate <NSObject>

- (void)orderStateCellDidSelectItem:(EMOrderStateModel *)stateModel;

@end

@interface EMMeOrderStateCell : OCUTableViewCell
@property (nonatomic,strong)NSArray *orderStateArry;
@property (nonatomic,weak)id <EMMeOrderStateCellDelegate>delegate;
@end
