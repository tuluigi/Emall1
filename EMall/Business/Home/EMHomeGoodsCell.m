//
//  EMHomeGoodsCell.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeGoodsCell.h"
#import "EMHomeModel.h"
#import "EMGoodsItemView.h"
#import "EMGoodsModel.h"
@interface EMHomeGoodsCell ()
@property (nonatomic,strong)EMGoodsItemView *goodsItemView;
@property (nonatomic,strong) EMHomeGoodsModel *goodsModel;
@end

@implementation EMHomeGoodsCell

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}

- (void)onInitContentView{
    _goodsItemView=[[EMGoodsItemView alloc] init];
    [self.contentView addSubview:_goodsItemView];
    CGFloat padding=OCUISCALE(5);
    [_goodsItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(padding, padding, padding, padding));
    }];
}
- (void)setGoodsModel:(EMHomeGoodsModel *)goodsModel{
    _goodsModel=goodsModel;
    EMGoodsModel *model=[EMHomeGoodsCell goodsModelWithHomeGoodsModel:_goodsModel];
    self.goodsItemView.goodsModel=model;
}
+ (EMGoodsModel *)goodsModelWithHomeGoodsModel:(EMHomeGoodsModel *)homeGoods{
    EMGoodsModel *goodsModel=[[EMGoodsModel alloc]  init];
    goodsModel.goodsID=homeGoods.goodsID;
    goodsModel.goodsName=homeGoods.goodsName;
    goodsModel.goodsImageUrl=homeGoods.goodsImageUrl;
    goodsModel.goodsPrice=homeGoods.goodsPrice;
    goodsModel.saleCount=homeGoods.saleCount;
    return goodsModel;
}
- (void)setGoodsModel:(EMHomeGoodsModel *)goodsModel dataSource:(NSArray *)dataSource{
    [self setGoodsModel:goodsModel];
    NSInteger index=[dataSource indexOfObject:goodsModel];
    CGFloat padding=OCUISCALE(5);
    CGFloat width=[EMGoodsItemView goodsItemViewSize].width;
    CGFloat offx=OCWidth/2.0-padding-width;
    if (index%2) {
        [self.goodsItemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.removeExisting=YES;
            make.edges.mas_equalTo(UIEdgeInsetsMake(padding,padding , padding, offx));
        }];
    }else{
        [self.goodsItemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.removeExisting=YES;
            make.edges.mas_equalTo(UIEdgeInsetsMake(padding, offx, padding, padding));
        }];
    }
}
-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size=[self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    size.width=OCWidth/2.0;
    attributes.size=size;
    return attributes;
}
@end
