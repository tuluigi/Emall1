//
//  EMHomeViewController.m
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeViewController.h"
#import "EMInfiniteView.h"
#import "EMHomeCatCell.h"
#import "EMHomeModel.h"
#import "EMHomeGoodsCell.h"
#import "EMHomeNetService.h"
#import "EMCatModel.h"
#import "EMHomeHeadReusableView.h"
#import "EMInfiniteViewCell.h"
#import "EMGoodsDetailViewController.h"
#import "EMGoodsModel.h"
#import "EMAdModel.h"
#import "EMCatViewController.h"
#import "EMGoodsListViewController.h"
#import "EMWebViewController.h"
@interface EMHomeViewController ()<EMInfiniteViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
EMHomeCatCellDelegate,
EMHomeHeadReusableViewDelegate>
@property (nonatomic,strong)EMInfiniteView *infiniteView;
@property (nonatomic,strong)__block NSMutableArray *adArray;
@property (nonatomic,strong)__block EMHomeModel *homeModel;

@property (nonatomic,strong)UICollectionView *myCollectionView;

@end

@implementation EMHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (nil==self.homeModel) {
        [self getHomeData];
    }
    if (self.adArray.count==0) {
        [self getHomeADList];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"嗨吃GO";
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero );
    }];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"home_right_avatar"] style:UIBarButtonItemStylePlain target:self action:@selector(didHomeRighBarButtonPressed)];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"home_icon_list"] style:UIBarButtonItemStylePlain target:self action:@selector(didLeftBarButtonPressed)];
    self.adArray=[EMCache em_objectForKey:EMCache_HomeADDataSourceKey];
    self.homeModel=[EMCache em_objectForKey:EMCache_HomeDataSourceKey];
    WEAKSELF
    [self.myCollectionView addOCPullDownResreshHandler:^{
        [weakSelf getHomeData];
        [weakSelf getHomeADList];
    }];
    [self.myCollectionView startPullDownRefresh];
    
    //缓存系统缓存信息
    [EMHomeNetService getSystemConfigCompletionBlock:^(OCResponseResult *responseResult) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didLeftBarButtonPressed{
    EMCatViewController *catController=[[EMCatViewController alloc]  init];
    catController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:catController animated:YES];
}
- (void)didHomeRighBarButtonPressed{
    if ([RI isLogined]) {
        [self.tabBarController setSelectedIndex:([self.tabBarController.viewControllers count]-1)];
    }else{
        [self showLoginControllerOnCompletionBlock:^(BOOL isSucceed) {
            
        }];
    }
}
#pragma mark -Net
- (void)getHomeADList{
    WEAKSELF
    NSURLSessionTask *task=[EMHomeNetService getHomeAdListOnCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            if (nil==weakSelf.adArray) {
                weakSelf.adArray=[[NSMutableArray alloc] init];
            }
            [weakSelf.adArray removeAllObjects];
            [weakSelf.adArray addObjectsFromArray:responseResult.responseData];
             [EMCache em_setObject:weakSelf.adArray forKey:EMCache_HomeADDataSourceKey];
            [weakSelf.myCollectionView reloadData];
        }
    }];
    [self addSessionTask:task];
}
- (void)getHomeData{
    WEAKSELF
    NSURLSessionTask *task=[EMHomeNetService getHomeDataOnCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.myCollectionView stopRefreshAndInfiniteScrolling];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            weakSelf.homeModel=responseResult.responseData;
            [EMCache em_setObject:weakSelf.homeModel forKey:EMCache_HomeDataSourceKey];
            [weakSelf.myCollectionView reloadData];
        }
    }];
    [self addSessionTask:task];
}
#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=0;
    if (section==0) {
        if (self.homeModel.catArray.count) {
            count=1;
        }
    }else if (section==1){
        count=self.homeModel.greatGoodsArray.count;
    }else if (section==2){
        count=self.homeModel.hotGoodsArray.count;
    }
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *aCell;
    if (indexPath.section==0) {
        EMHomeCatCell *cell=(EMHomeCatCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeCatCell class]) forIndexPath:indexPath];
        cell.catModelArray=self.homeModel.catArray;
        cell.delegate=self;
        aCell=cell;
    }else if(indexPath.section==1){
        EMHomeGoodsCell *cell=(EMHomeGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeGoodsCell class]) forIndexPath:indexPath];
        [cell setGoodsModel:[self.homeModel.greatGoodsArray objectAtIndex:indexPath.row] dataSource:self.homeModel.greatGoodsArray];
        aCell=cell;
    }else if (indexPath.section==2){
        EMHomeGoodsCell *cell=(EMHomeGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeGoodsCell class]) forIndexPath:indexPath];
        [cell setGoodsModel:[self.homeModel.hotGoodsArray objectAtIndex:indexPath.row] dataSource:self.homeModel.hotGoodsArray];
        aCell=cell;
    }else{
        aCell=[[UICollectionViewCell alloc]  init];
    }
    return aCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    
    CGSize size = flowLayout.itemSize;
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size=CGSizeZero;
    if (section==1||section==2) {
        size=CGSizeMake(OCWidth, [EMHomeHeadReusableView homeHeadReusableViewHeight]);
    }else if (section==0){
        size=CGSizeMake(OCWidth, OCUISCALE(170));
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    if (indexPath.section==0) {
        reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([EMInfiniteView class]) forIndexPath:indexPath];
        [(EMInfiniteView *)reusableView registerClass:[EMInfiniteViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EMInfiniteViewCell class])];
        [(EMInfiniteView *)reusableView setTotalNumber:self.adArray.count];
        [(EMInfiniteView *)reusableView setDelegate:self];
    }else if (indexPath.section==1||indexPath.section==2){
        reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([EMHomeHeadReusableView class]) forIndexPath:indexPath];
      
        if (indexPath.section==1) {
            [(EMHomeHeadReusableView *)reusableView setType:EMHomeHeadReusableViewTypeGreat];
        }else if(indexPath.section==2){
            [(EMHomeHeadReusableView *)reusableView setType:EMHomeHeadReusableViewTypeHot];
        }
          ((EMHomeHeadReusableView *)reusableView).delegate=self;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
    }else{
        EMGoodsModel *goodsModel;
        if (indexPath.section==1) {
            goodsModel=[self.homeModel.greatGoodsArray objectAtIndex:indexPath.row];
        }else if(indexPath.section==2){
            goodsModel=[self.homeModel.hotGoodsArray objectAtIndex:indexPath.row];
        }
        EMGoodsDetailViewController *detailController=[[EMGoodsDetailViewController alloc]  initWithGoodsID:goodsModel.goodsID];
        detailController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}
#pragma mark - EMHomeCatCell Delegate
- (void)homeCatCell:(EMHomeCatCell *)cell didSelectItem:(EMCatModel *)catModel{
    
    EMGoodsListViewController *listController=[[EMGoodsListViewController alloc]  initWithCatID:catModel.catID catName:catModel.catName];
    listController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:listController animated:YES];
    
    /*
    EMCatViewController *catController=[[EMCatViewController alloc]  init];
    catController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:catController animated:YES];
     */
}
/**
 *  分类点击更多
 */
- (void)homeHeadReusableViewDidSelect:(EMHomeHeadReusableViewType)type{
    NSString *catName;
    if (type==EMHomeHeadReusableViewTypeGreat) {
        catName=@"嗨吃精品";
    }else if (type==EMHomeHeadReusableViewTypeHot){
        catName=@"嗨吃特卖";
    }
    EMGoodsListViewController *listController=[[EMGoodsListViewController alloc]  initWithHomeType:type typeName:catName];
    listController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:listController animated:YES];
}
#pragma mark -EMInfiniteVieDelegate
- (NSInteger)numberOfInfiniteViewCellsInInfiniteView:(EMInfiniteView *)infiniteView{
    return self.adArray.count;
}

- (EMInfiniteViewCell *)infiniteView:(EMInfiniteView *)infiniteView cellForRowAtIndex:(NSInteger)index{
    EMInfiniteViewCell *cell=(EMInfiniteViewCell *)[infiniteView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMInfiniteViewCell class]) atIndex:index];
    EMAdModel *adInfo=[self.adArray objectAtIndex:index];
    cell.imageUrl=adInfo.adImageUrl;
    return cell;
}
- (void)infiniteView:(EMInfiniteView *)infiniteView didSelectRowAtIndex:(NSInteger)index{
    EMAdModel *adModel=[self.adArray objectAtIndex:index];
    if (![NSString isNilOrEmptyForString:adModel.adUrl]) {
        EMWebViewController *webController=[[EMWebViewController alloc]  initWithUrl:adModel.adUrl title:nil];
        webController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
}





#pragma mark - getter
-(EMInfiniteView *)infiniteView{
    if (nil==_infiniteView) {
        _infiniteView=[[EMInfiniteView alloc]  initWithFrame:CGRectMake(0, 0, OCWidth, OCUISCALE(170))];
        _infiniteView.delegate=self;
    }
    return _infiniteView;
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
        flowLayout.headerReferenceSize=CGSizeMake(OCWidth, [EMHomeHeadReusableView homeHeadReusableViewHeight]);
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMHomeCatCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeCatCell class])];
        [_myCollectionView registerClass:[EMHomeGoodsCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeGoodsCell class])];
        [_myCollectionView registerClass:[EMHomeHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EMHomeHeadReusableView class])];
        [_myCollectionView registerClass:[EMInfiniteView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EMInfiniteView class])];
        
    }
    return _myCollectionView;
}
@end
