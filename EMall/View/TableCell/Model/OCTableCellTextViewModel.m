//
//  OCTableCellTextViewModel.m
//  EMall
//
//  Created by Luigi on 16/7/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCTableCellTextViewModel.h"

@interface OCTableCellTextViewModel ()

@end

@implementation OCTableCellTextViewModel
- (NSString *)reusedCellIdentifer{
    return @"OCTableCellTextViewModelIdentifier";
}
-(UITableViewCellStyle)tableCellStyle{
    return UITableViewCellStyleDefault;
}

- (id)cellWithReuseIdentifer:(NSString *)identifer{
    if (nil==self.cellClassName||[self.cellClassName isEqualToString:@""]) {
        self.cellClassName= @"OCUTableViewTextViewCell";
    }
    return [[NSClassFromString(self.cellClassName) alloc] initWithStyle:self.tableCellStyle reuseIdentifier:identifer];
}
@end
