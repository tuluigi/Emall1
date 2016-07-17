//
//  EMOrderDetailAddressCell.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderDetailAddressCell.h"

@interface EMOrderDetailAddressCell ()
@property (nonatomic,strong)UIImageView *iconImageView;
@end

@implementation EMOrderDetailAddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self onInitContentView];
    }
    return self;
}

- (void)onInitContentView{
    
}
@end
