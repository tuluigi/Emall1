//
//  EMGoodsInfoTableViewCell.h
//  EMall
//
//  Created by Luigi on 16/7/26.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMGoodsInfoTableViewCell : UITableViewCell
- (void)setTitle:(NSString *)title price:(CGFloat)price promotionPrice:(CGFloat)promotionPrice saleCount:(NSInteger)count;
@end
