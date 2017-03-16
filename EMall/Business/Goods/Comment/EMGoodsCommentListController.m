//
//  EMGoodsCommentListController.m
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsCommentListController.h"
#import "EMGoodsCommentCell.h"
#import "EMGoodsCommentModel.h"
#import "EMGoodsNetService.h"

static NSInteger kStarNumber    =4;
@interface EMGoodsCommentListController ()
@property (nonatomic,assign)NSInteger goodsID,star;
@property (nonatomic,strong)UISegmentedControl *segmentControll;
@property (nonatomic,strong)NSMutableArray *starArray;

@end

@implementation EMGoodsCommentListController
@synthesize goodsID=_goodsID;
- (instancetype)initWithGoodsID:(NSInteger)goodsID star:(NSInteger)star{
    self=[super init];
    if (self) {
        [self setGoodsID:goodsID star:_star];
    }
    return self;
}
- (NSMutableArray *)starArray{
    if (nil==_starArray) {
        _starArray=[NSMutableArray arrayWithCapacity:kStarNumber+1];
        for (NSInteger i=kStarNumber+1; i>=1; i--) {
            EMCommentStarModel *starModel=[[EMCommentStarModel alloc]  init];
            starModel.star=i;
            starModel.index=i;
            starModel.startNum=0;
            [_starArray insertObject:starModel atIndex:kStarNumber+1-i];
        }
    }
    return _starArray;
}
-(UISegmentedControl *)segmentControll{
    if (nil==_segmentControll) {
        _segmentControll=[[UISegmentedControl alloc]  initWithItems:@[@"全部",@"好评",@"中评",@"差评"]];
        _segmentControll.selected=0;
        [_segmentControll setSelectedSegmentIndex:0];
        UIImage *selectDividerImage=[UIImage imageWithColor:kEM_LightDarkTextColor];
        [_segmentControll setDividerImage:[UIImage imageWithColor:RGB(218, 218, 218)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
          [_segmentControll setDividerImage:selectDividerImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
          [_segmentControll setDividerImage:selectDividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
          [_segmentControll setDividerImage:selectDividerImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [_segmentControll setBackgroundImage:[UIImage imageNamed:@"search_result_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentControll setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
         [_segmentControll setTitleTextAttributes:@{NSForegroundColorAttributeName:kEM_LightDarkTextColor} forState:UIControlStateNormal];
        [_segmentControll addTarget:self action:@selector(didSegmentControlSelected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControll;
}
- (void)setGoodsID:(NSInteger)goodsID star:(NSInteger)star{
    _goodsID=goodsID;
    _star=star;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.title=@"商品评价";
    [self.view addSubview:self.segmentControll];

    WEAKSELF
    [self.segmentControll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(20);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-20);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(10);
        make.height.mas_equalTo(30);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.removeExisting=YES;
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.segmentControll.mas_bottom).offset(10);
    }];
    [self.tableView addOCPullDownResreshHandler:^{
        weakSelf.cursor=1;
        [weakSelf getGoodsCommentListWithGoodsID:weakSelf.goodsID cursor:weakSelf.cursor star:1];
    }];
    [self.tableView addOCPullInfiniteScrollingHandler:^{
        weakSelf.cursor++;
        [weakSelf getGoodsCommentListWithGoodsID:weakSelf.goodsID cursor:weakSelf.cursor star:1];
    }];
    [self.tableView startPullDownRefresh];

}
- (void)didSegmentControlSelected:(UISegmentedControl *)sender{
    [self.tableView startPullDownRefresh];
}
- (void)resetSegmentTitles:(NSArray <EMCommentStarModel *>*)aArray{
    NSInteger totalComment=0;
    WEAKSELF
    if (aArray!=self.starArray) {
        for (EMCommentStarModel *starModel in aArray) {
            for (EMCommentStarModel *model in weakSelf.starArray) {
                if (model.star==starModel.star) {
                    model.startNum=starModel.startNum;
                    break;
                }
            }
            totalComment+=starModel.startNum;
        }
    }

    NSMutableArray *titlesArray=self.starArray;;
    NSInteger offx=(NSInteger)( fabs(self.segmentControll.numberOfSegments-titlesArray.count) );
    if (titlesArray.count>self.segmentControll.numberOfSegments) {
        for (NSInteger i=0; i<offx; i++) {
            NSInteger index=i+self.segmentControll.numberOfSegments-1;
            EMCommentStarModel *starModel=titlesArray[index];
            [self.segmentControll insertSegmentWithTitle:starModel.starString atIndex:index animated:NO];
        }
    }else if (titlesArray.count<self.segmentControll.numberOfSegments){
        for (NSInteger i=0; i<offx; i++) {
            NSInteger index=i+self.segmentControll.numberOfSegments-1;
            [self.segmentControll removeSegmentAtIndex:index animated:NO];
        }
    }else{
        for (EMCommentStarModel *starModel in titlesArray) {
            if (starModel.star<titlesArray.count) {
               [self.segmentControll setTitle:starModel.starString forSegmentAtIndex:starModel.star];
            }
        }
    }
}
- (void)getGoodsCommentListWithGoodsID:(NSInteger)goodID cursor:(NSInteger)cursor star:(NSInteger)star{
    WEAKSELF
    NSURLSessionTask *task=[EMGoodsNetService getGoodsComemntsWithUserID:[RI userID] goodsID:_goodsID star:(kStarNumber-self.segmentControll.selectedSegmentIndex) cursor:cursor pageSize:20 onCompletionBlock:^(OCResponseResult *responseResult) {
        weakSelf.cursor=responseResult.cursor;
        if (responseResult.cursor>=responseResult.totalPage) {
            [weakSelf.tableView enableInfiniteScrolling:NO];
        }else{
            [weakSelf.tableView enableInfiniteScrolling:YES];
        }
        [weakSelf.tableView stopRefreshAndInfiniteScrolling];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            EMGoodsCommentHomeModel *homeComment=responseResult.responseData;
//            [weakSelf resetSegmentTitles:homeComment.startArray];
            if (cursor<=1) {
                [weakSelf.dataSourceArray removeAllObjects];
            }
            [weakSelf.dataSourceArray addObjectsFromArray:homeComment.commentArray];
            [weakSelf.tableView reloadData];
            if (homeComment.commentArray.count==0) {
                [weakSelf.tableView showHUDMessage:@"暂无评论"];
            }
        }else{
            [weakSelf.tableView showHUDMessage:responseResult.responseMessage];
        }
    }];
    [self addSessionTask:task];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView registerClass:[EMGoodsCommentCell class] forCellReuseIdentifier:NSStringFromClass([EMGoodsCommentCell class])];
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMGoodsCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMGoodsCommentCell class]) forIndexPath:indexPath];
    cell.goodsCommentModel=self.dataSourceArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=0;
  __block  EMGoodsCommentModel *goodsCommentModel=self.dataSourceArray[indexPath.row];
    height=[tableView fd_heightForCellWithIdentifier:NSStringFromClass([EMGoodsCommentCell class]) configuration:^(id cell) {
        [(EMGoodsCommentCell *)cell setGoodsCommentModel:goodsCommentModel];
    }];
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return OCUISCALE(60);
}
@end
