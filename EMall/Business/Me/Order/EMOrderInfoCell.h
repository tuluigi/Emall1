//
//  EMOrderInfoCell.h
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMOrderInfoCell : UITableViewCell
- (void)setOrderID:(NSString *)orderID
        submitTime:(NSString *)subTime
           payTime:(NSString *)payTime
          sendTime:(NSString *)sendTime
        totalCount:(NSInteger)totalCount
        totalPrice:(CGFloat)totoalPrice;
@end
