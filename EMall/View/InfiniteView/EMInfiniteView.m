//
//  EMInfiniteView.m
//  EMall
//
//  Created by Luigi on 16/7/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMInfiniteView.h"
#import "EMInfiniteViewCell.h"
static NSInteger const kMaxRowCount     =3;
@interface EMInfiniteView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong,readwrite) UICollectionView *collectionView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)NSTimer *myTimer;

@property (nonatomic,strong)NSIndexPath *currentIndexPath;
@property (nonatomic,assign)CGFloat offx;
@end

@implementation EMInfiniteView
@synthesize totalNumber=_totalNumber;
+ (EMInfiniteView *)InfiniteViewWithFrame:(CGRect)frame{
    EMInfiniteView *infiniteView=[[EMInfiniteView alloc]  initWithFrame:frame];
    return infiniteView;
}
- (instancetype)init{
    self=[self initWithFrame:CGRectZero];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self onInitContentView];
    }
    return self;
}
- (void)onInitContentView{
      [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
    WEAKSELF
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(OCUISCALE(-10));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(OCUISCALE(20));
    }];
    _currentIndex=0;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
- (void)setTotalNumber:(NSInteger)totalNumber{
    _totalNumber=totalNumber;
    self.pageControl.numberOfPages=_totalNumber;
    [self addTimer];
}
-(NSInteger)totalNumber{
    if (!_totalNumber) {
        if (_delegate&&[_delegate respondsToSelector:@selector(numberOfInfiniteViewCellsInInfiniteView:)]) {
          _totalNumber=[_delegate numberOfInfiniteViewCellsInInfiniteView:self];
        }
    }
    return _totalNumber;
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex=currentIndex;
    self.pageControl.currentPage=_currentIndex;
}
- (void)addTimer{
    if (nil==self.myTimer) {
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoLoadNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.myTimer=timer;
    }
}
- (NSInteger)nextIndex{
    NSInteger nextIndex=(self.currentIndex+1);
    if (nextIndex>=self.totalNumber) {
        nextIndex=0;
    }
    return nextIndex;
}
- (NSInteger)preIndex{
    NSInteger preIndex=(self.currentIndex-1);
    if (preIndex>=self.totalNumber) {
        preIndex=0;
    }else if (preIndex<0){
        preIndex=self.totalNumber-1;
    }
    return preIndex;
}
- (void)autoLoadNextPage{
    NSInteger totalRows = [self.collectionView numberOfItemsInSection:0];
    if ((self.totalNumber+2)!=totalRows) {
        [self.collectionView reloadData];
    }

    NSInteger offsetX = self.collectionView.contentOffset.x;
    self.offx=offsetX;
     [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}
#pragma mark -private
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier atIndex:(NSInteger)index{
    NSInteger row=(index+1)%kMaxRowCount;
    id cell= [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return cell;
}
#pragma mark -delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return kMaxRowCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=nil;
    self.currentIndexPath=indexPath;
    
    NSInteger row=self.currentIndex;
    if (indexPath.row==0) {
        row=[self preIndex];
    }else if (indexPath.row==1){
        row=self.currentIndex;
    }else if (indexPath.row==2){
        row=[self nextIndex];
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(infiniteView:cellForRowAtIndex:)]) {
        cell= [_delegate infiniteView:self cellForRowAtIndex:row];
    }else{
        cell=[[UICollectionViewCell alloc]  init];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(infiniteView:didSelectRowAtIndex:)]) {
        [_delegate infiniteView:self didSelectRowAtIndex:self.currentIndex];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
}
#pragma mark - scrollview delegate
////定时器自动滑动
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSInteger offsetX = scrollView.contentOffset.x;
    self.offx=offsetX;
    scrollView.userInteractionEnabled=NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

//手动滑动
-(void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled=YES;
    if (self.totalNumber) {
        NSInteger offsetX = scrollView.contentOffset.x;
        NSInteger viewW = scrollView.bounds.size.width;
        NSInteger currentOffset = offsetX/viewW - 1;
        
        NSInteger lastOffset=self.offx/viewW -1;
        if (lastOffset!=currentOffset) {
            NSInteger currentPage=0;
            if (currentOffset != 0)
            {
                currentPage = (_currentIndex + currentOffset + self.totalNumber) % self.totalNumber;
                self.currentIndex=currentPage;
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:1 inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                
                [self.collectionView reloadData];
            }else{
                self.currentIndex=currentPage;
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.myTimer invalidate];
    self.myTimer=nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
#pragma mark -getter
-(UICollectionView *)collectionView{
    if (nil==_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        flowLayout.itemSize=self.bounds.size;
        mainView.backgroundColor = [UIColor clearColor];
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        _collectionView=mainView;
         _collectionView.pagingEnabled=YES;
    }
    return _collectionView;
}
-(UIPageControl *)pageControl{
    if (nil==_pageControl) {
        _pageControl=[[UIPageControl alloc]  init];
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor redColor];
        
    }
    return _pageControl;
}
@end
