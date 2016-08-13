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
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"home_icon_list"] style:UIBarButtonItemStylePlain target:self action:@selector(didLeftBarButtonPressed)];
    
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
//            weakSelf.adArray=responseResult.responseData;
            if (nil==weakSelf.adArray) {
                weakSelf.adArray=[[NSMutableArray alloc] init];
            }
            for (NSInteger i=0; i<6; i++) {
                EMAdModel *adModel=[[EMAdModel alloc]  init];
                [weakSelf.adArray addObject:adModel];
            }
            NSArray *imageArray=@[@"http://img20.360buyimg.com/da/jfs/t3085/14/190311847/160405/fdbfef46/57a9ac53Neb4a13ae.jpg",
                                  @"http://img20.360buyimg.com/da/jfs/t2731/149/4118719199/98908/2dc1fa5c/57ac3fc5N21a6c823.jpg",
                                  @"http://img11.360buyimg.com/da/jfs/t3226/172/222213990/121068/a16ae9b8/57ac18a5Na40e5db1.jpg",
                                  @"http://img14.360buyimg.com/da/jfs/t2974/351/2380644676/139211/50c2e8b3/57ac2a0cN345414cd.jpg",
                                  @"https://img.alicdn.com/tps/i4/TB1DqXdLpXXXXcxXVXXSutbFXXX.jpg_q100.jpg",
                                  @"https://aecpm.alicdn.com/simba/img/TB1_JXrLVXXXXbZXVXXSutbFXXX.jpg"];
            //暂时为了测试用
            for (EMAdModel *adModel in weakSelf.adArray) {
                NSInteger index=[weakSelf.adArray indexOfObject:adModel];
                index=index%imageArray.count;
                adModel.adImageUrl=[imageArray objectAtIndex:index];
            }

            [weakSelf.myCollectionView reloadData];
        }
    }];
    [self addSessionTask:task];
}
- (void)getHomeData{
    WEAKSELF
    NSURLSessionTask *task=[EMHomeNetService getHomeDataOnCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            weakSelf.homeModel=responseResult.responseData;
            [weakSelf.homeModel.catArray addObjectsFromArray:weakSelf.homeModel.catArray];
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
        count=self.homeModel.hotGoodsArray.count;
    }else if (section==2){
        count=self.homeModel.greatGoodsArray.count;
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
        [cell setGoodsModel:[self.homeModel.hotGoodsArray objectAtIndex:indexPath.row] dataSource:self.homeModel.hotGoodsArray];
        aCell=cell;
    }else if (indexPath.section==2){
        EMHomeGoodsCell *cell=(EMHomeGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeGoodsCell class]) forIndexPath:indexPath];
        [cell setGoodsModel:[self.homeModel.greatGoodsArray objectAtIndex:indexPath.row] dataSource:self.homeModel.hotGoodsArray];
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
        EMHomeGoodsModel *goodsModel;
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
    EMCatViewController *catController=[[EMCatViewController alloc]  init];
    catController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:catController animated:YES];
}
/**
 *  分类点击更多
 */
- (void)homeHeadReusableViewDidSelect:(EMHomeHeadReusableViewType)type{
    if (type==EMHomeHeadReusableViewTypeGreat) {
        
    }else if (type==EMHomeHeadReusableViewTypeHot){
        
    }
    EMGoodsListViewController *listController=[[EMGoodsListViewController alloc]  initWithCatID:type];
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
    //
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
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
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
