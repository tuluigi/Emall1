//
//  EMGoodsInfoTableViewCell.m
//  EMall
//
//  Created by Luigi on 16/7/26.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsInfoTableViewCell.h"
#import "NSAttributedString+Price.h"
#import "NSString+VideoDuration.h"
@interface EMGoodsInfoTableViewCell ()
@property (nonatomic,strong)UILabel *titleLabel,*priceLabel,*saleCountLabel;
@end

@implementation EMGoodsInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self onInitContentView];
        self.accessoryType=UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)onInitContentView{
    _titleLabel=[UILabel labelWithText:@"" font:[UIFont oc_boldSystemFontOfSize:15] textAlignment:NSTextAlignmentLeft];
    _titleLabel.textColor=[UIColor colorWithHexString:@"#272727"];
    _titleLabel.numberOfLines=0;
    _titleLabel.preferredMaxLayoutWidth=OCWidth-kEMOffX*2;
    [self.contentView addSubview:_titleLabel];
    _priceLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:14] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_priceLabel];
    
    //商品数量不显示
//    _saleCountLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
//    _saleCountLabel.textColor=[UIColor colorWithHexString:@"#5d5c5c"];
//    [self.contentView addSubview:_saleCountLabel];

    WEAKSELF
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(OCUISCALE(kEMOffX));
        make.top.mas_equalTo(weakSelf.contentView).offset(OCUISCALE(9));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX));
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(OCUISCALE(13));
        make.left.mas_equalTo(weakSelf.titleLabel);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-12)).priorityHigh();
    }];
    [_saleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.priceLabel);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX));
    }];
}
- (void)setTitle:(NSString *)title price:(CGFloat)price promotionPrice:(CGFloat)promotionPrice saleCount:(NSInteger)count{
//    self.priceLabel.attributedText=[NSAttributedString goodsPriceAttrbuteStringWithPrice:price markFontSize:13 priceInterFontSize:17 pointInterSize:13 color:[UIColor colorWithHexString:@"#FC4747"]];
    self.priceLabel.attributedText=[NSAttributedString goodsPriceAttrbuteStringWithPrice:price promotePrice:promotionPrice];
    self.saleCountLabel.text=[NSString stringWithFormat:@"销量：%@件",[NSString tenThousandUnitString:count]];
    self.titleLabel.text=title;
}
@end
