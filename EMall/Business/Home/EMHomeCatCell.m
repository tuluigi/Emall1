//
//  EMHomeCatCell.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeCatCell.h"
#import "EMCatModel.h"

typedef void(^EMHomeCatItemViewSelectBlock)(EMCatModel *catModel);

@interface EMHomeCatItemView : UIView
@property (nonatomic,strong)EMCatModel *catModel;
@property (nonatomic,copy)EMHomeCatItemViewSelectBlock selectBlock;
+ (CGSize)homeCatItemViewSize;
@end
@interface EMHomeCatItemView ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *nameLabel;
@end
@implementation EMHomeCatItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    _iconImageView=[[UIImageView alloc] init];
    _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds=YES;
    
    [self addSubview:_iconImageView];
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(12)] textColor:ColorHexString(@"#5d5c5c") textAlignment:NSTextAlignmentCenter];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.numberOfLines=1;
    [self addSubview:_nameLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(40), OCUISCALE(40)));
    }];
    _iconImageView.layer.cornerRadius=OCUISCALE(40/2.0);
    _iconImageView.layer.masksToBounds=YES;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(9));
        make.width.mas_equalTo([EMHomeCatItemView homeCatItemViewSize].width);
        make.centerX.mas_equalTo(weakSelf.iconImageView);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-10));
    }];
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
}
- (void)setCatModel:(EMCatModel *)catModel{
    _catModel=catModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_catModel.catImageUrl] placeholderImage:EMDefaultImage];
    self.nameLabel.text=_catModel.catName;
}
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture{
    if (self.selectBlock) {
        self.selectBlock(self.catModel);
    }
}

+ (CGSize)homeCatItemViewSize{
    return CGSizeMake(OCUISCALE(47+15), OCUISCALE(84));
}

@end


@interface EMHomeCatCell ()
@property (nonatomic,strong)UIScrollView *myScorllView;
@property (nonatomic,strong)NSTimer *myTimer;

@end

@implementation EMHomeCatCell
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    [self.contentView addSubview:self.myScorllView];
    [self.myScorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self addTimer];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    attributes.size=CGSizeMake(OCWidth, [EMHomeCatItemView homeCatItemViewSize].height);
    return attributes;
}
- (void)addTimer{
    if (nil==self.myTimer) {
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.myTimer=timer;
    }
}
- (void)handleTimer:(NSTimer *)timer{
    CGSize contentSize=self.myScorllView.contentSize;
    CGPoint offSet=self.myScorllView.contentOffset;
    CGSize itemSize=[EMHomeCatItemView homeCatItemViewSize];
    CGPoint offset0=offSet;
    
    if (offset0.x<=0){
        offset0=CGPointMake(itemSize.width, 0);
    }else if(fabsf(offSet.x)+CGRectGetWidth(self.myScorllView.bounds)+itemSize.width >=contentSize.width){
        offset0=CGPointMake(0, 0);
    }else  {
         offset0=CGPointMake(offSet.x+itemSize.width, 0);
    }
    [self.myScorllView setContentOffset:offset0 animated:YES];
}
#pragma mark - getter  settter
- (void)setCatModelArray:(NSArray *)catModelArray{
    if (catModelArray.count!=_catModelArray.count) {
        _catModelArray=catModelArray;
        [self reloadData];
    }
}
- (void)reloadData{
    NSArray *subViewArray=[self.myScorllView subviews];
    for (UIView *aView in subViewArray) {
        [aView removeFromSuperview];
    }
    CGFloat offx    =OCUISCALE(4.5);
    __block CGFloat contentWidth=0;
    WEAKSELF
    CGSize itemViewSize =[EMHomeCatItemView homeCatItemViewSize];
    for (NSInteger i=0; i<self.catModelArray.count; i++) {
        EMHomeCatItemView *itemView=[[EMHomeCatItemView alloc]  init];
        itemView.catModel=[self.catModelArray objectAtIndex:i];
        itemView.selectBlock= ^(EMCatModel *catModel){
            if (_delegate &&[_delegate respondsToSelector:@selector(homeCatCell:didSelectItem:)]) {
                [_delegate homeCatCell:weakSelf didSelectItem:catModel];
            }
        };
        [self.myScorllView addSubview:itemView];
        CGFloat x=offx;
        if (i==0) {
            x=offx;
            contentWidth=offx;
        }else{
            x+=itemViewSize.width*i;
            contentWidth=x+itemViewSize.width;
            if (i==self.catModelArray.count) {
                contentWidth+=offx;
            }
        }
        itemView.frame=CGRectMake(x, 0, itemViewSize.width, itemViewSize.height);
        self.myScorllView.contentSize=CGSizeMake(contentWidth, [EMHomeCatItemView homeCatItemViewSize].height);
    }
}
- (UIScrollView *)myScorllView{
    if (nil==_myScorllView) {
        _myScorllView=[[UIScrollView alloc]  init];
//        _myScorllView.delegate=self;
        _myScorllView.showsVerticalScrollIndicator=NO;
        _myScorllView.showsHorizontalScrollIndicator=NO;
    }
    return _myScorllView;
}




@end
