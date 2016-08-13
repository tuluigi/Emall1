//
//  EMCitySelectViewController.m
//  EMall
//
//  Created by Luigi on 16/8/12.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCitySelectViewController.h"
#import "EMCityViewController.h"
#import "ZJScrollPageView.h"
#import "EMMeNetService.h"
#import "EMAreaModel.h"
static NSInteger const kNumberOfCoulum  =4;//一共最多4级
@interface EMCitySelectViewController ()<ZJScrollPageViewDelegate,UISearchBarDelegate,EMCityViewControlelrDelegate>
@property (nonatomic,strong)ZJScrollPageView *pageScrolView;
@property (nonatomic,strong)NSMutableArray <NSMutableArray *>*dataSource;
@property (nonatomic,strong)NSMutableArray <NSString *>*titleArray;
@property (nonatomic,strong)NSMutableArray <EMAreaModel *>*selectAreaArray;

@end

@implementation EMCitySelectViewController
@synthesize titleArray= _titleArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationItem.title=@"地区选择";
    
    //    [self.pageScrolView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_equalTo(UIEdgeInsetsZero);
    //    }];
    [self getAddressListWithParentAreaModel:nil pageIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTitleArray:(NSMutableArray *)titleArray{
    _titleArray=titleArray;
    [self.pageScrolView reloadWithNewTitles:_titleArray];
}
- (void)getAddressListWithParentAreaModel:(EMAreaModel *)areaModel pageIndex:(NSInteger )pageIndex{
    NSInteger parentID=areaModel.areaID;
    
    WEAKSELF
    if (parentID==0) {
        [self.view showPageLoadingView];
    }else{
        [weakSelf.pageScrolView.contentView showPageLoadingView];
    }
    NSURLSessionTask *task=[EMMeNetService getAreaWithParentID:parentID onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.view dismissHUDLoading];
        if (parentID==0) {
            [weakSelf.view dismissPageLoadView];
        }else{
            [weakSelf.pageScrolView.contentView dismissPageLoadView];
        }
        
        if (responseResult.responseCode==OCCodeStateSuccess) {
            NSArray *array=responseResult.responseData;
            if (array.count) {
                
                if (pageIndex>0) {
                    [areaModel.childAreaArray removeAllObjects];
                    [areaModel.childAreaArray addObjectsFromArray:array];
                    [weakSelf.selectAreaArray addObject:areaModel];
                    [weakSelf reloadSegmentViewTitleArray:weakSelf.titleArray selectIndex:pageIndex];
                    [weakSelf.pageScrolView.contentView reloadData];
                    [weakSelf.pageScrolView.contentView setContentOffSet:CGPointMake((OCWidth*(pageIndex)), 0) animated:YES];
                }else{
                    [weakSelf.dataSource addObjectsFromArray:responseResult.responseData];
                    weakSelf.titleArray=[[NSMutableArray alloc]  initWithObjects:@"请选择", nil];
                    [weakSelf.view addSubview:weakSelf.pageScrolView];
                }
            }else{//没有了
                
            }
            
        }else{
            if (parentID==0) {
                [weakSelf.view showPageLoadedMessage:@"获取地区失败,点击重试" delegate:self];
            }else{
                [weakSelf.pageScrolView.contentView showPageLoadedMessage:@"获取地区失败,点击重试" delegate:self];
            }
            
        }
    }];
    [self addSessionTask:task];
}
-(void)ocPageLoadedViewOnTouced{
    
}
#pragma mark -PageScrollView Delegate
- (NSInteger)numberOfChildViewControllers{
    NSInteger row= self.selectAreaArray.count+1;
    if (row>kNumberOfCoulum) {
        row=kNumberOfCoulum;
    }
    return row;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index{
    EMCityViewController <ZJScrollPageViewChildVcDelegate> *childVc = (EMCityViewController *)reuseViewController;
    if (!childVc) {
        childVc = [[EMCityViewController alloc] init];
        childVc.delegate=self;
    }
    NSInteger row=0;
    
    NSMutableArray *dataSource;
    if (index==0) {
        dataSource=self.dataSource;
    }else{
        EMAreaModel *areaModel=self.selectAreaArray[MAX(index-1, 0)];
        dataSource=areaModel.childAreaArray;
    }
    if (self.selectAreaArray.count>index) {
        
        row=[dataSource indexOfObject:self.selectAreaArray[MAX(index-1, 0)]];
    }
    [childVc setAreas:dataSource selectIndex:row];
    return childVc;
}
- (void)pageScrollView:(ZJScrollPageView *)pageView didTitleSelected:(NSString *)title titleIndex:(NSInteger)pageIndex{
    
}
#pragma mark - city select delegate
- (void)cityViewControllerDidSelectWithAreadModel:(EMAreaModel *)aremModel
                                         pageInde:(NSInteger )pageIndex
                                        isAnother:(BOOL)isAnother
                                     isUserSelect:(BOOL)isSelect{
    
    NSString *name=aremModel.areaName;
    if (pageIndex>=kNumberOfCoulum) {
        return;
    }else if (pageIndex==kNumberOfCoulum-1) {
        if (isSelect&&isAnother) {
            [self.titleArray replaceObjectAtIndex:self.titleArray.count-1 withObject:name];
            if (self.selectAreaArray.count>pageIndex) {
                [self.selectAreaArray replaceObjectAtIndex:self.selectAreaArray.count-1 withObject:aremModel];
            }else{
                [self.selectAreaArray addObject:aremModel];
            }
            [self.pageScrolView.contentView reloadData];
            [self reloadSegmentViewTitleArray:self.titleArray selectIndex:pageIndex];
        }
    }else{
        if (self.titleArray.count>pageIndex&& isSelect) {
            NSRange rang=NSMakeRange(pageIndex, self.titleArray.count-pageIndex);
            [self.titleArray removeObjectsInRange:rang];
            [self.titleArray addObject:name];
            [self.titleArray addObject:@"请选择"];
        }
        if (isAnother) {
            
        }
        if (self.selectAreaArray.count>pageIndex) {
            [self.selectAreaArray removeObjectsInRange:NSMakeRange(pageIndex, self.selectAreaArray.count-pageIndex)];
            [self.pageScrolView.contentView reload];//由于有重用，当点击之前已经选过的，需要把所有controller给删除然后在reload
        }
        
        if (aremModel.childAreaArray.count) {
            [self.selectAreaArray addObject:aremModel];
            [self.pageScrolView.contentView reloadData];
            [self reloadSegmentViewTitleArray:self.titleArray selectIndex:pageIndex++];
            [self.pageScrolView.contentView setContentOffSet:CGPointMake((OCWidth*(pageIndex+1)), 0) animated:YES];
        }else{
             [self.pageScrolView.contentView reloadData];
            [self getAddressListWithParentAreaModel:aremModel  pageIndex:pageIndex+1];
        }
    }
}
- (void)reloadSegmentViewTitleArray:(NSMutableArray *)titleArray selectIndex:(NSInteger)index{
    [self.pageScrolView.segmentView reloadTitlesWithNewTitles:titleArray];
    [self.pageScrolView setSelectedIndex:index animated:NO];
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
        
        _pageScrolView=[[ZJScrollPageView alloc]  initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64) segmentStyle:segmentStyle titles:self.titleArray parentViewController:self delegate:self];
    }
    return _pageScrolView;
}
-(NSMutableArray *)dataSource{
    if (nil==_dataSource) {
        _dataSource=[NSMutableArray new];
    }
    return _dataSource;
}
- (NSMutableArray<EMAreaModel *> *)selectAreaArray{
    if (nil==_selectAreaArray) {
        _selectAreaArray=[NSMutableArray new];
    }
    return _selectAreaArray;
}
-(NSMutableArray<NSString *> *)titleArray{
    if (nil==_titleArray) {
        _titleArray=[NSMutableArray new];
    }
    return _titleArray;
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
