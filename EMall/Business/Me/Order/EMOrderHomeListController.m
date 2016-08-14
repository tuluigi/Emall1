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
@interface EMOrderHomeListController ()<ZJScrollPageViewDelegate,UISearchBarDelegate>
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
}
- (NSArray *)titleArrayWithOrderStates:(NSArray *)orderSataArray{
    NSMutableArray *titleArray=[[NSMutableArray alloc]  init];
    for (EMOrderStateModel *stateModel in orderSataArray) {
        [titleArray addObject:stateModel.stateName];
    }
    return (NSArray *)titleArray;
}

#pragma mark -PageScrollView Delegate
- (NSInteger)numberOfChildViewControllers{
    return self.orderStateArray.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index{
    EMOrderListController <ZJScrollPageViewChildVcDelegate> *childVc = (EMOrderListController *)reuseViewController;
    if (!childVc) {
        childVc = [[EMOrderListController alloc] init];
    }
    EMOrderStateModel *stateModel=self.orderStateArray[index];
    childVc.orderState=stateModel.state;
    childVc.goodsName=self.searchBar.text;
    return childVc;
}
#pragma mark -searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
      [searchBar endEditing:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  [searchBar endEditing:YES];
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    [self.pageScrolView.contentView reloadData];
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
       
        //设置背景图片
        [_searchBar setBackgroundImage:[[UIImage imageNamed:@"searchBar_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10)]];
        //设置背景色
        [_searchBar setBackgroundColor:[UIColor clearColor]];
    }
    return _searchBar;
}

@end
