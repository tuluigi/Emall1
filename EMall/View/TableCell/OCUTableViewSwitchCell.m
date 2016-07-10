//
//  OCUTableViewSwitchCell.m
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCUTableViewSwitchCell.h"
#import "OCTableCellSwitchModel.h"
@interface OCUTableViewSwitchCell ()
@property(nonatomic,strong)UISwitch *ocSwitch;
@end

@implementation OCUTableViewSwitchCell
-(void)onInitContentView{
    [super onInitContentView];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.ocSwitch];
    WEAKSELF
    [self.ocSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
}
-(void)setCellModel:(OCTableCellModel *)cellModel{
    [super setCellModel:cellModel];
    self.switchDelegate=[(OCTableCellSwitchModel *)cellModel switchDelegate];
    self.ocSwitch.on = [(OCTableCellSwitchModel *)cellModel on];
    WEAKSELF
    if (cellModel.accessoryType == UITableViewCellAccessoryNone) {
        [self.ocSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-15);
        }];
    }else {
        [self.ocSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.contentView.mas_right);
        }];
    }
}
-(UISwitch *)ocSwitch{
    if (nil==_ocSwitch) {
        _ocSwitch=[[UISwitch alloc]  init];
        _ocSwitch.onTintColor = [UIColor  colorWithHexString:@"#32b16c"];
        [_ocSwitch addTarget:self action:@selector(didSwitchValueChagned:) forControlEvents:UIControlEventValueChanged];
    }
    return _ocSwitch;
}
-(void)didSwitchValueChagned:(UISwitch *)sender{
    ((OCTableCellSwitchModel *)self.cellModel).on=sender.isOn;
    if (_switchDelegate&&[_switchDelegate respondsToSelector:@selector(didOCTableSwitchCellValueChanged:)]) {
        [_switchDelegate didOCTableSwitchCellValueChanged:((OCTableCellSwitchModel *)self.cellModel)];
    }
}

@end
