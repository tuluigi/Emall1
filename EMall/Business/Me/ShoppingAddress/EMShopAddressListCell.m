//
//  EMShopAddressListCell.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShopAddressListCell.h"
#import "EMShopAddressModel.h"

@interface EMShopAddressListCell ()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *nameLabel,*telLabel,*addressLable,*wechatLabel;
@property (nonatomic,strong)UIButton *editButton,*defaultButton;

@end

@implementation EMShopAddressListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    self.contentView.backgroundColor=RGB(241, 243, 240);
    _bgView=[[UIView alloc]  init];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    [_bgView addSubview:_nameLabel];
    
    _telLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:12] textAlignment:NSTextAlignmentLeft];
    [_bgView addSubview:_telLabel];
    
    _wechatLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:12] textAlignment:NSTextAlignmentLeft];
    [_bgView addSubview:_wechatLabel];
    
    _addressLable=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:12] textAlignment:NSTextAlignmentLeft];
    _addressLable.numberOfLines=2;
    [_bgView addSubview:_addressLable];
    UIView *lineView=[UIView new];
    lineView.backgroundColor=RGB(247, 247, 247);;
    [_bgView addSubview:lineView];
    
    _defaultButton=[UIButton buttonWithTitle:@"常用地址" titleColor:[UIColor redColor] font:[UIFont oc_systemFontOfSize:12]];
    [_defaultButton setImage:[UIImage imageNamed:@"test_03"] forState:UIControlStateNormal];
    [_bgView addSubview:_defaultButton];
    
    
    _editButton=[UIButton buttonWithTitle:@"修改" titleColor:ColorHexString(@"#5e5c5c") font:[UIFont oc_systemFontOfSize:12]];
    [_editButton setImage:[UIImage imageNamed:@"test_03"] forState:UIControlStateNormal];
    [_bgView addSubview:_editButton];
    
    WEAKSELF
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(weakSelf.contentView);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-10));
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, OCUISCALE(10), 0));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bgView.mas_left).offset(OCUISCALE(12));
        make.top.mas_equalTo(weakSelf.bgView.mas_top).offset(OCUISCALE(10));
        make.width.mas_greaterThanOrEqualTo(OCUISCALE(100));
    }];
    [_telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLabel);
        make.left.mas_equalTo(weakSelf.nameLabel.mas_right);
        make.width.mas_greaterThanOrEqualTo(OCUISCALE(100));
    }];
    [_defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLabel);
        make.right.mas_equalTo(weakSelf.bgView.mas_right).offset(OCUISCALE(-12));
    }];
    [_wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.right.mas_equalTo(weakSelf.bgView.mas_right).offset(OCUISCALE(-10));
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(OCUISCALE(5));
    }];
    [_addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.nameLabel.mas_left);
        make.right.mas_equalTo(weakSelf.bgView.mas_right).offset(OCUISCALE(-10));
        make.top.mas_equalTo(weakSelf.wechatLabel.mas_bottom).offset(OCUISCALE(5));
//        make.bottom.mas_equalTo(lineView.mas_top).offset(OCUISCALE(-10));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.bgView);
        make.top.mas_equalTo(weakSelf.addressLable.mas_bottom).offset(OCUISCALE(5));
        make.height.mas_equalTo(0.5);
    }];
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(OCUISCALE(5));
        make.right.mas_equalTo(weakSelf.bgView.mas_right).offset(OCUISCALE(-12));
        make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom).offset(OCUISCALE(-10)).priorityHigh();
    }];
    
}
- (void)setAddresssModel:(EMShopAddressModel *)addresssModel{
    _addresssModel=addresssModel;
    self.nameLabel.text=addresssModel.userName;
    self.telLabel.text=addresssModel.userTel;
    self.addressLable.text=addresssModel.userAddress;
    self.defaultButton.hidden=!addresssModel.isDefault;
    self.wechatLabel.text=[NSString stringWithFormat:@"微信号：%@",addresssModel.wechatID];
}
@end
