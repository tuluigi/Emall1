//
//  OCTableCellButtonModel.m
//  OpenCourse
//
//  Created by Luigi on 15/11/26.
//
//

#import "OCTableCellButtonModel.h"

@interface OCTableCellButtonModel ()
@property(nonatomic,strong,readwrite)UIButton *cellButton;
@end

@implementation OCTableCellButtonModel

- (NSString *)reusedCellIdentifer{
    return @"OCTableCellButtonModelIdentifier";
}
- (id)cellWithReuseIdentifer:(NSString *)identifer{
    if (nil==self.cellClassName||[self.cellClassName isEqualToString:@""]) {
        NSString *className = @"OCUTableViewButtonCell";
        self.cellClassName= className;
    }
    return [[NSClassFromString(self.cellClassName) alloc] initWithStyle:self.tableCellStyle reuseIdentifier:identifer];
}
@end
