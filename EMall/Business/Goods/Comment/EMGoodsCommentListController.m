//
//  EMGoodsCommentListController.m
//  EMall
//
//  Created by Luigi on 16/7/27.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMGoodsCommentListController.h"
#import "EMGoodsCommentCell.h"
@interface EMGoodsCommentListController ()
@property (nonatomic,assign)NSInteger goodsID;
@end

@implementation EMGoodsCommentListController
- (instancetype)initWithGoodsID:(NSInteger)goodsID{
    self=[super init];
    if (self) {
        
    }
    return self;
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
