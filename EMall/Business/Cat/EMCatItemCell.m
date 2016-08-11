//
//  EMCatItemCell.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCatItemCell.h"
#import "EMCatModel.h"
@interface EMCatItemCell ()
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation EMCatItemCell
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    
    _iconImageView=[[UIImageView alloc]  init];
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentCenter];
    _titleLabel.textColor=kEM_LightDarkTextColor;
    [self.contentView addSubview:_titleLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY).offset(-15);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(40), OCUISCALE(40)));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom);
    }];
}
- (void)setCatModel:(EMCatModel *)catModel{
    _catModel=catModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_catModel.catImageUrl] placeholderImage:EMDefaultImage];
    _titleLabel.text=_catModel.catName;
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    attributes.size=CGSizeMake(OCUISCALE(60), OCUISCALE(60));
    return attributes;
}
@end
