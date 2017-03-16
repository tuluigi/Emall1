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
    [super onInitContentView];
    self.imageView.image=nil;
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
        make.height.mas_equalTo(_rightImageView.mas_width);
    }];
}

-(void)setCellModel:(OCTableCellModel *)cellModel{
    [super setCellModel:cellModel];
        self.imageView.image=nil;
   __block OCTableCellRightImageModel *model = (OCTableCellRightImageModel *)cellModel;
    if (model.image) {
        self.rightImageView.image=model.image;
        return;
    }
    if ([NSString isNilOrEmptyForString:model.imageUrl]) {
        self.rightImageView.image=[UIImage imageNamed:model.placeholderImageName];
    }else{
        if ([model.imageUrl hasPrefix:@"http://"]||[model.imageUrl hasPrefix:@"https://"]) {
            [_rightImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:model.placeholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                model.image=image;
            }];
        }else if ([model.imageUrl hasPrefix:NSHomeDirectory()]){
            _rightImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:model.imageUrl]]];
             model.image=_rightImageView.image;
        }else{
            _rightImageView.image=[UIImage imageNamed:model.imageUrl];
             model.image=_rightImageView.image;
        }
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
