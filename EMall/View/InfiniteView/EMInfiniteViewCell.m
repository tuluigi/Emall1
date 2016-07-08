//
//  EMInfiniteViewCell.m
//  EMall
//
//  Created by Luigi on 16/7/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMInfiniteViewCell.h"
#import "EMAdModel.h"
@interface EMInfiniteViewCell ()
@property (nonatomic,strong)UIImageView *iconImageView;
@end

@implementation EMInfiniteViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    _iconImageView=[[UIImageView alloc]  init];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds=YES;
    [self.contentView addSubview:_iconImageView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (void)setAdModel:(EMAdModel *)adModel{
    _adModel=adModel;
    NSString *adImageUrl=_adModel.adImageUrl;
    adImageUrl=@"http://tupian.enterdesk.com/2013/mxy/12/10/15/3.jpg";
     [_iconImageView sd_setImageWithURL:[NSURL URLWithString:adImageUrl] placeholderImage:EMDefaultImage];
}
@end
