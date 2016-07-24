//
//  EMGoodsDetailHeadView.h
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMGoodsDetailHeadView : UITableViewHeaderFooterView

- (void)setImageArray:(NSString *)imageArray title:(NSString *)title price:(CGFloat)price saleCount:(NSInteger)count;
@end
