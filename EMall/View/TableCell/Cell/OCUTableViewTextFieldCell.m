//
//  OCUTableViewTextFieldCell.m
//  EMall
//
//  Created by Luigi on 16/7/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCUTableViewTextFieldCell.h"
#import "OCTableCellTextFiledModel.h"
#import "UITextField+HiddenKeyBoardButton.h"
@interface OCUTableViewTextFieldCell ()<UITextFieldDelegate>
@property (nonatomic,strong,readwrite)UITextField *textField;

@end

@implementation OCUTableViewTextFieldCell
-(void)onInitContentView{
    [super onInitContentView];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.textField];
    WEAKSELF
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-10));
//        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.top.mas_equalTo(weakSelf.contentView.mas_top);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).mas_equalTo(OCUISCALE(100));
    }];
}

-(void)setCellModel:(OCTableCellModel *)cellModel{
    [super setCellModel:cellModel];
    OCTableCellTextFiledModel *textFileModel = (OCTableCellTextFiledModel *)cellModel;
    self.textField.placeholder=textFileModel.placeHoleder;
    self.textField.text=textFileModel.inputText;
}
- (UITextField *)textField{
    if (nil==_textField) {
        _textField=[[UITextField alloc] init];
        [_textField addHiddenKeyBoardInputAccessView];
        _textField.font=[UIFont oc_systemFontOfSize:14];
        _textField.textAlignment=NSTextAlignmentLeft;
        _textField.delegate=self;
    }
    return _textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [(OCTableCellTextFiledModel *)(self.cellModel) setInputText:textField.text];
}
@end
