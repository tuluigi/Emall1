//
//  EMDiscoveryViewController.m
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMDiscoveryViewController.h"
#import "EMGoodsListCell.h"
#import "EMGoodsModel.h"
#import "EMGoodsDetailViewController.h"
#import "EMGoodsNetService.h"
@interface EMDiscoveryViewController ()<
            UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout
                >
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)__block NSMutableArray *dataSourceArray;
@end

@implementation EMDiscoveryViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataSourceArray.count==0) {
        [self getGoodsListWithCursor:self.cursor];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"发现";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myCollectionView];
    self.automaticallyAdjustsScrollViewInsets=YES;
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self getGoodsListWithCursor:self.cursor];
    WEAKSELF
    [weakSelf.myCollectionView addOCPullDownResreshHandler:^{
        weakSelf.cursor=1;
        [weakSelf getGoodsListWithCursor:weakSelf.cursor];
    }];
    [weakSelf.myCollectionView addOCPullInfiniteScrollingHandler:^{
        weakSelf.cursor++;
        [weakSelf getGoodsListWithCursor:weakSelf.cursor];
    }];
}
- (void)getGoodsListWithCursor:(NSInteger )cursor{
    WEAKSELF
    if (self.dataSourceArray.count==0) {
        [weakSelf.myCollectionView showPageLoadingView];
    }
   NSURLSessionTask *task=[EMGoodsNetService getGoodsListWithSearchGoodsID:0 catID:0  searchName:nil aesc:NO sortType:0 pid:cursor onCompletionBlock:^(OCResponseResult *responseResult) {
       [weakSelf.myCollectionView dismissPageLoadView];
       [weakSelf.myCollectionView stopRefreshAndInfiniteScrolling];
       if (responseResult.cursor>=responseResult.totalPage) {
           [weakSelf.myCollectionView enableInfiniteScrolling:NO];
       }
       if (responseResult.responseCode==OCCodeStateSuccess) {
           if (cursor<2) {
               [weakSelf.dataSourceArray removeAllObjects];
           }
//           for (NSInteger i=0; i<10; i++) {
//               [weakSelf.dataSourceArray addObjectsFromArray:responseResult.responseData];
//           }
            [weakSelf.dataSourceArray addObjectsFromArray:responseResult.responseData];
           [weakSelf.myCollectionView reloadData];
       }else{
           if (weakSelf.dataSourceArray.count==0 ) {
               [weakSelf.myCollectionView showPageLoadedMessage:@"获取数据失败，点击重试" delegate:self];
           }else{
               [weakSelf.myCollectionView showHUDMessage:responseResult.responseMessage];
           }
       }
       weakSelf.cursor=responseResult.cursor;
   }];
    [self addSessionTask:task];
}
-(void)ocPageLoadedViewOnTouced{
    [self getGoodsListWithCursor:self.cursor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=self.dataSourceArray.count;
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMGoodsListCell *cell=(EMGoodsListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMGoodsListCell class]) forIndexPath:indexPath];
    cell.goodsModel=[self.dataSourceArray  objectAtIndex:indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize size = flowLayout.itemSize;
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EMGoodsModel *goodsModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    EMGoodsDetailViewController *detailController=[[EMGoodsDetailViewController alloc] initWithGoodsID:goodsModel.goodsID];
    detailController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailController animated:YES];
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
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
        [_myCollectionView registerClass:[EMGoodsListCell class] forCellWithReuseIdentifier:NSStringFromClass([EMGoodsListCell class])];
    }
    return _myCollectionView;
}
-(NSMutableArray *)dataSourceArray{
    if (nil==_dataSourceArray) {
        _dataSourceArray=[[NSMutableArray alloc]  init];
    }
    return _dataSourceArray;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
