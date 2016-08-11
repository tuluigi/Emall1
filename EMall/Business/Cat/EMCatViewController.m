//
//  EMCatViewController.m
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCatViewController.h"
#import "EMCatModel.h"
#import "EMCatNetService.h"
#import "EMCatItemCell.h"
#import "EMGoodsListViewController.h"
#define  kTableViewWidth         OCUISCALE(100)

@interface EMCatViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UICollectionView *myCollectionView;

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)__block NSMutableArray *collectDataSource;
@end

@implementation EMCatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"分类";
    // Do any additional setup after loading the view.
    //    self.automaticallyAdjustsScrollViewInsets=YES;
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, kTableViewWidth+10, 0, 10) );
    }];
    [self getCatListWithCatIDModel:nil];
}
- (void)getCatListWithCatIDModel:(EMCatModel *)catModel{
    if (self.dataSource.count==0) {
        [self.view showPageLoadingView];
    }
    WEAKSELF
    NSURLSessionTask *task=[EMCatNetService getCatListWithParentID:catModel.catID onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.view dismissPageLoadView];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            if (((NSMutableArray *)responseResult.responseData).count) {
                if (catModel) {
                    [catModel.childCatArray addObjectsFromArray:responseResult.responseData];
                    [weakSelf.collectDataSource removeAllObjects];
                    [weakSelf.collectDataSource addObjectsFromArray:catModel.childCatArray];
                    [weakSelf.myCollectionView reloadData];
                }else{
                    [weakSelf.dataSource addObjectsFromArray:responseResult.responseData];
                    [weakSelf getCatListWithCatIDModel:[weakSelf.dataSource firstObject]];
                    [weakSelf.tableview reloadData];
                }
            }
        }else{
            if (weakSelf.dataSource.count==0) {
                [weakSelf.view showPageLoadedMessage:@"获取失败" delegate:weakSelf];
            }else{
                [weakSelf.view showHUDMessage:@"获取失败"];
            }
        }
    }];
    [self addSessionTask:task];
}
-(void)ocPageLoadedViewOnTouced{
    [self getCatListWithCatIDModel:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *idenfier=@"cellidenfier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:idenfier];
    if (nil==cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor=kEM_GrayDarkTextColor;
        cell.textLabel.font=[UIFont oc_boldSystemFontOfSize:14];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.separatorInset=UIEdgeInsetsZero;
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    EMCatModel *catModel=[self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text=catModel.catName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __block  EMCatModel *catModel=[self.dataSource objectAtIndex:indexPath.row];
    [self.collectDataSource removeAllObjects];
    [self.collectDataSource addObjectsFromArray:catModel.childCatArray];
    [self.myCollectionView reloadData];
    if (!catModel.childCatArray.count) {
        [self getCatListWithCatIDModel:catModel];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=self.collectDataSource.count;
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EMCatItemCell *cell=(EMCatItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMCatItemCell class]) forIndexPath:indexPath];
    cell.catModel=self.collectDataSource[indexPath.row];
    return cell;
}
-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize size = flowLayout.itemSize;
    //    CGSize size=CGSizeZero;
    //    size.width=(OCWidth-kTableViewWidth)/3.0;
    //    size.height=size.width;
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView;
    reusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size=CGSizeZero;
    size=CGSizeMake(OCWidth, 20);
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size=CGSizeZero;
    size=CGSizeMake(OCWidth, 20);
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EMCatModel *catModel=[self.collectDataSource objectAtIndex:indexPath.row];
    EMGoodsListViewController *listController=[[EMGoodsListViewController alloc]  initWithCatID:catModel.catID];
    listController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:listController animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableView *)tableview{
    if (nil==_tableview) {
        _tableview=[[UITableView alloc]  initWithFrame:CGRectMake(0, 0, kTableViewWidth, CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.separatorInset=UIEdgeInsetsZero;
        _tableview.tableFooterView=[UIView new];
    }
    return _tableview;
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.estimatedItemSize=CGSizeMake(1, 1);
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(kTableViewWidth, 0, OCWidth-kTableViewWidth, CGRectGetHeight(self.view.bounds)) collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor whiteColor];
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMCatItemCell class] forCellWithReuseIdentifier:NSStringFromClass([EMCatItemCell class])];
        
        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    }
    return _myCollectionView;
}
-(NSMutableArray *)dataSource{
    if (nil==_dataSource) {
        _dataSource=[[NSMutableArray alloc]  init];
    }
    return _dataSource;
}
- (NSMutableArray *)collectDataSource{
    if (nil==_collectDataSource) {
        _collectDataSource=[[NSMutableArray alloc]  init];
    }
    return _collectDataSource;
    
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
