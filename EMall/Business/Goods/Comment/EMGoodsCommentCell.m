//
//  EMGoodsCommentCell.m
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsCommentCell.h"
#import "EMGoodsCommentModel.h"

@interface EMGoodsCommentCell ()
@property(nonatomic,strong)UIImageView *avatarImageView;
@property (nonatomic,strong)UILabel *nameLabel,*levelLabel,*contentLabel,*timeLabel;
@end

@implementation EMGoodsCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self onInitContentView];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryNone;
    }
    return self;
}
- (void)onInitContentView{
    _avatarImageView=[[UIImageView alloc]  init];
    [self.contentView addSubview:_avatarImageView];
    
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:15] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_nameLabel];
    
    _levelLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:14] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_levelLabel];
    _contentLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_contentLabel];
    _timeLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeLabel];
    
    WEAKSELF
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(weakSelf.contentView).offset(kEMOffX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(40), OCUISCALE(40)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.avatarImageView);
        make.left.mas_equalTo(weakSelf.avatarImageView.mas_right).offset(OCUISCALE(10));
    }];
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImageView.mas_left);
        make.top.mas_equalTo(weakSelf.avatarImageView.mas_bottom).offset(OCUISCALE(5));
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImageView.mas_left);
        make.top.mas_equalTo(weakSelf.levelLabel.mas_bottom).offset(OCUISCALE(5));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX ));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImageView.mas_left);
        make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(OCUISCALE(5));
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-10));
    }];
}
- (void)setGoodsCommentModel:(EMGoodsCommentModel *)goodsCommentModel{
    _goodsCommentModel=goodsCommentModel;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_goodsCommentModel.userAvatar] placeholderImage:EMDefaultImage];
    [self.nameLabel setText:_goodsCommentModel.nickName];
    self.levelLabel.text=[NSString stringWithFormat:@"评价：%@",_goodsCommentModel.levelString ];
    self.contentLabel.text=_goodsCommentModel.content;
    self.timeLabel.text=@"";
}
@end