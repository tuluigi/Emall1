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
@property (nonatomic,strong)UIView *lineSpaceView;
@end

@implementation EMHomeHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}

- (void)onInitContentView{
    _lineSpaceView=[[UIView alloc]  init];
    [self addSubview:_lineSpaceView];
    _lineSpaceView.backgroundColor=ColorHexString(@"#f1f3f0");
    _titleLable=[UILabel labelWithText:@"嗨购精品" font:[UIFont oc_boldSystemFontOfSize:12] textAlignment:NSTextAlignmentLeft];
    _titleLable.textColor=ColorHexString(@"#fc4747");
    [self addSubview:_titleLable];
    
    _moreButton=[UIButton buttonWithTitle:@"更多>" titleColor:ColorHexString(@"#5d5c5c") font:[UIFont oc_systemFontOfSize:12]];
    _moreButton.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self addSubview:_moreButton];
    WEAKSELF
    [_lineSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(OCUISCALE(5));
    }];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(12));
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(OCUISCALE(2.5));
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).offset(OCUISCALE(-12));
        make.centerY.mas_equalTo(weakSelf.titleLable.mas_centerY);
    }];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attrs=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size=[self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    size.width=OCWidth;
    return attrs;
}

- (void)didHeadMoreButtonPressed{
    if (_delegate && [_delegate respondsToSelector:@selector(homeHeadReusableViewDidSelect:)]) {
        [_delegate homeHeadReusableViewDidSelect:self.type];
    }
}
- (void)setType:(EMHomeHeadReusableViewType)type{
    _type=type;
    if (_type==EMHomeHeadReusableViewTypeGreat) {
        self.titleLable.text=@"嗨购精品";
    }else if (_type==EMHomeHeadReusableViewTypeHot){
        self.titleLable.text=@"嗨购热品";
    }
}

+ (CGFloat)homeHeadReusableViewHeight{
    return OCUISCALE(35);
}
@end
