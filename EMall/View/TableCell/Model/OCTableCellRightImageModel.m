//
//  OCTableCellRightImageModel.m
//  EMall
//
//  Created by Luigi on 16/8/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCTableCellRightImageModel.h"

@implementation OCTableCellRightImageModel
- (NSString *)reusedCellIdentifer{
    return @"OCTableCellRightImageModelIdentifier";
}
-(UITableViewCellStyle)tableCellStyle{
    return UITableViewCellStyleDefault;
}

- (id)cellWithReuseIdentifer:(NSString *)identifer{
    if (nil==self.cellClassName||[self.cellClassName isEqualToString:@""]) {
        self.cellClassName= @"OCUTableViewRightImageCell";
    }
    return [[NSClassFromString(self.cellClassName) alloc] initWithStyle:self.tableCellStyle reuseIdentifier:identifer];
}
@end
