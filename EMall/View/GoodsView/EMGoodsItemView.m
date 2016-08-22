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
#import "NSAttributedString+Price.h"
#define EMGoodsItemViewImageWidth   (OCWidth/2.0-10)
#define EMGoodsItemViewImageHeight  ((OCWidth/2.0-10)*0.8)

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
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds=YES;
    [self addSubview:_iconImageView];
    
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(13)] textColor:[UIColor colorWithHexString:@"#5d5c5c"] textAlignment:NSTextAlignmentLeft];
    _nameLabel.numberOfLines=2;
    [self addSubview:_nameLabel];
    
    
    _priceLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(13)] textColor:[UIColor colorWithHexString:@"#fd4747"] textAlignment:NSTextAlignmentLeft];
    [self addSubview:_priceLabel];
    _saleCountLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(13)] textColor:[UIColor colorWithHexString:@"#5d5c5c"] textAlignment:NSTextAlignmentRight];
    [self addSubview:_saleCountLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.mas_top);
     
        make.width.mas_equalTo(EMGoodsItemViewImageWidth);
           make.height.mas_equalTo(EMGoodsItemViewImageHeight);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(5));
        make.left.mas_equalTo(_iconImageView.mas_left).offset(5);
        make.right.mas_equalTo(_iconImageView.mas_right).offset(-5);
        
//        make.height.mas_equalTo(OCUISCALE(25));
    }];
    _nameLabel.preferredMaxLayoutWidth=EMGoodsItemViewImageWidth-10;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(OCUISCALE(10));
        make.right.mas_equalTo(weakSelf.iconImageView.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).priorityHigh();
    }];
    
    [_saleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(weakSelf.priceLabel);
        make.left.mas_equalTo(weakSelf.priceLabel.mas_right);
        make.right.mas_equalTo(weakSelf.iconImageView.mas_right);
    }];
}
- (void)setGoodsModel:(EMGoodsModel *)goodsModel{
    _goodsModel=goodsModel;
//    _goodsModel.goodsImageUrl=@"http://m.360buyimg.com/babel/s350x350_jfs/t2530/265/1340818545/115126/2823db05/56c02071N15288acb.jpg!q70.jpg";
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.goodsImageUrl] placeholderImage:EMDefaultImage];
    self.nameLabel.text=_goodsModel.goodsName;
    self.priceLabel.text=[NSString stringWithFormat:@"$%.1f",self.goodsModel.promotionPrice];
//        _priceLabel.attributedText=[NSAttributedString goodsPriceAttrbuteStringWithPrice:self.goodsModel.goodsPrice promotePrice:self.goodsModel.promotionPrice];
    self.saleCountLabel.text=[NSString stringWithFormat:@"销量：%@",[NSString tenThousandUnitString:_goodsModel.saleCount]];
}
+ (CGSize)goodsItemViewSize{
    return CGSizeMake(EMGoodsItemViewImageWidth, EMGoodsItemViewImageHeight+OCUISCALE(5+20+20+10));
}

@end
