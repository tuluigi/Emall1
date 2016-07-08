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

@interface EMHomeCatItemView : UICollectionViewCell
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
    [self.contentView addSubview:_iconImageView];
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(11)] textColor:ColorHexString(@"#5d5c5c") textAlignment:NSTextAlignmentLeft];
    _nameLabel.adjustsFontSizeToFitWidth=YES;
    _nameLabel.backgroundColor=[UIColor clearColor];
    _nameLabel.numberOfLines=1;
    [self.contentView addSubview:_nameLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(7.5));
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(40), OCUISCALE(40)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(5));
        make.left.right.mas_equalTo(_iconImageView);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-7.5));
    }];
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(homeCatItemViewDidSelectBlock:)];
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
    return CGSizeMake(OCUISCALE(59), OCUISCALE(80));
}

@end


@interface EMHomeCatCell ()
@property (nonatomic,strong)UIScrollView *myScorllView;

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
    WEAKSELF
    [self.contentView addSubview:self.myScorllView];
    [self.myScorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(weakSelf.contentView);
    }];
}

#pragma mark - getter  settter
- (void)setCatModelArray:(NSArray *)catModelArray{
    _catModelArray=catModelArray;
    [self reloadData];
}
- (void)reloadData{
    NSArray *subViewArray=[self.myScorllView subviews];
    for (UIView *aView in subViewArray) {
        [aView removeFromSuperview];
    }
    CGFloat offx    =OCUISCALE(2.5);
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
        _myScorllView.delegate=self;
        _myScorllView.showsVerticalScrollIndicator=NO;
        _myScorllView.showsHorizontalScrollIndicator=NO;
    }
    return _myScorllView;
}




@end
