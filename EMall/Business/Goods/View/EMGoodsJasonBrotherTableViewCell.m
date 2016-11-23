//
//  EMGoodsJasonBrotherTableViewCell.m
//  EMall
//
//  Created by StarJ on 16/10/18.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsJasonBrotherTableViewCell.h"
@interface EMGoodsJasonBrotherTableViewCell ()

@property (nonatomic, strong) UIImageView *JasonImageView ;
@property (nonatomic, strong) UILabel *JasonLabel ;

@end

@implementation EMGoodsJasonBrotherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    if (self) {
        [self onInitContentView] ;
        self.accessoryType = UITableViewCellAccessoryNone ;
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    return self ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)onInitContentView
{
    _JasonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kEMOffX, 60, 60)] ;
    [self.contentView addSubview:_JasonImageView] ;
    
    _JasonLabel = [UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:14] textAlignment:NSTextAlignmentLeft] ;
    _JasonLabel.numberOfLines = 0 ;
    _JasonLabel.lineBreakMode = NSLineBreakByCharWrapping ;
    _JasonLabel.preferredMaxLayoutWidth = OCWidth - kEMOffX*2 - 70 ;
    [self.contentView addSubview:_JasonLabel] ;
    
    WEAKSELF
    [_JasonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(OCUISCALE(kEMOffX)) ;
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(5)) ;
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-5)) ;
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(140*260/360), OCUISCALE(140)));
    }] ;
    
    [_JasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.JasonImageView.mas_right).offset(OCUISCALE(10)) ;
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX)) ;
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(10)) ;
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-10)) ;
    }] ;
    
}

- (void)setJasonImage:(NSString *)imageUrl JasonStr:(NSString *)jasonStr
{
    
    [self.JasonImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:EMDefaultImage] ;
    
   // [self.JasonImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.tulip.city:82/shop_app/folder/goods/73\1476878441748.jpg"]] ;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:jasonStr] ;
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 8)] ;
    [str addAttribute:NSFontAttributeName value:[UIFont oc_systemFontOfSize:14] range:NSMakeRange(0, 8)] ;
    self.JasonLabel.attributedText = str ;
}

@end
