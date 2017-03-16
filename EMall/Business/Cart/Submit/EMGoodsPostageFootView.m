//
//  EMGoodsPostageFootView.m
//  EMall
//
//  Created by Luigi on 16/8/19.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsPostageFootView.h"

@interface EMGoodsPostageFootView ()
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation EMGoodsPostageFootView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel=[UILabel labelWithText:@"配送费：提交订单后,联系微信客服确认\n" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentRight];

        _titleLabel.textColor=kEM_RedColro;
        _titleLabel.tag=1000;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, kEMOffX, 5, kEMOffX));
        }];
    }
    return self;
}
-(void)setLogisticType:(EMOrderLogisticsType)logisticType{
    _logisticType=logisticType;
    if (_logisticType==EMOrderLogisticsTypeExpress) {
        self.titleLabel.text=@"配送费：提交订单后,联系微信客服确认";
    }else if (_logisticType==EMOrderLogisticsTypeSelfPickUp){
        self.titleLabel.text=@"自取时间地址：提交订单后，联系微信客服确认";
    }else{
        self.titleLabel.text=@"";
    }
}
@end
