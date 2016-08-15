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
#import "EMCartBottomView.h"
#import "EMCartSubmitViewController.h"
#import "EMGoodsDetailViewController.h"
#import "EMShopCartNetService.h"
@interface EMCartViewController ()<EMCartListCellDelegate,EMCartBottomViewDelegate>
@property (nonatomic,strong)EMCartBottomView *bottomView;
@property (nonatomic,assign)BOOL isDeleteing;//default =No
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
- (EMCartBottomView *)bottomView{
    if (nil==_bottomView) {
        _bottomView=[[EMCartBottomView alloc] init];
        _bottomView.delegate=self;
    }
    return _bottomView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCartListWithCursor:self.cursor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onInitData];
}
- (void)onInitData{
    self.automaticallyAdjustsScrollViewInsets=YES;
    self.navigationItem.title=@"购物车";
    
    [self.tableView registerClass:[EMCartListCell class] forCellReuseIdentifier:NSStringFromClass([EMCartListCell class])];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didEditButtonPressed:)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.bottomView];
    CGRect tabarBounds= self.tabBarController.tabBar.bounds;
    WEAKSELF
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-tabarBounds.size.height);
        make.height.mas_equalTo(OCUISCALE(50));
    }];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.removeExisting=YES;
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self.tableView reloadData];
    [self calcuteMyShopCart];
    [self getCartListWithCursor:self.cursor];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OCLoginSuccessNofication object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [weakSelf handleUserLoginSucceedNotification];
        
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:OCLogoutNofication object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf handleUserLogoutSucceedNotification];
    }];
    [self.tableView addOCPullDownResreshHandler:^{
        weakSelf.cursor=1;
        [weakSelf getCartListWithCursor:weakSelf.cursor];
    }];
    [self.tableView addOCPullInfiniteScrollingHandler:^{
        weakSelf.cursor++;
        [weakSelf getCartListWithCursor:weakSelf.cursor];
    }];
}
- (void)handleUserLoginSucceedNotification{
    [self handleUserLogoutSucceedNotification];
    self.cursor=1;
    [self getCartListWithCursor:self.cursor];
}

- (void)handleUserLogoutSucceedNotification{
    self.cursor=1;
    [self.dataSourceArray removeAllObjects];
    [self.tableView reloadData];
}
#pragma mark - getCart list
- (void)getCartListWithCursor:(NSInteger )cursor{
    WEAKSELF
    if (self.dataSourceArray.count==0) {
        [weakSelf.tableView showPageLoadingView];
        weakSelf.bottomView.hidden=YES;
    }
    NSURLSessionTask *task=[EMShopCartNetService getShopCartListWithUserID:[RI userID] pid:cursor pageSize:10 onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.tableView dismissPageLoadView];
        [weakSelf.tableView stopRefreshAndInfiniteScrolling];
        if (responseResult.cursor==responseResult.totalPage) {
            [weakSelf.tableView enableInfiniteScrolling:NO];
        }
        if (responseResult.responseCode==OCCodeStateSuccess) {
            weakSelf.bottomView.hidden=NO;
            if (cursor<=1) {
                [weakSelf.dataSourceArray removeAllObjects];
            }
            [weakSelf.dataSourceArray addObjectsFromArray:responseResult.responseData];
            [weakSelf.tableView reloadData];
            [weakSelf updatePageLoadMesage];
        }else{
            if (cursor<=1) {
                [weakSelf.tableView showPageLoadedMessage:@"获取数据失败" delegate:self];
            }else{
                [weakSelf.tableView showHUDMessage:@"获取数据失败"];
            }
        }
    }];
    [weakSelf addSessionTask:task];
}

- (void)deletaCartWithCartID:(NSArray <EMShopCartModel *>*)array{
    WEAKSELF
    NSMutableArray <NSNumber *>*cartIDArray=[NSMutableArray new];
    NSMutableArray <NSIndexPath *>*indexPathArray=[NSMutableArray new];
    for (EMShopCartModel *shopCartModel in array) {
        [cartIDArray addObject:@(shopCartModel.cartID)];
        NSInteger index=[self.dataSourceArray indexOfObject:shopCartModel];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        [indexPathArray addObject:indexPath];
    }
    [self.tableView showHUDLoading];
    NSURLSessionTask *task=[EMShopCartNetService deleteShopCartWithCartIDs:cartIDArray onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            [weakSelf.tableView dismissHUDLoading];
            [weakSelf.dataSourceArray removeObjectsInArray:array];
            [weakSelf.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf updatePageLoadMesage];
        }else{
            [weakSelf.tableView showHUDMessage:responseResult.responseMessage];
        }
    }];
    [self addSessionTask:task];
}
- (void)updatePageLoadMesage{
    NSInteger row=self.dataSourceArray.count;
    if (row==0) {
        self.bottomView.hidden=YES;
        [self.tableView showPageLoadedMessage:@"您的购物车是空的,去看看其他商品吧" delegate:nil];
    }else{
        self.bottomView.hidden=NO;
        [self.tableView dismissPageLoadView];
    }
}
- (void)updateShopCart:(NSInteger)cartID buyCount:(NSInteger)buyCount{
    
    NSURLSessionTask *task=[EMShopCartNetService editShopCartWithCartID:cartID buyCount:buyCount onCompletionBlock:^(OCResponseResult *responseResult) {
    }];
    [self addSessionTask:task];
    
}
- (void)setIsDeleteing:(BOOL)isDeleteing{
    _isDeleteing=isDeleteing;
    UIBarButtonItem *sender=self.navigationItem.rightBarButtonItem;
    if (_isDeleteing) {
        sender.title=@"完成";
    }else{
        sender.title=@"编辑";
    }
    self.bottomView.isDelete=_isDeleteing;
}
- (void)didEditButtonPressed:(UIBarButtonItem *)sender{
    self.isDeleteing=!self.isDeleteing;
}
//计算当前购物车的购买人数和总价
- (void )calcuteMyShopCart{
    CGFloat totalPrice=0;
    NSInteger count=0;
    for (EMShopCartModel *model in self.dataSourceArray) {
        if (!model.unSelected) {
            count++;
            totalPrice+=model.goodsPrice*model.buyCount;
        }
    }
    [self.bottomView updateCartBottomWithSelectItemCount:count totalItems:self.dataSourceArray.count totalPrice:totalPrice];
}
- (void)updateAllShopCartModelSelectState:(BOOL)select{
    for (EMShopCartModel *model in self.dataSourceArray) {
        model.unSelected=!select;
    }
    [self.tableView reloadData];
}

#pragma mark - delete shopCart
- (void)deleteShopCart:(NSArray <EMShopCartModel *>*)Array{
    [self deletaCartWithCartID:Array];
}
#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row= self.dataSourceArray.count;
    return row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMCartListCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMCartListCell class]) forIndexPath:indexPath];
    cell.delegate=self;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMShopCartModel *cartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    EMGoodsDetailViewController *detailController=[[EMGoodsDetailViewController alloc]  initWithGoodsID:cartModel.goodsID];
    detailController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detailController animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        EMShopCartModel *cartModel=[self.dataSourceArray objectAtIndex:indexPath.row];
        [self deleteShopCart:@[cartModel]];
    }
}
#pragma mark -cell delegate
//选中状态
- (void)cartListCellDidSelectStateChanged:(EMShopCartModel *)shopCartModel{
    [self calcuteMyShopCart];
}
//购买数量改变
- (void)cartListCellDidBuyCountChanged:(EMShopCartModel *)shopCartModel{
    [self calcuteMyShopCart];
    [self updateShopCart:shopCartModel.cartID buyCount:shopCartModel.buyCount];
}

#pragma mark -bottom view delegate
//选中
- (void)cartBottomViewDidSelectAllButtonSelected:(BOOL)selected{
    [self updateAllShopCartModelSelectState:selected];
    [self calcuteMyShopCart];
}
//购物车结算
- (void)cartBottomViewSubmitButtonPressed:(EMCartBottomView *)bottomView{
    NSPredicate *preicate=[NSPredicate predicateWithFormat:@"_unSelected=%ld",NO];
    
    NSArray *selectArray=[self.dataSourceArray filteredArrayUsingPredicate:preicate];
    
    WEAKSELF
    if (bottomView.isDelete) {//删除购物车
        if (selectArray.count) {
            UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确定要删除选中的商品么？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *quitAction=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (selectArray.count) {
                    [weakSelf deleteShopCart:selectArray];
                }
            }];
            [alertController addAction:cancleAction];
            [alertController addAction:quitAction];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
    }else{//提交购物车
        if (selectArray.count) {
            EMCartSubmitViewController *submitController=[[EMCartSubmitViewController alloc]  init];
            submitController.cartArray=selectArray;
            //            EMCartSubmitViewController *submitController=[EMCartSubmitViewController cartSubmitViewWithCartArray:selectArray];
            submitController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:submitController animated:YES];
        }
    }
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
