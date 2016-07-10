//
//  OCUTableViewButtonCell.m
//  OpenCourse
//
//  Created by Luigi on 15/11/26.
//
//

#import "OCUTableViewButtonCell.h"
#import "OCTableCellButtonModel.h"
@interface OCUTableViewButtonCell ()
//@property(nonatomic,strong,readwrite)UIButton *cellButton;
@property(nonatomic,strong)UILabel *cellLable;
@end
@implementation OCUTableViewButtonCell

-(void)onInitContentView{
    [super onInitContentView];
    [self.contentView addSubview:self.cellLable];
    
    [self.cellLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

-(void)setCellModel:(OCTableCellModel *)cellModel{
    [super setCellModel:cellModel];
    self.textLabel.text=@"";
    self.imageView.image=nil;
    self.cellLable.text=cellModel.title;
//    [self.cellButton setTitle:cellModel.title forState:UIControlStateNormal];
}
/*
-(UIButton *)cellButton{
    if (nil== _cellButton) {
        _cellButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_cellButton setTitleColor:[UIColor colorWithHexString:@"#367d46"] forState:UIControlStateNormal];
        _cellButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_cellButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    return _cellButton;
}
*/
-(UILabel *)cellLable{
    if (nil==_cellLable) {
        _cellLable=[[UILabel alloc]  init];
        _cellLable.textAlignment=NSTextAlignmentCenter;
        _cellLable.font=[UIFont oc_systemFontOfSize:16];
        _cellLable.textColor=[UIColor colorWithHexString:@"#367d46"];
    }
    return _cellLable;
}
@end
