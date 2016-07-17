//
//  EMCartListCell.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartListCell.h"
#import "EMShopCartModel.h"
@interface EMCartListCell ()

@end

@implementation EMCartListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setShopCartModel:(EMShopCartModel *)shopCartModel{
    _shopCartModel=shopCartModel;
}
@end
