//
//  EMGoodsDetialBootmView.m
//  EMall
//
//  Created by Luigi on 16/7/26.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsDetialBootmView.h"

static NSString *const EMGoodsDetailBottomItemViewTaped= @"EMGoodsDetailBottomItemViewTaped";
@interface EMGoodsDetailBottomItemView : UIView
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *nameLabel;

@end
@implementation EMGoodsDetailBottomItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    self.userInteractionEnabled=YES;
    _iconImageView=[[UIImageView alloc] init];
    [self addSubview:_iconImageView];
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(11)] textColor:ColorHexString(@"#5d5c5c") textAlignment:NSTextAlignmentCenter];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.numberOfLines=1;
    [self addSubview:_nameLabel];
    UITapGestureRecognizer *tapGestures=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGestures];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(5));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(20), OCUISCALE(20)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.iconImageView.mas_bottom);
        make.width.mas_equalTo(weakSelf.mas_width);
        make.centerX.mas_equalTo(weakSelf.iconImageView);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).priorityHigh();
    }];
}
- (void)handleTapGesture:(UITapGestureRecognizer *)tag{
    [[self nextResponder] routerEventName:EMGoodsDetailBottomItemViewTaped userInfo:nil];
}

@end
@interface EMGoodsDetialBootmView ()
@property (nonatomic,strong)UIButton *submitButton;
@property (nonatomic,strong)EMGoodsDetailBottomItemView *serviceItemView;
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
    
    _serviceItemView=[[EMGoodsDetailBottomItemView alloc]  init];
    _serviceItemView.nameLabel.text=@"联系客服";
    _serviceItemView.iconImageView.image=[UIImage imageNamed:@"me_service"];
    [self addSubview:_serviceItemView];
    WEAKSELF
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(OCUISCALE(0.5));
    }];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(OCUISCALE(157));
    }];
    [_serviceItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.submitButton.mas_left).offset(-OCUISCALE(20));
        make.top.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(weakSelf.serviceItemView.mas_height);
    }];
}
- (void)didSubmitButtonPressed:(UIButton *)sender{
    if (_delegate&&[_delegate respondsToSelector:@selector(goodsDetialBootmViewSubmitButtonPressed)]) {
        [_delegate goodsDetialBootmViewSubmitButtonPressed];
    }
}
- (void)routerEventName:(NSString *)event userInfo:(NSDictionary *)userInfo{
    if (event==EMGoodsDetailBottomItemViewTaped) {
        if (_delegate&&[_delegate respondsToSelector:@selector(goodsDetialBootmViewServiceItemPressed)]) {
            [_delegate goodsDetialBootmViewServiceItemPressed];
        }
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
