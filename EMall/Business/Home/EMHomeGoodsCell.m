//
//  EMHomeGoodsCell.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeGoodsCell.h"
#import "EMGoodsModel.h"
#import "EMGoodsItemView.h"
@interface EMHomeGoodsCell ()
@property (nonatomic,strong)EMGoodsItemView *goodsItemView;
@property (nonatomic,strong) EMGoodsModel *goodsModel;
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
    self.contentView.layer.borderColor=ColorHexString(@"#e2e1e1").CGColor;
    self.contentView.layer.borderWidth=0.3;
}
- (void)setGoodsModel:(EMGoodsModel *)goodsModel{
    _goodsModel=goodsModel;
    self.goodsItemView.goodsModel=goodsModel;
}
- (void)setGoodsModel:(EMGoodsModel *)goodsModel dataSource:(NSArray *)dataSource{
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
