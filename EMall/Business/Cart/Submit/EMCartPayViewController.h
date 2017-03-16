//
//  EMCartPayViewController.h
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"

@interface EMCartPayViewController : OCBaseTableViewController
- (instancetype)initWithTotalPrice:(CGFloat)totalPrice orderNum:(NSString *)orderNum titleLabel:(NSString *)titleLabel index:(NSInteger) index;
@end
