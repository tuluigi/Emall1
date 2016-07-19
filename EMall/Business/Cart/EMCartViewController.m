//
//  EMCartViewController.m
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCartViewController.h"
#import "EMCartListCell.h"
#import "EMShopCartModel.h"
@interface EMCartViewController ()

@end

@implementation EMCartViewController
- (UITableView *)tableView{
    if (nil==_tableView) {
        _tableView=[[TPKeyboardAvoidingTableView alloc]  initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.tableFooterView=[UIView new];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onInitData];
}
- (void)onInitData{
    self.navigationItem.title=@"购物车";
    self.tableView.allowsMultipleSelection=YES;
    [self.tableView registerClass:[EMCartListCell class] forCellReuseIdentifier:NSStringFromClass([EMCartListCell class])];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didEditButtonPressed)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    for (NSInteger i=0; i<20; i++) {
        EMShopCartModel *model=[[EMShopCartModel alloc]  init];
        model.goodsImageUrl=@"http://img4.cache.netease.com/photo/0008/2016-06-22/BQ54OKL42FKJ0008.550x.0.jpg";
        model.goodsName=@"仿真盆栽现代家居装饰家室美式装修";
        model.buyCount=1;
        model.goodsPrice=53;
        model.spec =@"100cm*30cm";
        [self.dataSourceArray addObject:model];
    }
    [self.tableView reloadData];
}
- (void)didEditButtonPressed{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}
#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMCartListCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMCartListCell class]) forIndexPath:indexPath];
    cell.shopCartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  __block  EMShopCartModel *cartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    CGFloat height=[tableView fd_heightForCellWithIdentifier:NSStringFromClass([EMCartListCell class]) configuration:^(id cell) {
        [(EMCartListCell *)cell setShopCartModel:cartModel];
    }];
    return height;
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
