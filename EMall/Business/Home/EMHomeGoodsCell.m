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
- (void)setGoodsModel:(EMGoodsModel *)goodsModel{
    _goodsModel=goodsModel;
    self.goodsItemView.goodsModel=goodsModel;
}
+ (CGSize)homeGoodsCellSize{
    CGSize size=[EMGoodsItemView goodsItemViewSize];
    return CGSizeMake(size.width+OCUISCALE(10), size.height+OCUISCALE(10));
}
@end
