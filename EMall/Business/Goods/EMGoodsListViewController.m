//
//  EMGoodsListViewController.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsListViewController.h"
#import "EMGoodsListCell.h"
#import "EMGoodsModel.h"
#import "EMGoodsDetailViewController.h"
#import "EMGoodsNetService.h"

typedef NS_ENUM(NSInteger,EMGoodsListFromType) {
     EMGoodsListFromTypeCategory=0,//分类过来的
        EMGoodsListFromTypeHome =1,//首页过来的
};

@interface EMGoodsListViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)__block NSMutableArray *dataSourceArray;
@property (nonatomic,assign)NSInteger catID,homeType;
@property (nonatomic,assign)EMGoodsListFromType fromType;
@end

@implementation EMGoodsListViewController
- (instancetype)initWithCatID:(NSInteger )catID catName:(NSString *)catName{
    self=[self initWithCatID:catID catName:catName fromType:EMGoodsListFromTypeCategory];
      self.catID=catID;
    return self;
}
- (instancetype)initWithHomeType:(NSInteger )typeID typeName:(NSString *)typeName{
    self=[self initWithCatID:typeID catName:typeName fromType:EMGoodsListFromTypeHome];
    self.homeType=typeID;
    return self;
}
- (instancetype)initWithCatID:(NSInteger )catID catName:(NSString *)catName fromType:(EMGoodsListFromType)fromType{
    self=[super init];
    if (self) {
        if ([NSString isNilOrEmptyForString:catName]) {
            self.navigationItem.title=@"商品列表";
        }else{
            self.navigationItem.title=catName;
        }
        self.fromType=fromType;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataSourceArray.count==0) {
        [self getGoodsListWithCursor:self.cursor];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myCollectionView];
    self.automaticallyAdjustsScrollViewInsets=YES;
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    WEAKSELF
    [weakSelf.myCollectionView addOCPullDownResreshHandler:^{
        weakSelf.cursor=1;
        [weakSelf getGoodsListWithCursor:weakSelf.cursor];
    }];
    [weakSelf.myCollectionView addOCPullInfiniteScrollingHandler:^{
        weakSelf.cursor++;
        [weakSelf getGoodsListWithCursor:weakSelf.cursor];
    }];
    [self.myCollectionView startPullDownRefresh];
}
- (void)getGoodsListWithCursor:(NSInteger )cursor{
    WEAKSELF
    NSURLSessionTask *task=[EMGoodsNetService getGoodsListWithSearchGoodsID:0 catID:self.catID searchName:nil aesc:0 sortType:0 homeType:self.homeType pid:cursor pageSize:20 onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.myCollectionView stopRefreshAndInfiniteScrolling];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            NSArray *resultArray=(NSArray *)responseResult.responseData;
            if (resultArray.count) {
                if (cursor<=1) {
                    [weakSelf.dataSourceArray removeAllObjects];
                }
                NSInteger index=weakSelf.dataSourceArray.count-1;
                [weakSelf.dataSourceArray addObjectsFromArray:responseResult.responseData];
                if (cursor<=1) {
                    [EMCache em_setObject:weakSelf.dataSourceArray forKey:EMCache_DiscoveryDataSourceKey];
                }
                [weakSelf.myCollectionView reloadData];
                if (index>0) {
                    [weakSelf performSelector:@selector(scrollToIndexPath:) withObject:[NSIndexPath indexPathForRow:index inSection:0] afterDelay:0.1];
                }
                
            }
            if (responseResult.cursor>=responseResult.totalPage) {
                [weakSelf.myCollectionView endRefreshingWithMessage:@"没有更多数据" eanbleRetry:NO];
            }else{
                [weakSelf.myCollectionView enableInfiniteScrolling:YES];
            }
        }else{
            if (weakSelf.dataSourceArray.count==0 ) {
                [weakSelf.myCollectionView showPageLoadedMessage:@"获取数据失败，点击重试" delegate:self];
            }else{
                [weakSelf.myCollectionView showHUDMessage:responseResult.responseMessage];
            }
        }
    }];
    [self addSessionTask:task];
}
- (void)scrollToIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0&& indexPath.row<[self.myCollectionView numberOfItemsInSection:0]) {
        [self.myCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
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
        mainView.showsVerticalScrollIndicator = YES;
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
