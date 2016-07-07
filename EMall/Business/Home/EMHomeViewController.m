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
@interface EMHomeViewController ()<EMInfiniteViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
    self.title=@"海吃GO";
    [self.view addSubview:self.myCollectionView];
    WEAKSELF
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero );
    }];
//    self.tableView.tableHeaderView=self.infiniteView;
//    [self.tableView registerClass:[EMHomeCatCell class] forCellReuseIdentifier:NSStringFromClass([EMHomeCatCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Net
- (void)getHomeADList{
    WEAKSELF
    NSURLSessionTask *task=[EMHomeNetService getHomeAdListOnCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            weakSelf.adArray=responseResult.responseData;
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
//        if (self.adArray.count>0) {
//            count=1;
//        }
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
    }else if(indexPath.section==1){
        EMHomeGoodsCell *cell=(EMHomeGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeGoodsCell class]) forIndexPath:indexPath];
//        cell.goodsModel=[self.homeModel.hotGoodsArray objectAtIndex:indexPath.row];
        [cell setGoodsModel:[self.homeModel.hotGoodsArray objectAtIndex:indexPath.row] dataSource:self.homeModel.hotGoodsArray];
        aCell=cell;
    }else if (indexPath.section==2){
        EMHomeGoodsCell *cell=(EMHomeGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeGoodsCell class]) forIndexPath:indexPath];
//        cell.goodsModel=[self.homeModel.greatGoodsArray objectAtIndex:indexPath.row];
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
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsZero;
//}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    
    return reusableView;
}
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark -EMInfiniteVieDelegate
- (NSInteger)numberOfInfiniteViewCellsInInfiniteView:(EMInfiniteView *)infiniteView{
    return self.adArray.count;
}

- (EMInfiniteViewCell *)infiniteView:(EMInfiniteView *)infiniteView cellForRowAtIndex:(NSInteger)index{
    return nil;
}
- (void)infiniteView:(EMInfiniteView *)infiniteView didSelectRowAtIndex:(NSInteger)index{
    
}




#pragma mark -tableview Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * aCell;
    if (indexPath.row==0) {
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        aCell=cell;
    }
   
    return aCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
        mainView.pagingEnabled = YES;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
               mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMHomeCatCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeCatCell class])];
        [_myCollectionView registerClass:[EMHomeGoodsCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeGoodsCell class])];

    }
    return _myCollectionView;
}
@end
