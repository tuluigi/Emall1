//
//  OCTableCellSwitchModel.m
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCTableCellSwitchModel.h"


@implementation OCTableCellSwitchModel
- (NSString *)reusedCellIdentifer{
    return @"OOCTableCellSwitchModelIdentifier";
}


- (id)cellWithReuseIdentifer:(NSString *)identifer{
    if (nil==self.cellClassName||[self.cellClassName isEqualToString:@""]) {
        NSString *className = @"OCUTableViewSwitchCell";
        self.cellClassName= className;
    }
    return [[NSClassFromString(self.cellClassName) alloc] initWithStyle:self.tableCellStyle reuseIdentifier:identifer];
}


#pragma mark -delegate
-(void)didOCTableSwitchCellValueChanged:(OCTableCellSwitchModel *)cellModel{
    if (_switchDelegate&&[_switchDelegate respondsToSelector:@selector(didOCTableSwitchCellValueChanged:)]) {
        [_switchDelegate didOCTableSwitchCellValueChanged:cellModel];
    }
}
@end
