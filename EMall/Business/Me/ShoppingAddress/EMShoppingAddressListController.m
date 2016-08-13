//
//  EMShoppingAddressListController.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShoppingAddressListController.h"
#import "EMShoppingAddressAddController.h"
#import "EMShopAddressListCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "EMShopAddressModel.h"
#import "EMMeNetService.h"
@interface EMShoppingAddressListController ()<EMShopAddressListCellDelegate>

@end

@implementation EMShoppingAddressListController
- (void )viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"收货地址";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addShoppingAddress)];
    [self.tableView registerClass:[EMShopAddressListCell class] forCellReuseIdentifier:NSStringFromClass([EMShopAddressListCell class])];
    [self getShoppingAddrsssModelWithUserID:nil];
    [self getAddressList];
}
- (void)addShoppingAddress{
    [self goToAddShopAddressControllerWithAddressModel:nil];
}
- (void)goToAddShopAddressControllerWithAddressModel:(EMShopAddressModel *)addressModel{
    EMShoppingAddressAddController *addShopingAddressController=[EMShoppingAddressAddController shoppingAddrssControllerWithAddressModel:addressModel];
    addShopingAddressController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addShopingAddressController animated:YES];
}
- (void)getShoppingAddrsssModelWithUserID:(NSString *)userID{
    for (NSInteger i=0; i<10; i++) {
        EMShopAddressModel *addressModel=[[EMShopAddressModel alloc]  init];
        addressModel.userName=@"李小明";
        addressModel.userTel=@"13523576349";
        addressModel.wechatID=@"haichigo";
        addressModel.province=@"北京市";
        addressModel.city=@"北京市";
        addressModel.country=@"海淀区";
        addressModel.street=@"中关村";
        addressModel.detailAddresss=@"创新大厦 D座 20层";
        if (i==2) {
            addressModel.isDefault=YES;
        }else{
            addressModel.isDefault=NO;
        }
        [self.dataSourceArray addObject:addressModel];
    }
    [self.tableView reloadData];
}
- (void)getAddressList{
    return;//暂时没有数据，这么测试用
    WEAKSELF
    [self.tableView showPageLoadingView];
    NSURLSessionTask *task=[EMMeNetService getShoppingAddressListWithUrseID:[RI userID] onCompletionBlock:^(OCResponseResult *responseResult) {
        if (responseResult.responseCode==OCCodeStateSuccess) {
            NSArray *array=responseResult.responseData;
            [weakSelf.dataSourceArray removeAllObjects];
            if (array.count) {
                [weakSelf.dataSourceArray addObjectsFromArray:array];
                [weakSelf.tableView reloadData];
            }else{
                 [weakSelf.tableView showPageLoadedMessage:@"您还没有添加收货地址，赶紧来试试添加吧" delegate:nil];
            }
        }else{
            [weakSelf.tableView showPageLoadedMessage:responseResult.responseMessage delegate:self];
        }
    }];
    [weakSelf addSessionTask:task];
}
- (void)deleteShoppingAddresssModel:(EMShopAddressModel *)addresssModel{
    WEAKSELF
    [self.tableView showHUDLoading];
    NSURLSessionTask *task=[EMMeNetService deleteShoppingAddressWithAddresID:addresssModel.addressID onCompletionBlock:^(OCResponseResult *responseResult) {
        [weakSelf.tableView dismissHUDLoading];
        if (responseResult.responseCode==OCCodeStateSuccess) {
            NSInteger index=[weakSelf.dataSourceArray indexOfObject:addresssModel];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
            [weakSelf.dataSourceArray removeObject:addresssModel];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [weakSelf.tableView showHUDMessage:responseResult.responseMessage];
        }
    }];
    [self addSessionTask:task];
}
- (void)shoppingAddressAddOrEditControllerDidShopingAddressChanged:(EMShopAddressModel *)shopAddress{
     [self getAddressList];
}

#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMShopAddressListCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMShopAddressListCell class]) forIndexPath:indexPath];
    if (nil==cell) {
        cell=[[EMShopAddressListCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([EMShopAddressListCell class])];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    cell.delegate=self;
    cell.addresssModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
   __block EMShopAddressModel *addressModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    height=[tableView fd_heightForCellWithIdentifier:NSStringFromClass([EMShopAddressListCell class]) configuration:^(id cell) {
        [(EMShopAddressListCell *)cell setAddresssModel:addressModel];
    }];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate&&[_delegate respondsToSelector:@selector(shopAddressListControlerDidSelectAddress:)]) {
        [_delegate shopAddressListControlerDidSelectAddress:self.dataSourceArray[indexPath.row]];
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        EMShopAddressModel *shopAddressModel=[self.dataSourceArray objectAtIndex:indexPath.row];
        [self goToAddShopAddressControllerWithAddressModel:shopAddressModel];
    }
   
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self deleteShoppingAddresssModel:[self.dataSourceArray objectAtIndex:indexPath.row]];
    }
}
- (void)shopAddressListCellDidEditButtonPressed:(EMShopAddressModel *)addressModel{
    EMShopAddressModel *shopAddressModel=addressModel;
    [self goToAddShopAddressControllerWithAddressModel:shopAddressModel];
}
@end
