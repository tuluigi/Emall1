//
//  EMGoodsListCell.m
//  EMall
//
//  Created by Luigi on 16/8/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsListCell.h"
#import "EMGoodsItemView.h"
#import "EMGoodsModel.h"
@interface EMGoodsListCell ()
@property (nonatomic,strong)EMGoodsItemView *goodsItemView;
@end

@implementation EMGoodsListCell
- (instancetype)init{
    self=[self initWithFrame:CGRectZero];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    WEAKSELF
    [self.contentView addSubview:self.goodsItemView];
    [self.goodsItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
}
- (void)setGoodsModel:(EMGoodsModel *)goodsModel{
    _goodsModel=goodsModel;
    self.goodsItemView.goodsModel=goodsModel;
}

- (EMGoodsItemView *)goodsItemView{
    if (nil==_goodsItemView) {
        _goodsItemView=[[EMGoodsItemView alloc]  init];
    }
    return _goodsItemView;
}
-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size=[EMGoodsItemView goodsItemViewSize];
    size.width=OCWidth/2.0;
    size.height+=10;
    attributes.size=size;
    return attributes;
}
@end
