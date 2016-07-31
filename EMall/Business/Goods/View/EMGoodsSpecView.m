//
//  EMGoodsSpecView.m
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsSpecView.h"
#import "EMGoodsModel.h"

@interface EMGoodsSpecCell : UICollectionViewCell
@property (nonatomic,strong)EMGoodsObjectItemModel *itemModle;
@end
@interface EMGoodsSpecCell ()

@end
@implementation EMGoodsSpecCell



@end


@interface EMGoodsSpecView ()
@property (nonatomic,strong)EMGoodsModel *goodsModel;
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)UIImageView *goodsImageView;
@property (nonatomic,strong)UILabel *goodsNameLabel;
@end

@implementation EMGoodsSpecView

- (void)onInitContentView{
    UIFont *font=[UIFont oc_systemFontOfSize:12];
    UIColor *textColor=[UIColor colorWithHexString:@"#272727"];
    _goodsNameLabel=[UILabel labelWithText:@"" font:[UIFont oc_systemFontOfSize:13] textAlignment:NSTextAlignmentLeft];
    _goodsNameLabel.textColor=textColor;
    [self addSubview:_goodsNameLabel];
    
    _goodsImageView=[[UIImageView alloc]  init];
    [self addSubview:_goodsImageView];
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        _myCollectionView=mainView;
//        [_myCollectionView registerClass:[EMHomeCatCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeCatCell class])];
//        [_myCollectionView registerClass:[EMHomeGoodsCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeGoodsCell class])];
//        [_myCollectionView registerClass:[EMHomeHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EMHomeHeadReusableView class])];
//        [_myCollectionView registerClass:[EMInfiniteView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EMInfiniteView class])];
        
    }
    return _myCollectionView;
}
@end
