//
//  EMOrderInfoCell.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderInfoCell.h"

@interface EMOrderInfoCell ()
@property (nonatomic,strong)UILabel *orderIDLabel,*buyTimeLabel,*subtimeTimeLabel,*sendTimeLabel;
@end

@implementation EMOrderInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (void)onInitContentView{
    UIFont *font=[UIFont oc_systemFontOfSize:13];
    UIColor *color=[UIColor colorWithHexString:@"#272727"];
    _orderIDLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_orderIDLabel];
    
    _subtimeTimeLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_subtimeTimeLabel];
    
    _buyTimeLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_buyTimeLabel];
    
    _sendTimeLabel=[UILabel labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_sendTimeLabel];
    
    WEAKSELF
    [_orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(OCUISCALE(13));
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(20));
        make.right.mas_equalTo(weakSelf.contentView.mas_centerX);
    }];
    [_subtimeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.top.mas_equalTo(weakSelf.orderIDLabel.mas_top);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-13));
    }];
    [_buyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderIDLabel.mas_left);
        make.top.mas_equalTo(weakSelf.orderIDLabel.mas_bottom).offset(OCUISCALE(10));
        make.right.mas_equalTo(weakSelf.orderIDLabel);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-20));
    }];
    [_sendTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.subtimeTimeLabel.mas_left);
        make.top.mas_equalTo(weakSelf.subtimeTimeLabel.mas_top);
        make.right.mas_equalTo(weakSelf.subtimeTimeLabel.mas_right);
    }];
}
- (void)setOrderID:(NSString *)orderID
        submitTime:(NSString *)subTime
           payTime:(NSString *)payTime
          sendTime:(NSString *)sendTime{
    self.orderIDLabel.text=[NSString stringWithFormat:@"订单编号：%@",orderID];
    self.subtimeTimeLabel.text=[NSString stringWithFormat:@"提交时间：%@",subTime];
    self.buyTimeLabel.text=[NSString stringWithFormat:@"支付时间：%@",payTime];
    self.sendTimeLabel.text=[NSString stringWithFormat:@"发货时间：%@",sendTime];
}
@end
