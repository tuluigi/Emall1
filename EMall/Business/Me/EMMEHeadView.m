//
//  EMMEHeadView.m
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMEHeadView.h"

@interface EMMEHeadView ()
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLable;
@end

@implementation EMMEHeadView
- (instancetype)init{
    self=[super init];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    self.backgroundColor=RGB(220, 29, 29);
    _headImageView=[[UIImageView alloc]  init];
    [self addSubview:_headImageView];
    
    _nameLable =[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLable];
    WEAKSELF
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(12));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-12));
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(200));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(80), OCUISCALE(80)));
    }];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.headImageView.mas_left).offset(OCUISCALE(10));
        make.centerX.mas_equalTo(weakSelf.headImageView.mas_centerX);
    }];
}
- (void)setUserName:(NSString *)userName headImageUrl:(NSString *)headImageUrl level:(NSInteger)level{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:EMDefaultImage];
    _nameLable.text=userName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setUserName:(NSString *)userName headImageUrl:(NSString *)headImageUrl{
    
}
@end
