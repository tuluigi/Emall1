//
//  EMCareChoosePayCell.h
//  EMall
//
//  Created by StarJ on 16/11/1.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellButtonDelegate <NSObject>

- (void)selectedBtnClick:(UIButton *)button ;

@end

@interface EMCartChoosePayCell : UITableViewCell

@property(nonatomic, strong)id<CellButtonDelegate> delegate ;
@property(nonatomic, strong)UIImageView *IconImageView ;
@property(nonatomic, strong)UILabel *titleLabel ;
@property(nonatomic, strong)UILabel *remarkLabel ;
@property(nonatomic, strong)UIButton *chooseBtn ;

- (void)setIconImage:(NSString *)imageName withTitle:(NSString *)title forIndex:(NSInteger)index withFee:(NSString *)fee;

@end
