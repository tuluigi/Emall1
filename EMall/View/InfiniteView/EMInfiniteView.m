//
//  EMInfiniteView.m
//  EMall
//
//  Created by Luigi on 16/7/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMInfiniteView.h"
#import "EMInfiniteViewCell.h"
@interface EMInfiniteView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong,readwrite) UICollectionView *collectionView;

@end

@implementation EMInfiniteView

- (instancetype)init{
    self=[self initWithFrame:CGRectZero];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}
- (void)layoutSubviews{
    self.collectionView.frame=self.bounds;
    [self.collectionView reloadData];
}

#pragma mark -delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=0;
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfInfiniteViewCellsInInfiniteView:)]) {
        count=[_delegate numberOfInfiniteViewCellsInInfiniteView:self];
    }
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    if (nil==cell) {
        if (_delegate&&[_delegate respondsToSelector:@selector(infiniteView:cellForRowAtIndex:)]) {
           cell= [_delegate infiniteView:self cellForRowAtIndex:indexPath.row];
        }else{
            cell=[[UICollectionViewCell alloc]  init];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(infiniteView:didSelectRowAtIndex:)]) {
        [_delegate infiniteView:self didSelectRowAtIndex:indexPath.row];
    }
}

#pragma mark -getter
-(UICollectionView *)collectionView{
    if (nil==_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = YES;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        [mainView registerClass:[EMInfiniteViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EMInfiniteViewCell class])];
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        _collectionView=mainView;
    }
    return _collectionView;
}
@end
