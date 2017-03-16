//
//  EMDiscoveryHeadView.m
//  EMall
//
//  Created by Luigi on 16/8/14.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMDiscoveryHeadView.h"

@interface EMDiscoveryHeadView ()
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation EMDiscoveryHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    self.titleLabel.text=title;
}
-(NSString *)title{
    return self.titleLabel.text;
}
- (void)onInitContentView{
    _titleLabel=[UILabel labelWithText:@"颜色" font:[UIFont oc_systemFontOfSize:14] textAlignment:NSTextAlignmentLeft];
    _titleLabel.textColor=kEM_GrayDarkTextColor;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
}
@end
