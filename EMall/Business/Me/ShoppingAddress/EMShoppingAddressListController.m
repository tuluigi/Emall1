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
@interface EMShoppingAddressListController ()

@end

@implementation EMShoppingAddressListController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"收获地址";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addShoppingAddress)];
    [self.tableView registerClass:[EMShopAddressListCell class] forCellReuseIdentifier:NSStringFromClass([EMShopAddressListCell class])];
    [self getShoppingAddrsssModelWithUserID:nil];
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
        addressModel.userName=@"小名";
        addressModel.userTel=@"13523576349";
        addressModel.wechatID=@"weixin_xxxID";
        addressModel.userAddress=@"北京市，海淀区，中关村";
        [self.dataSourceArray addObject:addressModel];
    }
    [self.tableView reloadData];
}
- (void)deleteShoppingAddresssModel:(EMShopAddressModel *)addresssModel{
    
}


#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMShopAddressListCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMShopAddressListCell class]) forIndexPath:indexPath];
    if (nil==cell) {
        cell=[[EMShopAddressListCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([EMShopAddressListCell class])];
    }
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
    
    EMShopAddressModel *shopAddressModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    [self goToAddShopAddressControllerWithAddressModel:shopAddressModel];
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
@end
