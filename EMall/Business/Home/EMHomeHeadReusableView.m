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
@property (nonatomic,strong)UIImageView *imageView;
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
     _lineSpaceView.backgroundColor=ColorHexString(@"#f1f3f0");
    [self addSubview:_lineSpaceView];
    
    _imageView=[[UIImageView alloc]  init];
    _imageView.image=[UIImage imageNamed:@"home_greatgood"];
    [self addSubview:_imageView];
    
    /*
   
    UIFont *font=[UIFont fontWithName:@"FZZHYJW  Bold" size:OCUISCALE(13)];
    _titleLable=[UILabel labelWithText:@"嗨购精品" font:font textAlignment:NSTextAlignmentLeft];
    _titleLable.textColor=ColorHexString(@"#fc4747");
    [self addSubview:_titleLable];
    */
    _moreButton=[UIButton buttonWithTitle:@"更多" titleColor:ColorHexString(@"#5d5c5c") font:[UIFont oc_systemFontOfSize:12]];
    _moreButton.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    UIImage *btnImage=[UIImage imageNamed:@"arror_right"];
    CGSize titleSize=[_moreButton.titleLabel.text boundingRectWithfont:_moreButton.titleLabel.font maxTextSize:_moreButton.titleLabel.bounds.size];
    [_moreButton setImage:[UIImage imageNamed:@"arror_right"] forState:UIControlStateNormal];
    [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, 0)];
    [_moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnImage.size.width-8, 0, 0)];
    _moreButton.highlighted=NO;
    [_moreButton addTarget:self action:@selector(didHeadMoreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreButton];
    WEAKSELF
    [_lineSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(OCUISCALE(5));
    }];
//    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(12));
//        make.top.mas_equalTo(weakSelf.lineSpaceView.mas_bottom).offset(OCUISCALE(5));
//        make.bottom.mas_equalTo(weakSelf.mas_bottom);
//    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).offset(OCUISCALE(12));
        make.top.mas_equalTo(weakSelf.lineSpaceView.mas_bottom).offset(OCUISCALE(5));
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right).offset(OCUISCALE(-12));
        make.centerY.mas_equalTo(weakSelf.imageView.mas_centerY);
    }];
    self.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(didHeadMoreButtonPressed)];
    [self addGestureRecognizer:tapGesture];
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
       _imageView.image=[UIImage imageNamed:@"home_greatgood"];
        self.titleLable.text=@"嗨购精品";
    }else if (_type==EMHomeHeadReusableViewTypeHot){
        _imageView.image=[UIImage imageNamed:@"home_hotgood"];
        self.titleLable.text=@"嗨购热品";
    }
}

+ (CGFloat)homeHeadReusableViewHeight{
    UIImage *image= [UIImage imageNamed:@"home_greatgood"];
    return OCUISCALE(10+image.size.height);
}
@end
