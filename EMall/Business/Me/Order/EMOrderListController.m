//
//  EMOrderListController.m
//  EMall
//
//  Created by Luigi on 16/7/17.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMOrderListController.h"
#import "EMOrderListCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "EMOrderNetService.h"
@interface EMOrderListController ()<EMOrderListCellDelegate,UIGestureRecognizerDelegate,EMOrderListCellDelegate>

@end

@implementation EMOrderListController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[EMOrderListCell class] forCellReuseIdentifier:NSStringFromClass([EMOrderListCell class])];

    WEAKSELF
    [self.tableView addOCPullDownResreshHandler:^{
        weakSelf.cursor=1;
        [weakSelf getOrderListWithOrderState:weakSelf.orderState];
    }];
    [self.tableView addOCPullInfiniteScrollingHandler:^{
        weakSelf.cursor++;
        [weakSelf getOrderListWithOrderState:weakSelf.orderState];
    }];
    [self.tableView startPullDownRefresh];
}
- (void)setOrderState:(EMOrderState)orderState{
    _orderState=orderState;
}
- (void)setOrderState:(EMOrderState )orderState goodsName:(NSString *)goodsName{
    self.orderState=orderState;
    self.goodsName=goodsName;
    if (_tableView&&self.dataSourceArray.count==0) {
        [self.tableView startPullDownRefresh];
    }
}
- (void)reloadDataWithOrderState:(EMOrderState )orderState goodsName:(NSString *)goodsName{
    [self setOrderState:orderState goodsName:goodsName];
   [self.tableView startPullDownRefresh];
}
- (void)getOrderListWithOrderState:(NSInteger)orderState{
    WEAKSELF
//    [self.tableView showPageLoadingView];
    NSURLSessionTask *task=[EMOrderNetService getOrderListWithUserID:[RI userID] orderID:0 orderState:self.orderState goodsName:self.goodsName cursor:self.cursor pageSize:10 onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.tableView dismissPageLoadView];
        if (responseResult.cursor>=responseResult.totalPage) {
            [weakSelf.tableView enableInfiniteScrolling:NO];
        }else{
            [weakSelf.tableView enableInfiniteScrolling:YES];
        }
        [weakSelf.tableView stopRefreshAndInfiniteScrolling];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            if (weakSelf.cursor<=1) {
                [weakSelf.dataSourceArray removeAllObjects];
            }
            [weakSelf.dataSourceArray addObjectsFromArray:responseResult.responseData];
            [weakSelf.tableView reloadData];
            if (weakSelf.dataSourceArray.count==0) {
                [weakSelf.tableView showPageLoadedMessage:@"暂无订单" delegate:nil];
            }
        }else{
            if (weakSelf.dataSourceArray.count==0) {
                [weakSelf.tableView showPageLoadedMessage:@"获取数据失败" delegate:self];
            }else{
                [weakSelf.tableView showHUDMessage:responseResult.responseMessage];
            }
        }
    }];
    [self addSessionTask:task];
}
- (void)updateOrderStateWithOrderModel:(EMOrderModel *)orderModel state:(EMOrderState)state{
    [self.view showHUDLoading];
    WEAKSELF
    NSURLSessionTask *task=[EMOrderNetService updateOrderStateWithOrderID:orderModel.orderID state:state onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            [weakSelf.view dismissHUDLoading];
            NSInteger row=[weakSelf.dataSourceArray indexOfObject:orderModel];
            [weakSelf.dataSourceArray removeObject:orderModel];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [weakSelf.view showHUDMessage:responseResult.responseMessage];
        }
    }];
    [self addSessionTask:task];
}
#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMOrderListCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMOrderListCell class]) forIndexPath:indexPath];
    cell.orderModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    cell.delegate=self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  __block  EMOrderModel *orderModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    CGFloat height=[tableView fd_heightForCellWithIdentifier:NSStringFromClass([EMOrderListCell class]) configuration:^(id cell) {
        [(EMOrderListCell *)cell setOrderModel:orderModel];
    }];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMOrderModel *orderModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    if (_delegate&&[_delegate respondsToSelector:@selector(orderListControllerDidSelecOrder:)]) {
        [_delegate orderListControllerDidSelecOrder:orderModel];
    }
}
-(void)routerEventName:(NSString *)event userInfo:(NSDictionary *)userInfo{
    [[self nextResponder] routerEventName:event userInfo:userInfo];
}
#pragma mark -page delegate
- (void)setUpWhenViewWillAppearForTitle:(NSString *)title forIndex:(NSInteger)index firstTimeAppear: (BOOL)isFirstTime{
    if (isFirstTime) {
        self.tableView.frame=self.view.bounds;
    }
    EMOrderState state=[EMOrderStateModel orderStateWithStateName:title];
    
}

#pragma mark -cell delegate
//重新购买
- (void)orderListCellShouldReBuyThisGoods{
    
}
- (void)updateOrderState:(EMOrderModel *)orderModel state:(NSInteger)state{
    [self updateOrderStateWithOrderModel:orderModel state:state];
}
//查看订单详情
- (void)orderListCellShouldCheckOrderDetail{

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
@end
