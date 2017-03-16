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
    //self.backgroundColor = [UIColor redColor] ;
    UIFont *font=[UIFont oc_systemFontOfSize:15] ;
    UIColor *color=[UIColor colorWithHexString:@"#272727"];
    _titleLable=[UILabel labelWithText:@"请转账汇款截图给客服，联系发货，谢谢光顾" font:font textAlignment:NSTextAlignmentLeft];
    _titleLable.textColor=color;
    _titleLable.numberOfLines=2;
    [self.contentView addSubview:_titleLable];
    
    _messageLabel=[UILabel labelWithText:@"提示：转账description请备注订单号后五位数字" font:font textAlignment:NSTextAlignmentLeft];
    _messageLabel.textColor=kEM_RedColro;
    _messageLabel.numberOfLines=2;
    [self.contentView addSubview:_messageLabel];
    
    _logoImageView=[[UIImageView alloc]  init];
//    _logoImageView.image=[UIImage imageNamed:@"cart_adddress_defalt"];
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
    
    
    CGFloat requirWidht=OCUISCALE(OCWidth-12-20-12-5);
     _bankNameLabel.preferredMaxLayoutWidth = requirWidht;//要是设置多行Label的话,必须设置此属性
    _cardNameLabel.preferredMaxLayoutWidth=requirWidht;
    _cardIDLabel.preferredMaxLayoutWidth=requirWidht;
    [self.bankNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.cardNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.cardIDLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    

    
//    WEAKSELF
//    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(kEMOffX));
//        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(14));
//        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX));
//        
//    }];
//    
//    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.titleLable.mas_left);
//        make.top.mas_equalTo(weakSelf.titleLable.mas_bottom).offset(OCUISCALE(14));
//        make.size.mas_equalTo(CGSizeMake(OCUISCALE(20), OCUISCALE(20)));
//    }];
//    [_cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.logoImageView.mas_right).offset(OCUISCALE(5));
//        make.top.mas_equalTo(weakSelf.logoImageView.mas_top);
//        make.right.mas_equalTo(weakSelf.titleLable.mas_right);
//    }];
//    
//    [_cardIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.cardNameLabel);
//        make.top.mas_equalTo(weakSelf.cardNameLabel.mas_bottom).offset(OCUISCALE(8));
//        make.right.mas_equalTo(weakSelf.cardNameLabel.mas_right);
//    }];
//    
//    [_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.cardNameLabel);
//        make.top.mas_equalTo(weakSelf.cardIDLabel.mas_bottom).offset(OCUISCALE(8));
//        make.right.mas_equalTo(weakSelf.cardNameLabel.mas_right);
//    }];
//    //_messageLabel.preferredMaxLayoutWidth=OCWidth-kEMOffX*2;
//    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(weakSelf.cardIDLabel);
//        make.left.mas_equalTo(weakSelf.logoImageView.mas_left);
//        make.top.mas_equalTo(weakSelf.bankNameLabel.mas_bottom).offset(OCUISCALE(15));
//        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-40));
//    }];
    
}
- (void)setPayCartName:(NSString *)userName cartID:(NSString *)cartID bankName:(NSString *)bankName titleLabel:(NSString *)titleLabel index:(NSInteger) index{
    WEAKSELF
    if (index == 1) {
        self.titleLable.text = @"联系客服微信hichigo1009，转账付款，谢谢惠顾" ;
        self.messageLabel.text = @"提示：微信支付，请备注订单后五位数字" ;
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(kEMOffX));
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(14));
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX));
            
        }];
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(kEMOffX));
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-14));
        }] ;

    }else{
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(kEMOffX));
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(14));
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
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(weakSelf.cardIDLabel);
            make.left.mas_equalTo(weakSelf.logoImageView.mas_left);
//            make.top.mas_equalTo(weakSelf.bankNameLabel.mas_bottom).offset(OCUISCALE(15));
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-14));
        }];
        if (index == 0 ) {
            self.titleLable.text = titleLabel ;
        }else
        {
            self.titleLable.text = @"请转账汇款截图给客服，联系发货，谢谢光顾" ;
        }
        self.logoImageView.image=[UIImage imageNamed:@"cart_adddress_defalt"];
        self.messageLabel.text = @"提示：转账description请备注订单号后五位数字" ;
        self.cardNameLabel.text=[NSString stringWithFormat:@"Acc Name：%@",userName] ;
        self.cardIDLabel.text=[NSString stringWithFormat:@"BSB：%@",cartID] ;
        self.bankNameLabel.text=[NSString stringWithFormat:@"ACC：%@",bankName];
    }
    
    
    
//    if (index == 0) {
//        self.titleLable.text = titleLabel ;
//        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(weakSelf.cardIDLabel);
//            make.left.mas_equalTo(weakSelf.logoImageView.mas_left);
//            make.top.mas_equalTo(weakSelf.bankNameLabel.mas_bottom).offset(OCUISCALE(15));
//            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-40));
//            }];
//
//    }
//    else if (index == 1)
//    {
//        self.titleLable.text = @"联系客服微信hichigo1009，转账付款，谢谢惠顾" ;
//        self.messageLabel.text = @"提示：微信支付，请备注订单后五位数字" ;
//        self.cardNameLabel.text = nil ;
//        self.bankNameLabel.text = nil ;
//        [self.logoImageView removeFromSuperview] ;
////        [self.cardNameLabel removeFromSuperview] ;
////        [self.bankNameLabel removeFromSuperview] ;
//
//        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(kEMOffX));
//           // make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-kEMOffX));
//           // make.top.mas_equalTo(weakSelf.titleLable.mas_bottom).offset(OCUISCALE(15));
//           make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-14));
//        }] ;
//    }else{
//        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(weakSelf.cardIDLabel);
//            make.left.mas_equalTo(weakSelf.logoImageView.mas_left);
//            make.top.mas_equalTo(weakSelf.bankNameLabel.mas_bottom).offset(OCUISCALE(15));
//            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-40));
//        }];
//    }
//    self.cardNameLabel.text=[NSString stringWithFormat:@"Acc Name：%@",userName] ;
//    self.cardIDLabel.text=[NSString stringWithFormat:@"BSB：%@",cartID] ;
//    self.bankNameLabel.text=[NSString stringWithFormat:@"ACC：%@",bankName];
}
@end
