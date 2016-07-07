//
//  EMHomeCatCell.m
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeCatCell.h"
#import "EMCatModel.h"
@interface EMHomeCatItemView : UICollectionViewCell
@property (nonatomic,strong)EMCatModel *catModel;
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
    _nameLabel.backgroundColor=[UIColor redColor];
    _nameLabel.numberOfLines=1;
    [self.contentView addSubview:_nameLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(OCUISCALE(7.5));
//        make.left.mas_equalTo(weakSelf.contentView).offset(OCUISCALE(9.5));
//        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(OCUISCALE(-9.5));
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(40), OCUISCALE(40)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(5));
        make.left.right.mas_equalTo(_iconImageView);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(OCUISCALE(-7.5));
    }];
}
- (void)setCatModel:(EMCatModel *)catModel{
    _catModel=catModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_catModel.catImageUrl] placeholderImage:EMDefaultImage];
    self.nameLabel.text=_catModel.catName;
}
+ (CGSize)homeCatItemViewSize{
    return CGSizeMake(OCUISCALE(59), OCUISCALE(80));
}
-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size=[EMHomeCatItemView homeCatItemViewSize];
    attributes.size=size;
    return attributes;
}
@end


@interface EMHomeCatCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
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
    
    /*
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
     */
}
-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
   CGSize size=CGSizeMake(OCWidth, [EMHomeCatItemView homeCatItemViewSize].height);
    attributes.size=size;
    return attributes;
}
#pragma mark - getter  settter
- (void)setCatModelArray:(NSArray *)catModelArray{
    _catModelArray=catModelArray;
    [self.collectionView reloadData];
}
- (void)reloadData{
    NSArray *subViewArray=[self.myScorllView subviews];
    for (UIView *aView in subViewArray) {
        [aView removeFromSuperview];
    }
    CGFloat padding=OCUISCALE(19);
    CGFloat offx    =OCUISCALE(12);
    __block CGFloat contentWidth=0;
    WEAKSELF
    EMHomeCatItemView *lastCatView;
    for (NSInteger i=0; i<self.catModelArray.count; i++) {
        EMHomeCatItemView *itemView=[[EMHomeCatItemView alloc]  init];
        itemView.catModel=[self.catModelArray objectAtIndex:i];
        [self.myScorllView addSubview:itemView];
        
        
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i==0) {//第一个
                contentWidth+=offx;
                make.left.mas_equalTo(weakSelf.mas_left).offset(offx);
            }else{
                make.left.mas_equalTo(lastCatView.mas_right).offset(padding);
                make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(7.5));
                make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-7.5));
                CGSize size=[EMHomeCatItemView homeCatItemViewSize];
                make.width.mas_equalTo(size.width);
                contentWidth +=padding;
                contentWidth +=size.width;
            }
            if (i==(weakSelf.catModelArray.count-1)) {
                make.right.mas_greaterThanOrEqualTo(weakSelf.mas_right).offset(-offx).priorityHigh();
                contentWidth+=offx;
            }
        }];
        lastCatView=itemView;
        if (contentWidth<OCWidth) {
            contentWidth=OCWidth;
        }
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


#pragma mark -delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=self.catModelArray.count;
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMHomeCatItemView *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeCatItemView class]) forIndexPath:indexPath];
    [cell setCatModel:[self.catModelArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize size = flowLayout.itemSize;
    return size;
}
#pragma mark -getter
-(UICollectionView *)collectionView{
    if (nil==_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
        mainView.collectionViewLayout=flowLayout;
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        [mainView registerClass:[EMHomeCatItemView class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeCatItemView class])];
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        _collectionView=mainView;
    }
    return _collectionView;
}




@end
