//
//  EMCartChoosePayView.h
//  EMall
//
//  Created by StarJ on 16/11/1.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMCartChoosePayCell.h"

@protocol ChoosePayViewDelegate <NSObject>

- (void)choosePayBtn:(UIButton *) button indexRow:(NSInteger) index totalPrice:(CGFloat) totalprice;

@end

@interface EMCartChoosePayView : UIView<UITableViewDelegate,UITableViewDataSource,CellButtonDelegate>
{
    CGFloat submitPrice ;
    NSString *fee ;
    NSInteger _type;
}
@property(nonatomic, strong) id<ChoosePayViewDelegate> delegate ;
@property(nonatomic, strong) UIView *backgroundView ;
@property(nonatomic, strong) UITableView *tableView ;
@property(nonatomic, strong) UIButton *submitBtn ;
@property(nonatomic, assign) CGFloat totalPrice ;
@property(nonatomic, assign) NSInteger indexPathRow ;

- (UIView *)initWithFrame:(CGRect)frame withTitle:(NSString *)title withType:(NSInteger)type ;


@end
