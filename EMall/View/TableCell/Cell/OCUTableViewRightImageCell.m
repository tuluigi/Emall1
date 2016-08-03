//
//  OCUTableViewRightImageCell.m
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCUTableViewRightImageCell.h"
#import "OCTableCellRightImageModel.h"
@interface OCUTableViewRightImageCell ()
@property (nonatomic,strong)UIImageView *rightImageView;
@end

@implementation OCUTableViewRightImageCell
- (void)onInitContentView{
    _rightImageView=[UIImageView new];
    _rightImageView.contentMode=UIViewContentModeScaleAspectFill;
    _rightImageView.clipsToBounds=YES;
    [self.contentView addSubview:_rightImageView];
    WEAKSELF
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-13));
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.height.mas_equalTo(make.width);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
