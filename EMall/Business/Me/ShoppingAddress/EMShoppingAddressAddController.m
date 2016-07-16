//
//  EMShoppingAddressAddController.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShoppingAddressAddController.h"
#import "EMShopProvienceCityController.h"
#import "OCUTableCellHeader.h"
#import "EMShopAddressModel.h"
typedef NS_ENUM(NSInteger,EMShopAddressItemType) {
    EMShopAddressItemTypeUserName       =1,//用户名
    EMShopAddressItemTypeTel            ,
    EMShopAddressItemTypeWeChat         ,
    EMShopAddressItemTypeProvience      ,//省
    EMShopAddressItemTypeCity           ,//城市
    EMShopAddressItemTypeStreet         ,//街道
    EMShopAddressItemTypeDetailAddress  ,//详细地址
    EMShopAddressItemTypeIsDefault      ,//是否默认
};

@interface EMShoppingAddressAddController ()
@property (nonatomic,strong)EMShopAddressModel *addressModel;

@end

@implementation EMShoppingAddressAddController
+(EMShoppingAddressAddController *)shoppingAddrssControllerWithAddressModel:(EMShopAddressModel *)addressModel{
    EMShoppingAddressAddController *addController=[[EMShoppingAddressAddController alloc]  init];
    addController.addressModel=addressModel;
    return addController;
}

-(void)viewDidLoad{
    self.tableView=[[TPKeyboardAvoidingTableView alloc]  initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.tableFooterView=[UIView new];
    [super viewDidLoad];
    if (nil==self.addressModel) {
        self.navigationItem.title=@"添加收获地址";
    }else{
        self.navigationItem.title=@"修改收获地址";
    }
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didSaveButtonPressed)];
    OCTableCellTextFiledModel   *nameFieldModel   =[[OCTableCellTextFiledModel alloc] initWithTitle:@"收货人" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeUserName];
    nameFieldModel.inputText=self.addressModel.userName;
    nameFieldModel.tableCellStyle=UITableViewCellStyleValue1;
    
    OCTableCellTextFiledModel   *telFieldModel   =[[OCTableCellTextFiledModel alloc] initWithTitle:@"联系电话" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeTel];
    telFieldModel.inputText=self.addressModel.userTel;
    telFieldModel.tableCellStyle=UITableViewCellStyleValue1;
    
    OCTableCellDetialTextModel *wechatDeitalModel=[[OCTableCellDetialTextModel alloc] initWithTitle:@"微信号" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMShopAddressItemTypeWeChat];
    wechatDeitalModel.detailText=self.addressModel.wechatID;
    wechatDeitalModel.tableCellStyle=UITableViewCellStyleValue1;
    
     OCTableCellDetialTextModel *provienceDeitalModel=[[OCTableCellDetialTextModel alloc] initWithTitle:@"所在地区" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMShopAddressItemTypeProvience];
    provienceDeitalModel.detailText=self.addressModel.province;
    provienceDeitalModel.tableCellStyle=UITableViewCellStyleValue1;
    
    OCTableCellTextViewModel *detailTextViewModel=[[OCTableCellTextViewModel alloc] initWithTitle:@"街道" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeStreet];
    detailTextViewModel.inputText=self.addressModel.detailAddresss;
    
    OCTableCellSwitchModel *isDefialutModel=[[OCTableCellSwitchModel alloc] initWithTitle:@"设置常用地址" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeIsDefault];
    isDefialutModel.on=self.addressModel.isDefault;
    isDefialutModel.tableCellStyle=UITableViewCellStyleValue1;
    
    self.dataSourceArray=[[NSMutableArray alloc] initWithObjects:nameFieldModel,telFieldModel,wechatDeitalModel,provienceDeitalModel,detailTextViewModel,isDefialutModel, nil];
    [self.tableView reloadData];
}

- (void)didSaveButtonPressed{
    
}
#pragma mark -setter getter
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row= self.dataSourceArray.count;
    return row; 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    OCUTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[cellModel reusedCellIdentifer]];
    if (nil==cell) {
        cell= [cellModel cellWithReuseIdentifer:[cellModel reusedCellIdentifer]];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.cellModel=cellModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    if (cellModel.type==EMShopAddressItemTypeProvience) {
        EMShopProvienceCityController *provienceViewController=[[EMShopProvienceCityController alloc] init];
        provienceViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:provienceViewController animated:YES];
    }
    
}
@end
