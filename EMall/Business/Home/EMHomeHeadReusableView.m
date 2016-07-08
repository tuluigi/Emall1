//
//  EMHomeHeadReusableView.m
//  EMall
//
//  Created by Luigi on 16/7/4.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeHeadReusableView.h"

@interface EMHomeHeadReusableView ()
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UIButton *moreButton;
@end

@implementation EMHomeHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)onInitContentView{
    _titleLable=[UILabel labelWithText:@"" font:[UIFont oc_boldSystemFontOfSize:12] textAlignment:NSTextAlignmentLeft];
    [self addSubview:_titleLable];
    
    _moreButton=[UIButton buttonWithTitle:@"" titleColor:nil font:nil];
    [self addSubview:_moreButton];
}


@end
