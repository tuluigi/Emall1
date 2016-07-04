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
- (instancetype)init{
    self=[super init];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
    _iconImageView=[[UIImageView alloc] init];
    [self addSubview:_iconImageView];
    
    _nameLabel=[UILabel labelWithText:@"" font:[UIFont systemFontOfSize:OCUISCALE(11)] textColor:UIColorHex(@"#5d5c5c") textAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(40), OCUISCALE(40)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(5));
        make.left.right.mas_equalTo(_iconImageView);
    }];
}
- (void)setCatModel:(EMCatModel *)catModel{
    _catModel=catModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_catModel.catImageUrl] placeholderImage:EMDefaultImage];
    self.nameLabel.text=_catModel.catName;
}
+ (CGSize)homeCatItemViewSize{
    return CGSizeMake(OCUISCALE(40), OCUISCALE(40+5+12));
}
@end


@interface EMHomeCatCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIScrollView *myScorllView;
@end

@implementation EMHomeCatCell
- (instancetype)init{
    self=[super init];
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
        make.left.top.right.bottom.mas_equalTo(weakSelf);
    }];
     */
}
#pragma mark - getter  settter
- (void)setCatModelArray:(NSArray *)catModelArray{
    _catModelArray=catModelArray;
    [self.collectionView reloadData];
}
- (void)reloadData{
    CGFloat padding=OCUISCALE(9.5);
    CGFloat offX=OCUISCALE(OCUISCALE(12));
    CGFloat x=0;
    for (NSInteger i=0; i<self.catModelArray.count; i++) {
        EMHomeCatItemView *itemView=[[EMHomeCatItemView alloc]  init];
        [self.myScorllView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo();
        }];
    }
}
#pragma mark -delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=self.catModelArray.count;
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMHomeCatItemView *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeCatItemView class]) forIndexPath:indexPath];
    if (nil==cell) {
        cell=[[EMHomeCatItemView alloc]  init];
    }
    [cell setCatModel:[self.catModelArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [EMHomeCatItemView homeCatItemViewSize];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(OCUISCALE(7.5), OCUISCALE(12), OCUISCALE(7.5), OCUISCALE(12));
}
#pragma mark -getter
-(UICollectionView *)collectionView{
    if (nil==_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *mainView = [[UICollectionView alloc] init];
        mainView.collectionViewLayout=flowLayout;
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = YES;
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
