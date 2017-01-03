//
//  EMOrderInfoCell.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderInfoCell.h"
#import "NSAttributedString+Price.h"
@interface EMOrderInfoCell ()
@property (nonatomic,strong)UILabel *orderIDLabel,*buyTimeLabel,*subtimeTimeLabel,*sendTimeLabel,*priceLabel;
@end

@implementation EMOrderInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    UIFont *font=[UIFont oc_systemFontOfSize:14];
    UIColor *color=[UIColor colorWithHexString:@"#272727"];
    _orderIDLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    _orderIDLabel.numberOfLines=1;
    [self.contentView addSubview:_orderIDLabel];
    
    _subtimeTimeLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    _subtimeTimeLabel.numberOfLines=1;
    [self.contentView addSubview:_subtimeTimeLabel];
    
    _buyTimeLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    _buyTimeLabel.numberOfLines=1;
    [self.contentView addSubview:_buyTimeLabel];
    
    _sendTimeLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    _sendTimeLabel.numberOfLines=1;
    [self.contentView addSubview:_sendTimeLabel];
    
    _priceLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    _priceLabel.numberOfLines=1;
    [self.contentView addSubview:_priceLabel];

    
    WEAKSELF
    [_orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(OCUISCALE(kEMOffX));
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(20));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX));
    }];
    [_subtimeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderIDLabel.mas_left);
        make.top.mas_equalTo(weakSelf.orderIDLabel.mas_bottom).offset(OCUISCALE(10));
        make.right.mas_equalTo(weakSelf.orderIDLabel.mas_right);
    }];
    [_buyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.subtimeTimeLabel.mas_left);
        make.top.mas_equalTo(weakSelf.subtimeTimeLabel.mas_bottom).offset(OCUISCALE(10));
        make.right.mas_equalTo(weakSelf.orderIDLabel);

    }];
//    [_sendTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.subtimeTimeLabel.mas_left);
//        make.top.mas_equalTo(weakSelf.subtimeTimeLabel.mas_top);
//        make.right.mas_equalTo(weakSelf.subtimeTimeLabel.mas_right);
//    }];
    _priceLabel.preferredMaxLayoutWidth=OCWidth-13*2;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderIDLabel.mas_left);
        make.right.mas_equalTo(weakSelf.orderIDLabel.mas_right);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-20)).priorityHigh();
        make.top.mas_equalTo(weakSelf.buyTimeLabel.mas_bottom).offset(10);
    }];
}
- (void)setOrderID:(NSString *)orderID
        submitTime:(NSString *)subTime
           payTime:(NSString *)payTime
          sendTime:(NSString *)sendTime
        totalCount:(NSInteger)totalCount
        totalPrice:(CGFloat)totoalPrice{
    
    self.orderIDLabel.text=[NSString stringWithFormat:@"订单编号：%@",orderID];
    self.subtimeTimeLabel.text=[NSString stringWithFormat:@"提交时间：%@",stringNotNil(subTime)];
    self.buyTimeLabel.text=[NSString stringWithFormat:@"支付时间：%@",stringNotNil(payTime)];
    self.sendTimeLabel.text=[NSString stringWithFormat:@"发货时间：%@",stringNotNil(sendTime)];
    UIColor *color=[UIColor colorWithHexString:@"#272727"];
    NSMutableAttributedString *priceAttrStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品，合计金额:",(long)totalCount] attributes:@{NSFontAttributeName:[UIFont oc_systemFontOfSize:OCUISCALE(13)],NSForegroundColorAttributeName:color}];
    [priceAttrStr appendAttributedString:[NSAttributedString goodsPriceAttrbuteStringWithPrice:totoalPrice]];
    
    self.priceLabel.attributedText=priceAttrStr;
}
@end
