//
//  OCTableCellTextFiledModel.m
//  EMall
//
//  Created by Luigi on 16/7/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCTableCellTextFiledModel.h"

@interface OCTableCellTextFiledModel ()
@end

@implementation OCTableCellTextFiledModel
- (NSString *)reusedCellIdentifer{
    return @"OCTableCellTextFiledModelIdentifier";
}
-(UITableViewCellStyle)tableCellStyle{
    return UITableViewCellStyleDefault;
}

- (id)cellWithReuseIdentifer:(NSString *)identifer{
    if (nil==self.cellClassName||[self.cellClassName isEqualToString:@""]) {
        self.cellClassName= @"OCUTableViewTextFieldCell";
    }
    return [[NSClassFromString(self.cellClassName) alloc] initWithStyle:self.tableCellStyle reuseIdentifier:identifer];
}
@end
