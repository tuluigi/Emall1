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
#import "EMGoodsListCell.h"
#import "EMHomeImageCell.h"
#import "EMHtmlFile.h"
#import <AVKit/AVPlayerViewController.h>
static CGFloat kOffPadding = 10;
typedef NS_ENUM(NSInteger , EMHomeColllecionSection) {
    EMHomeColllecionSectionShop             =0,//店铺介绍
    EMHomeColllecionSectionBanner           =1,//店铺介绍
    EMHomeColllecionSectionAnnouncement     =2,//公告
    EMHomeColllecionSectionCat              =3,//分类
    EMHomeColllecionSectionHotAndGreat      =4,//精品&特卖
};

@interface EMHomeViewController ()<EMInfiniteViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
EMHomeCatCellDelegate>
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
    self.navigationItem.title=@"嗨吃嗨购";
    self.view.backgroundColor = RGB(238,247,244);
    
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero );
    }];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"home_right_avatar"] style:UIBarButtonItemStylePlain target:self action:@selector(didHomeRighBarButtonPressed)];
    self.adArray=[EMCache em_objectForKey:EMCache_HomeADDataSourceKey];
    self.homeModel=[EMCache em_objectForKey:EMCache_HomeDataSourceKey];
    [self.myCollectionView reloadData];
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
    return EMHomeColllecionSectionHotAndGreat+1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=1;
    if (section==EMHomeColllecionSectionCat) {
        if (self.homeModel.catArray.count) {
            count=self.homeModel.catArray.count;
        }else{
            count =0;
        }
    }else if (section == EMHomeColllecionSectionHotAndGreat){
        count = 2;
    }
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *aCell;
    if (indexPath.section==EMHomeColllecionSectionCat) {
        EMHomeCatCell *cell=(EMHomeCatCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeCatCell class]) forIndexPath:indexPath];
        cell.catModel=self.homeModel.catArray[indexPath.row];
        aCell=cell;
    }else if (indexPath.section == EMHomeColllecionSectionBanner){
       EMInfiniteView* reusableView =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMInfiniteView class]) forIndexPath:indexPath];
        [(EMInfiniteView *)reusableView registerClass:[EMInfiniteViewCell class] forCellWithReuseIdentifier:NSStringFromClass([EMInfiniteViewCell class])];
        [(EMInfiniteView *)reusableView setTotalNumber:self.adArray.count];
        [(EMInfiniteView *)reusableView setDelegate:self];
        EMInfiniteView *infiniteView = (EMInfiniteView *)reusableView;
        infiniteView.layer.borderWidth=2;
        infiniteView.layer.borderColor=[UIColor whiteColor].CGColor;
        aCell= reusableView;
    }else{
        EMHomeImageCell *cell=(EMHomeImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeImageCell class]) forIndexPath:indexPath];
        if (indexPath.section == EMHomeColllecionSectionShop) {
             [cell setImageUrl:self.homeModel.signageImgUrl];
        }else if (indexPath.section == EMHomeColllecionSectionAnnouncement){
            [cell setImageUrl:self.homeModel.announcementImgUrl];
        }else if (indexPath.section == EMHomeColllecionSectionHotAndGreat){
            if (indexPath.row==0) {
                [cell setImage:[UIImage imageNamed:@"home_hotsale"]];
            }else{
                [cell setImage:[UIImage imageNamed:@"home_discountsale"]];
            }
        }
        aCell=cell;
    }
    return aCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    if (indexPath.section==EMHomeColllecionSectionShop) {
        size = CGSizeMake(OCWidth- kOffPadding*2.0, 70);
    }else if (indexPath.section == EMHomeColllecionSectionBanner){
        size = CGSizeMake(OCWidth- kOffPadding*2.0, 180);
    }if (indexPath.section==EMHomeColllecionSectionAnnouncement) {
        size = CGSizeMake(OCWidth- kOffPadding*2.0, 200);
    }else if(indexPath.section == EMHomeColllecionSectionCat){
        size = CGSizeMake((OCWidth-kOffPadding*3.0)/2.0, 100);
    }else if(indexPath.section == EMHomeColllecionSectionHotAndGreat){
        if (indexPath.row==0) {//热卖
            size = CGSizeMake((OCWidth-kOffPadding*2.0), 70);
        }else if (indexPath.row==1){//精品
           size = CGSizeMake((OCWidth-kOffPadding*2.0), 100);
        }
    }
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size=CGSizeZero;
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==EMHomeColllecionSectionHotAndGreat) {
        EMHomeReusableViewType type = EMHomeReusableViewTypeHot;
        NSString *catString = @"";
        if (indexPath.row==0) {
            type = EMHomeReusableViewTypeHot;
            catString = @"店铺热卖";
        }else if (indexPath.row==1){
            type = EMHomeReusableViewTypeGreat;
            catString = @"折扣特卖";
        }
        EMGoodsListViewController *listController=[[EMGoodsListViewController alloc]  initWithHomeType:type typeName:catString];
        listController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:listController animated:YES];
    }else if (indexPath.section == EMHomeColllecionSectionCat){
        EMCatModel *catModel = self.homeModel.catArray[indexPath.row];
        EMGoodsListViewController *listController=[[EMGoodsListViewController alloc]  initWithCatID:catModel.catID catName:catModel.catName];
        listController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:listController animated:YES];
    }
}
#pragma mark - EMHomeCatCell Delegate
- (void)homeCatCell:(EMHomeCatCell *)cell didSelectItem:(EMCatModel *)catModel{
    
    EMGoodsListViewController *listController=[[EMGoodsListViewController alloc]  initWithCatID:catModel.catID catName:catModel.catName];
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
    if (adModel.contentType == EMADContenTypeVideo) {
        if (adModel.adUrl == nil) {
            return;
        }
        NSURL *url=[NSURL URLWithString:adModel.adUrl];
        AVPlayerViewController *playerController=[[AVPlayerViewController alloc]  init];
        AVPlayer *avplayer=[AVPlayer playerWithURL:url];
        [avplayer play];
        playerController.player=avplayer;
        [self presentViewController:playerController animated:YES completion:^{
            
        }];
        /*
         NSString *filePath =[EMHtmlFile htmlStringWithVideoSrc:adModel.adUrl poster:nil];
        EMWebViewController *webController=[[EMWebViewController alloc]  initWithHtmlString:filePath title:nil];
        webController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webController animated:YES];
         */
    }else{
        if (![NSString isNilOrEmptyForString:adModel.adUrl]) {
            EMWebViewController *webController=[[EMWebViewController alloc]  initWithUrl:adModel.adUrl title:nil];
            webController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webController animated:YES];
        }
    }
   
}





#pragma mark - getter
-(EMInfiniteView *)infiniteView{
    if (nil==_infiniteView) {
        _infiniteView=[EMInfiniteView InfiniteViewWithFrame:CGRectMake(0, 0, OCWidth-2*kOffPadding, 180)];
        _infiniteView.delegate=self;
//        _infiniteView.collectionView.layer.borderWidth=2.0;
//        _infiniteView.collectionView.clipsToBounds= YES;
//        _infiniteView.collectionView.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    return _infiniteView;
}
- (UICollectionView *)myCollectionView{
    if (nil==_myCollectionView) {
        
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.minimumLineSpacing = kOffPadding;
        flowLayout.minimumInteritemSpacing=kOffPadding;
        flowLayout.sectionInset = UIEdgeInsetsMake(kOffPadding, kOffPadding, kOffPadding, kOffPadding);
//        flowLayout.estimatedItemSize=[EMGoodsListCell goodsListCellEstmitSize];////添加之后iOS8 会crash
//        flowLayout.itemSize=[EMGoodsListCell goodsListCellEstmitSize];
//        flowLayout.headerReferenceSize=CGSizeMake(OCWidth, [EMHomeHeadReusableView homeHeadReusableViewHeight]);//添加之后iOS8 会crash
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];

        mainView.backgroundColor = RGB(238, 237, 246);
        mainView.pagingEnabled = NO;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        _myCollectionView=mainView;
        [_myCollectionView registerClass:[EMHomeCatCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeCatCell class])];
        [_myCollectionView registerClass:[EMInfiniteView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([EMInfiniteView class])];
        [_myCollectionView registerClass:[EMHomeImageCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeImageCell class])];
         [_myCollectionView registerClass:[EMInfiniteView class] forCellWithReuseIdentifier:NSStringFromClass([EMInfiniteView class])];
    }
    return _myCollectionView;
}
@end
