//
//  EMCartListCell.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartListCell.h"
#import "EMShopCartModel.h"
@interface EMCartListCell ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIImageView *goodsImageView;
@property (nonatomic,strong)UILabel *goodsNameLabel;
@property (nonatomic,strong)UILabel *descLabel,*priceLabel;//规格数量
@property (nonatomic,strong)UITextField *countTextField;
@end

@implementation EMCartListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType=UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellAccessoryNone;
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
    
    
    _countTextField=[[UITextField alloc]  init];
    _countTextField.layer.borderColor=[[UIColor colorWithHexString:@"#e5e5e5"] CGColor];
    _countTextField.layer.borderWidth=0.8;
       [self.bgView addSubview:_countTextField];
    UIButton *minusButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton setTitleColor:color forState:UIControlStateNormal];
    minusButton.layer.borderColor=[[UIColor colorWithHexString:@"#e5e5e5"] CGColor];
    minusButton.layer.borderWidth=0.5;
    _countTextField.leftView=minusButton;
    _countTextField.leftViewMode=UITextFieldViewModeAlways;
    
    UIButton *plusButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setTitle:@"+" forState:UIControlStateNormal];
    [plusButton setTitleColor:color forState:UIControlStateNormal];
    plusButton.layer.borderColor=[[UIColor colorWithHexString:@"#e5e5e5"] CGColor];
    plusButton.layer.borderWidth=0.8;
    _countTextField.rightView=plusButton;
    _countTextField.rightViewMode=UITextFieldViewModeAlways;
    
    
 
    
    _descLabel=[UILabel labelWithText:@"" font:font textColor:[UIColor colorWithHexString:@"#949090"] textAlignment:NSTextAlignmentLeft];
    [_bgView addSubview:_descLabel];
    
    
    _priceLabel=[[UILabel alloc]  init];
    _priceLabel.textColor=RGB(227, 0, 0);
    _priceLabel.textAlignment=NSTextAlignmentRight;
    [_bgView addSubview:_priceLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, OCUISCALE(10), 0));
    }];
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bgView.mas_left).offset(OCUISCALE(12));
        make.top.mas_equalTo(weakSelf.bgView.mas_top).offset(OCUISCALE(14));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(92), OCUISCALE(65)));
        make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom).offset(OCUISCALE(-14)).priorityHigh();
    }];
    [_countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.goodsImageView);
        make.right.mas_equalTo(weakSelf.bgView.mas_right).offset(OCUISCALE(-12))
        ;
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(52), OCUISCALE(18)));
    }];
    
    [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.goodsImageView);
        make.left.mas_equalTo(weakSelf.goodsImageView.mas_right).offset(OCUISCALE(5));
        make.right.mas_equalTo(weakSelf.countTextField.mas_left).offset(OCUISCALE(-5));
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.goodsNameLabel);
        make.bottom.mas_equalTo(weakSelf.goodsImageView.mas_bottom);
//        make.top.mas_equalTo(weakSelf.goodsNameLabel.mas_bottom).offset(OCUISCALE(15));
        make.right.mas_lessThanOrEqualTo(weakSelf.goodsNameLabel.mas_right).priorityHigh();
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.countTextField);
        make.top.mas_equalTo(weakSelf.descLabel);
//        make.left.mas_offset(weakSelf.descLabel.mas_right);
    }];
}
- (void)setShopCartModel:(EMShopCartModel *)shopCartModel{
    _shopCartModel=shopCartModel;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:_shopCartModel.goodsImageUrl] placeholderImage:EMDefaultImage];
    self.goodsNameLabel.text=_shopCartModel.goodsName;
    self.descLabel.text=[NSString stringWithFormat:@"%@  %ld件",_shopCartModel.spec,_shopCartModel.buyCount];
    
    self.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",_shopCartModel.goodsPrice];
}
@end
