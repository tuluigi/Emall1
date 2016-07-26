//
//  EMGoodsDetialBootmView.m
//  EMall
//
//  Created by Luigi on 16/7/26.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsDetialBootmView.h"

@interface EMGoodsDetialBootmView ()
@property (nonatomic,strong)UIButton *submitButton;
@end

@implementation EMGoodsDetialBootmView
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
    self.backgroundColor=[UIColor whiteColor];
    _submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.backgroundColor=RGB(229, 26, 30);
    _submitButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    [_submitButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font=[UIFont oc_boldSystemFontOfSize:17];
    [_submitButton addTarget:self action:@selector(didSubmitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitButton];
    UIView *lineView=[UIView new];
    lineView.backgroundColor=RGB(201, 201, 201);
    [self addSubview:lineView];
    WEAKSELF
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(OCUISCALE(0.5));
    }];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(OCUISCALE(157));
    }];
}
- (void)didSubmitButtonPressed:(UIButton *)sender{
    if (_delegate&&[_delegate respondsToSelector:@selector(goodsDetialBootmViewSubmitButtonPressed)]) {
        [_delegate goodsDetialBootmViewSubmitButtonPressed];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
