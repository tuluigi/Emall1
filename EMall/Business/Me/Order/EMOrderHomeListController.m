//
//  EMOrderHomeListController.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderHomeListController.h"
#import "ZJScrollPageView.h"
#import "EMOrderListController.h"
#import "UITextField+HiddenKeyBoardButton.h"
#import "EMOrderDetailController.h"
#import "EMShopCartNetService.h"
@interface EMOrderHomeListController ()<ZJScrollPageViewDelegate,UISearchBarDelegate,EMOrderListControllerDelegate>
@property (nonatomic,strong)ZJScrollPageView *pageScrolView;
@property (nonatomic,strong)NSArray <EMOrderStateModel *>*orderStateArray;
@property (nonatomic,assign)EMOrderState currentOrderState;
@property (nonatomic,strong)UISearchBar *searchBar;
@end

@implementation EMOrderHomeListController
- (instancetype)initWithOrderState:(EMOrderState)orderState{
    self=[super init];
    if (self) {
        self.currentOrderState=orderState;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationItem.title=@"我的订单";
    self.orderStateArray=[EMOrderStateModel orderStateModelArray];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.pageScrolView];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"_state=%ld",self.currentOrderState];
    NSArray *tempArray=[self.orderStateArray filteredArrayUsingPredicate:predicate];
    if (tempArray&&tempArray.count) {
        NSInteger index=[self.orderStateArray indexOfObject:[tempArray firstObject]];
        [self.pageScrolView.contentView setContentOffSet:CGPointMake(OCWidth*index, 0) animated:NO];
        [self.pageScrolView setSelectedIndex:index animated:NO];
    }
    
    WEAKSELF
   
    [[NSNotificationCenter defaultCenter] addObserverForName:kEMOrderGotoOrderDetailEvent object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        EMOrderModel *orderModel=note.object;
        if ([orderModel isKindOfClass:[EMOrderModel class]]) {
            [weakSelf orderListControllerDidSelecOrder:orderModel];
        }
        
    }];
}
- (NSInteger)currentSelectSegmentInde{
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"_state=%ld",self.currentOrderState];
        NSArray *tempArray=[self.orderStateArray filteredArrayUsingPredicate:predicate];
        if (tempArray&&tempArray.count) {
            NSInteger index=[self.orderStateArray indexOfObject:[tempArray firstObject]];
            return index;
        }
        return 0;
  }
- (NSArray *)titleArrayWithOrderStates:(NSArray *)orderSataArray{
    NSMutableArray *titleArray=[[NSMutableArray alloc]  init];
    for (EMOrderStateModel *stateModel in orderSataArray) {
        [titleArray addObject:stateModel.stateName];
    }
    return (NSArray *)titleArray;
}
- (void)addShopCartWithGoodsID:(NSInteger)goodsID infoID:(NSInteger)specID buyCount:(NSInteger)buyCount{
    WEAKSELF
    if ([RI isLogined]) {
//        [self.view showHUDLoading];
        NSURLSessionTask *task=[EMShopCartNetService addShopCartWithUserID:[RI userID] infoID:specID buyCount:buyCount onCompletionBlock:^(OCResponseResult *responseResult) {
            //        [weakSelf.view dismissHUDLoading];
            if (responseResult.responseCode==OCCodeStateSuccess) {
                [weakSelf.view showHUDMessage:@"添加到购物车成功"];
            }else{
                [weakSelf.view showHUDMessage:@"添加失败"];
            }
        }];
        [self addSessionTask:task];
    }else{
        [self showLoginControllerOnCompletionBlock:^(BOOL isSucceed) {
            if (isSucceed) {
                [weakSelf addShopCartWithGoodsID:goodsID infoID:specID buyCount:buyCount];
            }
        }];
    }
}
#pragma mark -PageScrollView Delegate
- (NSInteger)numberOfChildViewControllers{
    return self.orderStateArray.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index{
    EMOrderListController <ZJScrollPageViewChildVcDelegate> *childVc = (EMOrderListController *)reuseViewController;
    if (!childVc) {
        childVc = [[EMOrderListController alloc] init];
        childVc.delegate=self;
    }
    EMOrderStateModel *stateModel=self.orderStateArray[index];
    childVc.orderState=stateModel.state;
    NSString *goodsName=nil;
    if (index==[self currentOrderState]) {
        goodsName=self.searchBar.text;
    }else{
        self.searchBar.text=nil;
    }
    [childVc setOrderState:stateModel.state goodsName:goodsName];
    return childVc;
}
- (void)orderListControllerDidSelecOrder:(EMOrderModel *)orderModel{
    EMOrderDetailController *detailController=[[EMOrderDetailController alloc]  initWithOrderID:orderModel.orderID];
    detailController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailController animated:YES];
}


#pragma mark -searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
      [searchBar endEditing:YES];
  //  NSInteger index=[self currentSelectSegmentInde];
  EMOrderListController *listController = (EMOrderListController *)self.pageScrolView.contentView.currentChildVc;
    [listController reloadDataWithOrderState:self.currentOrderState goodsName:self.searchBar.text];

//    [self.pageScrolView.contentView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  [searchBar endEditing:YES];
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
}

#pragma mark -PageScrollView
- (ZJScrollPageView *)pageScrolView{
    if (nil==_pageScrolView) {
        ZJSegmentStyle *segmentStyle=[[ZJSegmentStyle alloc]  init];
        segmentStyle.showLine=YES;
        segmentStyle.titleFont=[UIFont oc_systemFontOfSize:OCUISCALE(13)];
        UIColor *color=[UIColor colorWithHexString:@"#272727"];
        segmentStyle.normalTitleColor=color;
        segmentStyle.selectedTitleColor=color;
        segmentStyle.scrollLineColor=RGB(229, 24, 31);
        NSArray *titleArray=[self titleArrayWithOrderStates:self.orderStateArray];
        _pageScrolView=[[ZJScrollPageView alloc]  initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.searchBar.frame)) segmentStyle:segmentStyle titles:titleArray parentViewController:self delegate:self];
    }
    return _pageScrolView;
}
- (UISearchBar *)searchBar{
    if (nil==_searchBar) {
        _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(OCUISCALE(13), OCUISCALE(15)+CGRectGetHeight(self.navigationController.navigationBar.bounds)+20, OCWidth-OCUISCALE(13*2), OCUISCALE(30))];
        _searchBar.showsCancelButton=NO;
        _searchBar.backgroundColor=[UIColor whiteColor];
        _searchBar.delegate=self;
        _searchBar.returnKeyType=UIReturnKeySearch;
        _searchBar.placeholder=@"输入关键字搜索历史订单";
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        [searchField addHiddenKeyBoardInputAccessView];

        //设置背景图片
        [_searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] ]];

          [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBar_background"] forState:UIControlStateNormal];
        //设置背景色
        [_searchBar setBackgroundColor:[UIColor clearColor]];
    }
    return _searchBar;
}

@end
