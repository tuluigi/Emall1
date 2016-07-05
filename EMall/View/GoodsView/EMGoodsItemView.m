//
//  EMGoodsItemView.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsItemView.h"
#import "EMGoodsModel.h"
#import "NSString+VideoDuration.h"
@interface EMGoodsItemView ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *nameLabel,*priceLabel, *saleCountLabel;
@end

@implementation EMGoodsItemView
- (instancetype)init{
    self=[super init];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    _iconImageView=[[UIImageView alloc] init];
    [self addSubview:_iconImageView];
    
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(10)] textColor:UIColorHex(@"#5d5c5c") textAlignment:NSTextAlignmentLeft];
    _nameLabel.numberOfLines=2;
    [self addSubview:_nameLabel];
    
    
    _priceLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(10)] textColor:UIColorHex(@"#fd4747") textAlignment:NSTextAlignmentLeft];
    [self addSubview:_priceLabel];
    _saleCountLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(9)] textColor:UIColorHex(@"#5d5c5c") textAlignment:NSTextAlignmentRight];
    [self addSubview:_saleCountLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(170), OCUISCALE(89)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(5));
        make.left.right.mas_equalTo(_iconImageView);
        make.height.mas_equalTo(OCUISCALE(20));
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(OCUISCALE(5));
        make.right.mas_equalTo(weakSelf.iconImageView.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
    
    [_saleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf.priceLabel);
        make.left.mas_equalTo(weakSelf.priceLabel.mas_right);
        make.right.mas_equalTo(weakSelf.iconImageView.mas_right);
    }];
}
- (void)setGoodsModel:(EMGoodsModel *)goodsModel{
    _goodsModel=goodsModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImageUrl] placeholderImage:EMDefaultImage];
    self.nameLabel.text=_goodsModel.goodsName;
    self.priceLabel.text=[NSString stringWithFormat:@"￥%.1f",_goodsModel.goodsPrice];
    self.saleCountLabel.text=[NSString stringWithFormat:@"销量：%@",[NSString tenThousandUnitString:_goodsModel.saleCount]];
}
+ (CGSize)goodsItemViewSize{
    return CGSizeMake(OCUISCALE(170), OCUISCALE(89+5+20+5+10));
}

@end
