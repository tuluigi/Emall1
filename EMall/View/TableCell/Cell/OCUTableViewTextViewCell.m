//
//  OCUTableViewTextViewCell.m
//  EMall
//
//  Created by Luigi on 16/7/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCUTableViewTextViewCell.h"
#import "OCTableCellTextViewModel.h"
#import "UIPlaceHolderTextView.h"
@interface OCUTableViewTextViewCell ()<UITextViewDelegate>
@property (nonatomic,strong,readwrite)UIPlaceHolderTextView *textView;
@end

@implementation OCUTableViewTextViewCell
- (void)onInitContentView{
    [super onInitContentView];
    [self.contentView addSubview:self.textView];
    CGFloat paddig =OCUISCALE(10);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(paddig, paddig, paddig, paddig));
    }];
}
-(void)setCellModel:(OCTableCellModel *)cellModel{
    [super setCellModel:cellModel];
    OCTableCellTextViewModel *textViewModel = (OCTableCellTextViewModel *)cellModel;
    self.textView.placeholder=textViewModel.placeHoleder;
    self.textView.text=textViewModel.inputText;
}
-(UIPlaceHolderTextView *)textView{
    if (nil==_textView) {
        _textView=[[UIPlaceHolderTextView alloc]  init];
        _textView.delegate=self;
        _textView.layer.borderWidth=0.5;
        _textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _textView.layer.cornerRadius=3;
        _textView.layer.masksToBounds=YES;
    }
    return _textView;
}
- (void)textViewDidChange:(UITextView *)textView{
    [(OCTableCellTextViewModel *)(self.cellModel) setInputText:textView.text];

}
@end
