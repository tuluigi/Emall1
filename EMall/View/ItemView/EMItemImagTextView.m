//
//  EMItemImagTextView.m
//  EMall
//
//  Created by Luigi on 16/8/18.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMItemImagTextView.h"

@implementation EMItemImagTextView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    _iconImageView=[[UIImageView alloc] init];
    [self addSubview:_iconImageView];
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(11)] textColor:ColorHexString(@"#5d5c5c") textAlignment:NSTextAlignmentCenter];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.numberOfLines=1;
    [self addSubview:_nameLabel];
    
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(OCUISCALE(20), OCUISCALE(20)));
        make.bottom.mas_equalTo(weakSelf.nameLabel.mas_top).offset(-10);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_lessThanOrEqualTo(OCUISCALE(20));
        make.width.mas_equalTo(weakSelf.mas_width);
        make.centerX.mas_equalTo(weakSelf.iconImageView);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-10);
    }];
}
@end
