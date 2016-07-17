//
//  EMOrderListCell.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderListCell.h"
#import "EMOrderModel.h"
@interface EMOrderListCell ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIImageView *goodsImageView,*checkImageView;

@property (nonatomic,strong)UILabel *goodsNameLabel,*countLabel,*priceLabel;
@property (nonatomic,strong)UIButton *reBuyButton,*detailButton;

@end

@implementation EMOrderListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryNone;
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    self.contentView.backgroundColor=RGB(241, 243, 240);
    _bgView=[UIView new];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    WEAKSELF
    _goodsImageView=[[UIImageView alloc] init];
    [_bgView addSubview:_goodsImageView];
    UIFont *font=[UIFont oc_systemFontOfSize:13];
    UIColor *color=[UIColor colorWithHexString:@"#272727"];
    _goodsNameLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    _goodsNameLabel.numberOfLines=2;
    [_bgView addSubview:_goodsNameLabel];
    
    _checkImageView=[UIImageView new];
    _checkImageView.image=[UIImage imageNamed:@"arror_right"];
    [_bgView addSubview:_checkImageView];
    
    _countLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"#949090"] textAlignment:NSTextAlignmentLeft];
    [_bgView addSubview:_countLabel];
    
    UIView *lineView0=[UIView new];
    lineView0.backgroundColor=RGB(225, 225, 225);
    [_bgView addSubview:lineView0];
    
    _priceLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentRight];
    [_bgView addSubview:_priceLabel];
    
    UIView *lineView1=[UIView new];
    lineView1.backgroundColor=RGB(225, 225, 225);
    [_bgView addSubview:lineView1];

    UIColor *rebuyColor=[UIColor colorWithHexString:@"#e51e0e"];
    _reBuyButton=[UIButton buttonWithTitle:@"再次购买" titleColor:rebuyColor font:font];
    _reBuyButton.layer.cornerRadius=5.0;
    _reBuyButton.layer.masksToBounds=YES;
    _reBuyButton.layer.borderColor=[rebuyColor CGColor];
    _reBuyButton.layer.borderWidth=1.0;
    [_reBuyButton addTarget:self action:@selector(didReBuyButtonPressed ) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_reBuyButton];
    
    _detailButton=[UIButton buttonWithTitle:@"查看订单" titleColor:color font:font];
    _detailButton.layer.cornerRadius=5.0;
    _detailButton.layer.masksToBounds=YES;
    _detailButton.layer.borderColor=[color CGColor];
    _detailButton.layer.borderWidth=1.0;
    [_detailButton addTarget:self action:@selector(didCheckOrderDetailButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_detailButton];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, OCUISCALE(5), 0));
    }];
    [_goodsImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.bgView.mas_top).offset(OCUISCALE(10));
        make.left.mas_equalTo(weakSelf.bgView.mas_left).offset(OCUISCALE(13));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(100), OCUISCALE(70)));
    }];
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.goodsImageView);
        make.left.mas_equalTo(weakSelf.goodsImageView.mas_right).offset(OCUISCALE(6));
        make.width.mas_equalTo(OCUISCALE(220));
    }];
    [_checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.bgView.mas_right).offset(OCUISCALE(-13));
        make.centerY.mas_equalTo(weakSelf.goodsImageView.mas_centerY);
    }];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.goodsNameLabel);
        make.top.mas_equalTo(weakSelf.goodsNameLabel.mas_bottom).offset(OCUISCALE(10));
    }];
    [lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.bgView);
        make.top.mas_equalTo(weakSelf.goodsImageView.mas_bottom).offset(OCUISCALE(10));
        make.height.mas_equalTo(0.5);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.goodsImageView.mas_left);
        make.right.mas_equalTo(weakSelf.goodsNameLabel.mas_right);
        make.top.mas_equalTo(lineView0.mas_bottom).offset(OCUISCALE(10));
    }];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.bgView);
        make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).offset(OCUISCALE(10));
        make.height.mas_equalTo(0.5);
    }];
    [_reBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.checkImageView.mas_right);
        make.top.mas_equalTo(lineView1.mas_bottom).offset(OCUISCALE(10));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(66), OCUISCALE(21)));
        make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom).offset(OCUISCALE(-10)).priorityHigh();
    }];
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.reBuyButton);
        make.top.mas_equalTo(weakSelf.reBuyButton);
        make.right.mas_equalTo(weakSelf.reBuyButton.mas_left).offset(OCUISCALE(-12));
    }];
}

-(void)setOrderModel:(EMOrderModel *)orderModel{
    _orderModel=orderModel;
//    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:_orderModel.goodsImageUrl] placeholderImage:EMDefaultImage];
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:_orderModel.goodsImageUrl] placeholderImage:EMDefaultImage];
    self.goodsNameLabel.text=_orderModel.goodsName;
    self.countLabel.text=[NSString stringWithFormat:@"%@  %ld件",_orderModel.spec,_orderModel.buyCount];
    
    self.priceLabel.text=[NSString stringWithFormat:@"共%ld件商品，合计%.2f元",_orderModel.buyCount,((_orderModel.buyCount)*(_orderModel.goodsPrice))];
    
}

- (void)didReBuyButtonPressed{
    if (_delegate&&[_delegate respondsToSelector:@selector(orderListCellShouldReBuyThisGoods)]) {
        [_delegate orderListCellShouldReBuyThisGoods];
    }
}

- (void)didCheckOrderDetailButtonPressed{
    if (_delegate&&[_delegate respondsToSelector:@selector(orderListCellShouldCheckOrderDetail)]) {
        [_delegate orderListCellShouldCheckOrderDetail];
    }
}
@end
