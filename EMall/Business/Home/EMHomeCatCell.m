//
//  EMHomeCatCell.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeCatCell.h"
#import "EMCatModel.h"

typedef void(^EMHomeCatItemViewSelectBlock)(EMCatModel *catModel);

@interface EMHomeCatItemView : UIView
@property (nonatomic,strong)EMCatModel *catModel;
@property (nonatomic,copy)EMHomeCatItemViewSelectBlock selectBlock;
+ (CGSize)homeCatItemViewSize;
@end
@interface EMHomeCatItemView ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *nameLabel;
@end
@implementation EMHomeCatItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    _iconImageView=[[UIImageView alloc] init];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds=YES;
    
    [self addSubview:_iconImageView];
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(12)] textColor:ColorHexString(@"#5d5c5c") textAlignment:NSTextAlignmentCenter];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.numberOfLines=1;
    [self addSubview:_nameLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(40), OCUISCALE(40)));
    }];
    _iconImageView.layer.cornerRadius=OCUISCALE(40/2.0);
    _iconImageView.layer.masksToBounds=YES;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(9));
        make.width.mas_equalTo([EMHomeCatItemView homeCatItemViewSize].width);
        make.centerX.mas_equalTo(weakSelf.iconImageView);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-10));
    }];
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
}
- (void)setCatModel:(EMCatModel *)catModel{
    _catModel=catModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_catModel.catImageUrl] placeholderImage:EMDefaultImage];
    self.nameLabel.text=_catModel.catName;
}
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture{
    if (self.selectBlock) {
        self.selectBlock(self.catModel);
    }
}


@end


@interface EMHomeCatCell ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *nameLabel;
@end

@implementation EMHomeCatCell
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    self.contentView.backgroundColor=[UIColor whiteColor];
    _iconImageView=[[UIImageView alloc] init];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFit;
    _iconImageView.clipsToBounds=YES;
    
    [self.contentView addSubview:_iconImageView];
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(12)] textColor:ColorHexString(@"#5d5c5c") textAlignment:NSTextAlignmentCenter];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.numberOfLines=1;
    [self.contentView addSubview:_nameLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _iconImageView.layer.cornerRadius=OCUISCALE(40/2.0);
    _iconImageView.layer.masksToBounds=YES;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.iconImageView);
        make.bottom.mas_equalTo(weakSelf.iconImageView.mas_bottom).offset(OCUISCALE(-5));
    }];
    _nameLabel.hidden=YES;

}
/*
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    attributes.size=CGSizeMake(OCWidth, [EMHomeCatItemView homeCatItemViewSize].height);
    return attributes;
}
 */
+ (CGSize)homeCatCellSize{
    return CGSizeMake(100, 100);
}

- (void)setCatModel:(EMCatModel *)catModel{
    _catModel=catModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_catModel.catImageUrl] placeholderImage:EMDefaultImage];
    self.nameLabel.text=_catModel.catName;
}



@end
