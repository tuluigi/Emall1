//
//  OCUTableViewTextViewCell.m
//  EMall
//
//  Created by Luigi on 16/7/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCUTableViewTextViewCell.h"
#import "OCTableCellTextViewModel.h"
@interface OCUTableViewTextViewCell ()<UITextViewDelegate>
@property (nonatomic,strong,readwrite)UITextView *textView;
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
//    self.textView.placeholder=textViewModel.placeHoleder;
    self.textView.text=textViewModel.inputText;
}
-(UITextView *)textView{
    if (nil==_textView) {
        _textView=[[UITextView alloc]  init];
        _textView.delegate=self;
    }
    return _textView;
}
- (void)textViewDidChange:(UITextView *)textView{
    [(OCTableCellTextViewModel *)(self.cellModel) setInputText:textView.text];

}
@end
