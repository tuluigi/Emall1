//
//  OCTableCellBadgeModel.m
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCTableCellBadgeModel.h"

@implementation OCTableCellBadgeModel
- (NSString *)reusedCellIdentifer{
    return @"OCTableCellBadgeModelIdentifier";
}
- (id)cellWithReuseIdentifer:(NSString *)identifer{
    if (nil==self.cellClassName||[self.cellClassName isEqualToString:@""]) {
        NSString *className = @"OCUTableViewBadgeCell";
        self.cellClassName= className;
    }
    return [[NSClassFromString(self.cellClassName) alloc] initWithStyle:self.tableCellStyle reuseIdentifier:identifer];

}
@end
