//
//  EMGoodsListCell.m
//  EMall
//
//  Created by Luigi on 16/8/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsListCell.h"
#import "EMGoodsItemView.h"

@interface EMGoodsListCell ()
@property (nonatomic,strong)EMGoodsItemView *goodsItemView;
@end

@implementation EMGoodsListCell
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    [self.contentView addSubview:self.goodsItemView];
    [self.goodsItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (EMGoodsItemView *)goodsItemView{
    if (nil==_goodsItemView) {
        _goodsItemView=[[EMGoodsItemView alloc]  init];
    }
    return _goodsItemView;
}
@end
