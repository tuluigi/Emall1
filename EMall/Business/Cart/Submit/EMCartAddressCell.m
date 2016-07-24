//
//  EMCartAddressCell.m
//  EMall
//
//  Created by Luigi on 16/7/24.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartAddressCell.h"
#import "EMShopAddressModel.h"

@interface EMCartAddressCell ()
@property (nonatomic,strong)UIImageView *icomImageView;
@property (nonatomic,strong)UILabel *nameLabel,*telLabel,*addressLable,*wechatLabel;

@end

@implementation EMCartAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    self.contentView.backgroundColor=RGB(241, 243, 240);
    
    _icomImageView=[[UIImageView alloc]  init];
    _icomImageView.image=[UIImage imageNamed:@"adddress_defalt"];
    [self.contentView addSubview:_icomImageView];
    
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont oc_boldSystemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    [self.contentView addSubview:_nameLabel];
    
    UIColor *texColor=[UIColor colorWithHexString:@"#272727"];
    
    _telLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _telLabel.textColor=texColor;
    [self.contentView addSubview:_telLabel];
    
    _wechatLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _wechatLabel.textColor=texColor;
    [self.contentView addSubview:_wechatLabel];
    
    _addressLable=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _wechatLabel.textColor=texColor;
    _addressLable.numberOfLines=2;
    [self.contentView addSubview:_addressLable];

    
    
    WEAKSELF
    [_icomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(OCUISCALE(12));
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(20));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.icomImageView.mas_right).offset(OCUISCALE(5));
        make.top.mas_equalTo(weakSelf.icomImageView.mas_top);
        make.width.mas_greaterThanOrEqualTo(OCUISCALE(100));
    }];
    [_telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLabel);
        make.left.mas_equalTo(weakSelf.nameLabel.mas_right);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-12));
    }];

    [_wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.right.mas_equalTo(weakSelf.telLabel.mas_right);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(OCUISCALE(10));
    }];
    [_addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.right.mas_equalTo(weakSelf.telLabel.mas_right);
        make.top.mas_equalTo(weakSelf.wechatLabel.mas_bottom).offset(OCUISCALE(10));
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-20));
    }];
}
- (void)setAddresssModel:(EMShopAddressModel *)addresssModel{
    _addresssModel=addresssModel;
    self.nameLabel.text=addresssModel.userName;
    self.telLabel.text=addresssModel.userTel;
    self.addressLable.text=addresssModel.detailAddresss;
    self.wechatLabel.text=[NSString stringWithFormat:@"微信号：%@",addresssModel.wechatID];
}
@end
