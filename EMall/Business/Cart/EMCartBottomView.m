//
//  EMCartBottomView.m
//  EMall
//
//  Created by Luigi on 16/7/19.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartBottomView.h"
#import "NSAttributedString+Price.h"
@interface EMCartBottomView ()
@property (nonatomic,strong)UIButton *checkMarkButton;
@property (nonatomic,strong)UILabel *priceLabel,*checkMarkLabel;
@property (nonatomic,strong)UIButton *submitButton;
@property (nonatomic,strong)NSAttributedString *priceAtrr;
@property (nonatomic,assign)NSInteger  selectCount,totalCount;
@property (nonatomic,assign)CGFloat totalPrice;
@end

@implementation EMCartBottomView
-(instancetype)init{
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
    _checkMarkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_checkMarkButton setImage:[UIImage imageNamed:@"cart_check_normal"] forState:UIControlStateNormal];
    [_checkMarkButton setImage:[UIImage imageNamed:@"cart_check_select"] forState:UIControlStateSelected];
    [_checkMarkButton addTarget:self action:@selector(didCheckMarkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkMarkButton];
    
    _checkMarkLabel=[UILabel labelWithText:@"全选" font:[UIFont oc_systemFontOfSize:15] textAlignment:NSTextAlignmentLeft];
    _checkMarkLabel.textColor=[UIColor colorWithHexString:@"#272727"];
    [self addSubview:_checkMarkLabel];
    
    _priceLabel=[UILabel labelWithText:@"" font:nil textAlignment:NSTextAlignmentLeft];
    _priceLabel.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_priceLabel];
    
    _submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.backgroundColor=RGB(229, 26, 30);
    _submitButton.titleLabel.adjustsFontSizeToFitWidth=YES;
    [_submitButton setTitle:@"去结算" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font=[UIFont oc_boldSystemFontOfSize:17];
    [self addSubview:_submitButton];
    UIView *lineView=[UIView new];
    lineView.backgroundColor=RGB(201, 201, 201);
    [self addSubview:lineView];
    WEAKSELF
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(OCUISCALE(0.5));
    }];
    [_checkMarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(13));
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(15), OCUISCALE(15)));
    }];
    [_checkMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.checkMarkButton.mas_right).offset(5);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.right.mas_equalTo(weakSelf.submitButton.mas_left).offset(OCUISCALE(-5));
    }];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(weakSelf);
        make.width.mas_equalTo(OCUISCALE(104));
    }];
}

- (void)updateCartBottomWithSelectItemCount:(NSInteger)count totalItems:(NSInteger)totalItems totalPrice:(CGFloat)totalPrice{
    self.selectCount=count;
    self.totalCount=totalItems;
    self.totalPrice=totalPrice;
    
    if (count==totalItems) {
        self.checkMarkButton.selected=YES;
    }else{
        self.checkMarkButton.selected=NO;
    }
    if (self.isDelete) {
        NSString *titleStr=@"删除";
        if (count) {
            titleStr=[NSString stringWithFormat:@"%@(%ld)",titleStr,count];
        }
        [self.submitButton setTitle:titleStr forState:UIControlStateNormal];
    }else{
        NSString *titleStr=@"去结算";
        if (count) {
            titleStr=[NSString stringWithFormat:@"%@(%ld)",titleStr,count];
        }
        [self.submitButton setTitle:titleStr forState:UIControlStateNormal];
        
        UIColor *color=[UIColor colorWithHexString:@"#272727"];
        NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:@"合计金额:" attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
        [priceAttrStr appendAttributedString:[NSAttributedString goodsPriceAttrbuteStringWithPrice:totalPrice]];
        self.priceLabel.attributedText=priceAttrStr;
    }
    if (count) {
        self.submitButton.enabled=YES;
    }else{
        self.submitButton.enabled=NO;
    }
}
- (void)didCheckMarkButtonPressed:(UIButton *)sender{
    sender.selected=!sender.selected;
    if (_delegate &&[_delegate respondsToSelector:@selector(cartBottomViewDidSelectAllButtonSelected:)]) {
        [_delegate cartBottomViewDidSelectAllButtonSelected:sender.isSelected];
    }
}
- (void)didSubmitButtonPressed:(UIButton *)sender{
    if (_delegate&&[_delegate respondsToSelector:@selector(cartBottomViewSubmitButtonPressed:)]) {
        [_delegate cartBottomViewSubmitButtonPressed:self];
    }
}
- (void)setIsDelete:(BOOL)isDelete{
    _isDelete=isDelete;
    if (_isDelete) {
        self.priceLabel.hidden=YES;
    }else{
        self.priceLabel.hidden=NO;
    }
     [self updateCartBottomWithSelectItemCount:self.selectCount totalItems:self.totalCount totalPrice:self.totalPrice];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
