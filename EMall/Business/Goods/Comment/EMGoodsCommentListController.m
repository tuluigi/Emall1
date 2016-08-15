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
@interface EMGoodsCommentListController ()
@property (nonatomic,assign)NSInteger goodsID;
@end

@implementation EMGoodsCommentListController
- (instancetype)initWithGoodsID:(NSInteger)goodsID{
    self=[super init];
    if (self) {
        _goodsID=goodsID;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"商品评价";
    [self getGoodsCommentListWithGoodsID:self.goodsID];
}

- (void)getGoodsCommentListWithGoodsID:(NSInteger)goodsID{
    [self.tableView showPageLoadingView];
    for (NSInteger i=0 ; i<20;i++) {
        EMGoodsCommentModel *commentModel=[[EMGoodsCommentModel alloc]  init];
        commentModel.userID=1;
        commentModel.nickName=@"幸福的小吃货";
        commentModel.userAvatar=@"http://u3.tdimg.com/8/166/12/_42729752116303126665090711325153380278.jpg";
        commentModel.content=@"这件商品真的挺不错的，买了之后使用起来很好，很方便，强烈推荐大家都来购买";
        commentModel.level=3;
        [self.dataSourceArray addObject:commentModel];
    }
    [self.tableView dismissPageLoadView];
    [self.tableView reloadData];
}
- (void)getGoodsCommentListWithGoodsID:(NSInteger)goodID cursor:(NSInteger)cursor:(NSInteger)cursor{
//    NSURLSessionTask *task=[emgoodsnetse];
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
