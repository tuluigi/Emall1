//
//  OCTableCellDetialTextModel.m
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCTableCellDetialTextModel.h"

@implementation OCTableCellDetialTextModel

-(void)onInitData{
    self.tableCellStyle=UITableViewCellStyleValue1;
}
- (NSString *)reusedCellIdentifer{
    return @"OCTableCellDetialTextModelIdentifier";
}
-(UITableViewCellStyle)tableCellStyle{
    return UITableViewCellStyleValue1;
}

- (id)cellWithReuseIdentifer:(NSString *)identifer{
    if (nil==self.cellClassName||[self.cellClassName isEqualToString:@""]) {
        self.cellClassName= @"OCUTableViewDetailTextCell";
    }
    return [[NSClassFromString(self.cellClassName) alloc] initWithStyle:self.tableCellStyle reuseIdentifier:identifer];
}
@end
