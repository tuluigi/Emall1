//
//  EMCareChoosePayCell.m
//  EMall
//
//  Created by StarJ on 16/11/1.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartChoosePayCell.h"

@implementation EMCartChoosePayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        [self onInitContentView] ;
        self.accessoryType = UITableViewCellAccessoryNone ;
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    return self ;
}

- (void)onInitContentView
{
    self.IconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 23, 50, 20)] ;
    [self.contentView addSubview:self.IconImageView] ;
    
    self.titleLabel = [UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:14] textAlignment:NSTextAlignmentLeft] ;
    [self.contentView addSubview:self.titleLabel] ;
    
    self.remarkLabel = [UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:12] textAlignment:NSTextAlignmentLeft] ;
    self.remarkLabel.textColor = [UIColor redColor] ;
    [self.contentView addSubview:self.remarkLabel] ;
    
    self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [_chooseBtn setImage:[UIImage imageNamed:@"cart_choose_normal"] forState:UIControlStateNormal] ;
    [_chooseBtn setImage:[UIImage imageNamed:@"cart_choose_select"] forState:UIControlStateSelected] ;
    [_chooseBtn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside] ;
    [self.contentView addSubview:self.chooseBtn] ;
    
    WEAKSELF
    [_IconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_left).offset(OCUISCALE(40)) ;
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY) ;
    }] ;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(OCUISCALE(80)) ;
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY) ;
    }] ;
    
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left) ;
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(OCUISCALE(4));
    }] ;
    
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-20)) ;
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY) ;
    }] ;
}

- (void)setIconImage:(NSString *)imageName withTitle:(NSString *)title forIndex:(NSInteger)index withFee:(NSString *)fee
{
    [self.IconImageView setImage:[UIImage imageNamed:imageName]] ;
    self.titleLabel.text = title ;
    if (index == 0)
    {
        self.remarkLabel.text = [NSString stringWithFormat:@"需要另外支付$%@的手续费",fee] ;
    }
    else if (index == 1)
    {
        self.remarkLabel.text = @"暂不支持，敬请期待" ;
    }
}

- (void)chooseBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedBtnClick:)]) {
        [self.delegate selectedBtnClick:sender] ;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
