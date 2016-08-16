//
//  EMGoodsCommentHomeController.m
//  EMall
//
//  Created by Luigi on 16/8/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsCommentHomeController.h"
#import "EMGoodsCommentModel.h"
#import "EMGoodsNetService.h"
@interface EMGoodsCommentHomeController ()
<ZJScrollPageViewDelegate,UISearchBarDelegate>
@property (nonatomic,assign)NSInteger goodsID;
@property (nonatomic,strong)ZJScrollPageView *pageScrolView;
@property (nonatomic,strong)NSArray <EMCommentStarModel *>*orderStateArray;
@end

@implementation EMGoodsCommentHomeController
- (instancetype)initWithGoodsID:(NSInteger)goodsID{
    self=[super init];
    if (self) {
        
    }
    return self;
}
//- (void)viewDidLoad{
//    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets=YES;
//    self.navigationItem.title=@"我的商品评论";
//
//    [self.view addSubview:self.pageScrolView];
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"_state=%ld",self.currentOrderState];
//    NSArray *tempArray=[self.orderStateArray filteredArrayUsingPredicate:predicate];
//    if (tempArray&&tempArray.count) {
//        NSInteger index=[self.orderStateArray indexOfObject:[tempArray firstObject]];
//        [self.pageScrolView.contentView setContentOffSet:CGPointMake(OCWidth*index, 0) animated:NO];
//        [self.pageScrolView setSelectedIndex:index animated:NO];
//    }
//
//#pragma mark -PageScrollView
//- (ZJScrollPageView *)pageScrolView{
//    if (nil==_pageScrolView) {
//        ZJSegmentStyle *segmentStyle=[[ZJSegmentStyle alloc]  init];
//        segmentStyle.showLine=YES;
//        segmentStyle.titleFont=[UIFont oc_systemFontOfSize:OCUISCALE(13)];
//        UIColor *color=[UIColor colorWithHexString:@"#272727"];
//        segmentStyle.normalTitleColor=color;
//        segmentStyle.selectedTitleColor=color;
//        segmentStyle.scrollLineColor=RGB(229, 24, 31);
//        NSArray *titleArray=@[];
//        _pageScrolView=[[ZJScrollPageView alloc]  initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) segmentStyle:segmentStyle titles:titleArray parentViewController:self delegate:self];
//    }
//    return _pageScrolView;
//}
@end
