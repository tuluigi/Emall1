//
//  EMMeOrderStateCell.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMeOrderStateCell.h"
#import <JSBadgeView/JSBadgeView.h>
#import "EMOrderModel.h"

@interface EMOrderStatetItemView : UICollectionViewCell
@property (nonatomic,strong)EMOrderStateModel *stateModel;
+ (CGSize)orderStateItemViewSize;
@end
@interface EMOrderStatetItemView ()
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *nameLabel;
@property (nonatomic,strong) JSBadgeView *badgeView;
@end
@implementation EMOrderStatetItemView
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
    
    _badgeView=[[JSBadgeView alloc]  init];
    _badgeView.badgeTextColor=[UIColor whiteColor];
    _badgeView.badgeBackgroundColor=[UIColor yellowColor];
    _badgeView.badgeTextFont=[UIFont oc_systemFontOfSize:10];
    [self addSubview:_badgeView];
    
    WEAKSELF
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(OCUISCALE(10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(20), OCUISCALE(20)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(OCUISCALE(5));
        make.width.mas_equalTo([EMOrderStatetItemView orderStateItemViewSize].width);
        make.centerX.mas_equalTo(weakSelf.iconImageView);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-10));
    }];
    [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(OCUISCALE(-5));
        make.centerY.mas_equalTo(weakSelf.iconImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(OCUISCALE(8), OCUISCALE(8)));
    }];
}
- (void)setStateModel:(EMOrderStateModel *)stateModel{
    _stateModel=stateModel;
    _iconImageView.image=[UIImage imageNamed:_stateModel.icomName];
    self.nameLabel.text=_stateModel.stateName;
    if (_stateModel.badgeNumber) {
        self.badgeView.hidden=NO;
        self.badgeView.badgeText=[NSString stringWithFormat:@"%ld",_stateModel.badgeNumber];
    }else{
        self.badgeView.hidden=YES;
        self.badgeView.badgeText=@"";
    }
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes=[super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size=[EMOrderStatetItemView orderStateItemViewSize];
    size.width=OCWidth/4;
    attributes.size=size;
    return attributes;
}


+ (CGSize)orderStateItemViewSize{
    return CGSizeMake(OCUISCALE(60), OCUISCALE(60));
}

@end

#define EMMeOrderStateCellIdentifer @"EMMeOrderStateCellIdentifer"

@interface EMMeOrderStateCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *myCollectionView;
@end

@implementation EMMeOrderStateCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self onInitContentView];
    }
    return self;
}

- (void)onInitContentView{
    [self.contentView addSubview:self.myCollectionView];
}
- (void)setOrderStateArry:(NSArray *)orderStateArry{
    _orderStateArry=orderStateArry;
    [self.myCollectionView reloadData];
    
}
#pragma mark- collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.orderStateArry.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMOrderStatetItemView *cell=[collectionView dequeueReusableCellWithReuseIdentifier:EMMeOrderStateCellIdentifer forIndexPath:indexPath];
    cell.stateModel=[self.orderStateArry objectAtIndex:indexPath.row];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [EMOrderStatetItemView orderStateItemViewSize];
    size=CGSizeMake(OCWidth/self.orderStateArry.count, size.height);
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EMOrderStateModel *stateModel=[self.orderStateArry objectAtIndex:indexPath.row];
    if (_delegate&&[_delegate respondsToSelector:@selector(orderStateCellDidSelectItem:)]) {
        [_delegate orderStateCellDidSelectItem:stateModel];
    }
}
+ (CGFloat)orderStateCellHeight{
    return [EMOrderStatetItemView orderStateItemViewSize].height;
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, OCWidth, [EMMeOrderStateCell orderStateCellHeight]) collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.collectionViewLayout=flowLayout;
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMOrderStatetItemView class] forCellWithReuseIdentifier:EMMeOrderStateCellIdentifer];
    }
    return _myCollectionView;
}
@end
