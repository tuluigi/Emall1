//
//  EMGoodsDetailHeadView.m
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsDetailHeadView.h"

@interface EMGoodsDetailHeadView ()
@property (nonatomic,strong)UIImageView *goodsImageView;
@property (nonatomic,strong)UILabel *titleLabel,*priceLabel,*saleCountLabel;
@end

@implementation EMGoodsDetailHeadView
- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setImageArray:(NSString *)imageArray title:(NSString *)title price:(CGFloat)price saleCount:(NSInteger)count{

}
@end
