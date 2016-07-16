//
//  EMMEHeadView.m
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMEHeadView.h"

static CGFloat const EMMeHeaderViewIconWidth    =  73;
static CGFloat const EMMeHeaderViewIconTop      =  61;
static CGFloat const EMMeHeaderViewIconBottom   =  10;
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
    self.backgroundColor=RGB(229, 26, 30);
    _headImageView=[[UIImageView alloc]  init];
    [self addSubview:_headImageView];
    
    _nameLable =[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _nameLable.textColor=[UIColor whiteColor];
    [self addSubview:_nameLable];
    WEAKSELF
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(12));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-EMMeHeaderViewIconBottom));
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(EMMeHeaderViewIconTop));
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(EMMeHeaderViewIconWidth), OCUISCALE(EMMeHeaderViewIconWidth)));
    }];
    _headImageView.layer.cornerRadius=OCUISCALE(80/2.0);
    _headImageView.layer.masksToBounds=YES;
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(OCUISCALE(10));
        make.centerY.mas_equalTo(weakSelf.headImageView.mas_centerY);
    }];
}
- (void)setUserName:(NSString *)userName headImageUrl:(NSString *)headImageUrl level:(NSInteger)level{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:EMDefaultImage];
    _nameLable.text=userName;
}
+ (CGFloat)headViewHeight{
    return OCUISCALE(OCUISCALE(EMMeHeaderViewIconTop+EMMeHeaderViewIconWidth+EMMeHeaderViewIconBottom));
}
+ (EMMEHeadView *)meHeadView{
    EMMEHeadView *headView=[[EMMEHeadView alloc]  init];
//    headView.frame=CGRectMake(0, 0, OCWidth, [EMMEHeadView headViewHeight]);
    return headView;
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
