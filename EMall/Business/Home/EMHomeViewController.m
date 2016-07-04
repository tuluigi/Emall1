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
#import "EMGoodsItemView.h"
@interface EMHomeViewController ()<EMInfiniteViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)EMInfiniteView *infiniteView;
@property (nonatomic,strong)NSMutableArray *adArray;
@property (nonatomic,strong)EMHomeModel *homeModel;

@property (nonatomic,strong)UICollectionView *myCollectionView;

@end

@implementation EMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"海吃GO";
//    self.tableView.tableHeaderView=self.infiniteView;
//    [self.tableView registerClass:[EMHomeCatCell class] forCellReuseIdentifier:NSStringFromClass([EMHomeCatCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count=0;
    if (section==0) {
        count=1;
    }else if (section==1||section==2){
        count=2;
    }
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *aCell;
    if (indexPath.section==0) {
        EMHomeCatCell *cell=(EMHomeCatCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EMHomeCatCell class]) forIndexPath:indexPath];
        cell.catModelArray=self.homeModel.catArray;
    }else if(indexPath.section==1){
    
    }else if (indexPath.section==2){
    
    }else{
        aCell=[[UICollectionViewCell alloc]  init];
    }
    return aCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
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
        EMHomeCatCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMHomeCatCell class]) forIndexPath:indexPath];
        cell.catModelArray=self.homeModel.catArray;
        aCell=cell;
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
        UICollectionView *mainView = [[UICollectionView alloc] init];
        mainView.collectionViewLayout=flowLayout;
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = YES;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        [mainView registerClass:[EMHomeCatCell class] forCellWithReuseIdentifier:NSStringFromClass([EMHomeCatCell class])];
         [mainView registerClass:[EMGoodsItemView class] forCellWithReuseIdentifier:NSStringFromClass([EMGoodsItemView class])];
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        _myCollectionView=mainView;
    }
    return _myCollectionView;
}
@end
