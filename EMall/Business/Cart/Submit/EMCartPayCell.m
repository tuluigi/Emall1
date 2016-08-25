//
//  EMCartPayCell.m
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartPayCell.h"

@interface EMCartPayCell ()
@property (nonatomic,strong)UILabel *titleLable,*cardNameLabel,*cardIDLabel,*bankNameLabel,*messageLabel;

@property (nonatomic,strong)UIImageView *logoImageView;
@end

@implementation EMCartPayCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self onInitContentView];
    }
    return self;
};
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)onInitContentView{
    UIFont *font=[UIFont oc_systemFontOfSize:15] ;
    UIColor *color=[UIColor colorWithHexString:@"#272727"];
    _titleLable=[UILabel labelWithText:@"请将货款汇入以下账户，付款之后立即发货哦~" font:font textAlignment:NSTextAlignmentLeft];
    _titleLable.textColor=color;
    _titleLable.numberOfLines=2;
    [self.contentView addSubview:_titleLable];
    
    _logoImageView=[[UIImageView alloc]  init];
    _logoImageView.image=[UIImage imageNamed:@"cart_adddress_defalt"];
    _logoImageView.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_logoImageView];
    
    _cardNameLabel=[UILabel labelWithText:@"Acc Name：HI CHI GO" font:font textAlignment:NSTextAlignmentLeft];
    _cardNameLabel.textColor=color;
    _cardIDLabel.numberOfLines=2;
    [self.contentView addSubview:_cardNameLabel];
    
    _cardIDLabel=[UILabel labelWithText:@"Bsb：083153. " font:font textAlignment:NSTextAlignmentLeft];
    _cardIDLabel.textColor=color;
    _cardIDLabel.numberOfLines=2;
    [self.contentView addSubview:_cardIDLabel];
    
    _bankNameLabel=[UILabel labelWithText:@"Acc：908925097" font:font textAlignment:NSTextAlignmentLeft];
    _bankNameLabel.textColor=color;
    _bankNameLabel.numberOfLines=2;
   
    [self.contentView addSubview:_bankNameLabel];
    _messageLabel=[UILabel labelWithText:@"提示：转账description请备注订单号后五位数字" font:font textAlignment:NSTextAlignmentLeft];
    _messageLabel.textColor=kEM_RedColro;
    _messageLabel.numberOfLines=0;
    [self.contentView addSubview:_messageLabel];
    
    
    CGFloat requirWidht=OCUISCALE(OCWidth-12-20-12-5);
     _bankNameLabel.preferredMaxLayoutWidth = requirWidht;//要是设置多行Label的话,必须设置此属性
    _cardNameLabel.preferredMaxLayoutWidth=requirWidht;
    _cardIDLabel.preferredMaxLayoutWidth=requirWidht;
    [self.bankNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.cardNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.cardIDLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    

    
    WEAKSELF
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(kEMOffX));
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(24));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX));
        
    }];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLable.mas_left);
        make.top.mas_equalTo(weakSelf.titleLable.mas_bottom).offset(OCUISCALE(14));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(20), OCUISCALE(20)));
    }];
    [_cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.logoImageView.mas_right).offset(OCUISCALE(5));
        make.top.mas_equalTo(weakSelf.logoImageView.mas_top);
        make.right.mas_equalTo(weakSelf.titleLable.mas_right);
    }];
    
    [_cardIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.cardNameLabel);
        make.top.mas_equalTo(weakSelf.cardNameLabel.mas_bottom).offset(OCUISCALE(8));
        make.right.mas_equalTo(weakSelf.cardNameLabel.mas_right);
    }];
    
    [_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.cardNameLabel);
        make.top.mas_equalTo(weakSelf.cardIDLabel.mas_bottom).offset(OCUISCALE(8));
        make.right.mas_equalTo(weakSelf.cardNameLabel.mas_right);
    }];
    _messageLabel.preferredMaxLayoutWidth=OCWidth-kEMOffX*2;
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.cardIDLabel);
        make.left.mas_equalTo(weakSelf.logoImageView.mas_left);
        make.top.mas_equalTo(weakSelf.bankNameLabel.mas_bottom).offset(OCUISCALE(15));
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-40));
    }];
    
}
- (void)setPayCartName:(NSString *)userName cartID:(NSString *)cartID bankName:(NSString *)bankName{
    self.cardNameLabel.text=[NSString stringWithFormat:@"Acc Name：%@",userName];
    self.cardIDLabel.text=[NSString stringWithFormat:@"BSB：%@",cartID];
    self.bankNameLabel.text=[NSString stringWithFormat:@"ACC：%@",bankName];
}
@end
