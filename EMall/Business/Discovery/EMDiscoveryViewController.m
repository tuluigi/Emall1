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
#import "EMDiscoveryHeadView.h"
#import "UITextField+HiddenKeyBoardButton.h"
@interface EMDiscoveryViewController ()<
            UICollectionViewDelegate,
            UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout,UISearchBarDelegate
                >
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,strong)__block NSMutableArray *dataSourceArray;
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,assign)__block NSInteger totalCount;
@end

@implementation EMDiscoveryViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataSourceArray.count==0) {
        [self getGoodsListWithCursor:self.cursor goodsName:self.searchBar.text];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"发现";
   self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.myCollectionView];
    
    WEAKSELF
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.searchBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(weakSelf.view);
    }];
    [self getGoodsListWithCursor:self.cursor goodsName:nil];
    [weakSelf.myCollectionView addOCPullDownResreshWithTitle:@"零食小点 进口糖果 美味生鲜 ..." onHandler:^{
        weakSelf.cursor=1;
        [weakSelf getGoodsListWithCursor:weakSelf.cursor goodsName:self.searchBar.text];
    }];
    [weakSelf.myCollectionView addOCPullInfiniteScrollingHandler:^{
        weakSelf.cursor++;
        [weakSelf getGoodsListWithCursor:weakSelf.cursor goodsName:self.searchBar.text];
    }];
    [self.myCollectionView startPullDownRefresh];
}
- (void)getGoodsListWithCursor:(NSInteger )cursor goodsName:(NSString *)goodsName{
    WEAKSELF
   NSURLSessionTask *task= [EMGoodsNetService getGoodsListWithSearchGoodsID:0 catID:0 searchName:goodsName aesc:0 sortType:0 homeType:0 pid:cursor pageSize:20 onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.myCollectionView dismissPageLoadView];
        [weakSelf.myCollectionView stopRefreshAndInfiniteScrolling];
        if (responseResult.cursor>=responseResult.totalPage) {
            [weakSelf.myCollectionView enableInfiniteScrolling:NO];
        }
        weakSelf.totalCount=responseResult.totalRow;
        if (responseResult.responseCode==OCCodeStateSuccess) {
            if (cursor<2) {
                [weakSelf.dataSourceArray removeAllObjects];
            }
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
    [self getGoodsListWithCursor:self.cursor goodsName:self.searchBar.text];
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size=CGSizeMake(OCWidth, OCUISCALE(30));
    if (!self.searchBar.text.length) {
        size.height=0;
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    if (kind==UICollectionElementKindSectionHeader) {
        reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([EMDiscoveryHeadView class]) forIndexPath:indexPath];
        EMDiscoveryHeadView *specHeadView=(EMDiscoveryHeadView *)reusableView;
        specHeadView.title=[NSString stringWithFormat:@"为您搜索到%ld条结果",self.totalCount];
    }else if (kind==UICollectionElementKindSectionFooter){
        reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size=CGSizeZero;
    return size;
}
#pragma mark -searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
   [self.myCollectionView startPullDownRefresh];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    self.cursor=1;
    [self getGoodsListWithCursor:self.cursor goodsName:self.searchBar.text];
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
         [_myCollectionView registerClass:[EMDiscoveryHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([EMDiscoveryHeadView class])];
    }
    return _myCollectionView;
}
-(NSMutableArray *)dataSourceArray{
    if (nil==_dataSourceArray) {
        _dataSourceArray=[[NSMutableArray alloc]  init];
    }
    return _dataSourceArray;
}
- (UISearchBar *)searchBar{
    if (nil==_searchBar) {
        UIImage *searchBgImage=[UIImage imageNamed:@"search_bg"];
        _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, OCWidth,50)];
        _searchBar.showsCancelButton=NO;
        _searchBar.backgroundColor=[UIColor whiteColor];
        _searchBar.delegate=self;
        _searchBar.returnKeyType=UIReturnKeySearch;
        _searchBar.placeholder=@"输入关键词搜索你的小心愿";
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        [searchField addHiddenKeyBoardInputAccessView];
        UIImage *image = [UIImage imageNamed:@"search_btn"];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:image];
        iconView.frame = CGRectMake(0, 0, image.size.width , image.size.height);
        searchField.leftView = iconView;
        //设置背景图片
        [_searchBar setBackgroundImage:[[UIImage imageNamed:@"search_result_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)]];
          [_searchBar setSearchFieldBackgroundImage:searchBgImage forState:UIControlStateNormal];
        //设置背景色
        [_searchBar setBackgroundColor:[UIColor whiteColor]];
    }
    return _searchBar;
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
