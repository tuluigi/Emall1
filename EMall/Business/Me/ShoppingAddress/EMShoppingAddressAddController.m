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
#import "EMCitySelectViewController.h"
#import "EMAreaModel.h"
#import "EMMeNetService.h"
typedef NS_ENUM(NSInteger,EMShopAddressItemType) {
    EMShopAddressItemTypeUserName       =1,//用户名
    EMShopAddressItemTypeTel            ,
    EMShopAddressItemTypeWeChat         ,
    EMShopAddressItemTypeArea         ,//街道
    EMShopAddressItemTypeDetailAddress  ,//详细地址
    EMShopAddressItemTypeIsDefault      ,//是否默认
};

@interface EMShoppingAddressAddController ()<EMShopProvienceCityControllerDelegate,EMCitySelectViewControllerDelegate>
@property (nonatomic,strong)EMShopAddressModel *addressModel;
@property (nonatomic,strong)NSArray *areaArray;//用户选择的地区信息
@property (nonatomic,strong)OCTableCellTextFiledModel   *nameFieldModel,*telFieldModel,*wechatDeitalModel;
@property (nonatomic,strong)OCTableCellDetialTextModel *provienceDeitalModel;
@property (nonatomic,strong)OCTableCellTextViewModel *detailTextViewModel;
@property (nonatomic,strong)OCTableCellSwitchModel *isDefialutModel;
@end

@implementation EMShoppingAddressAddController
+(EMShoppingAddressAddController *)shoppingAddrssControllerWithAddressModel:(EMShopAddressModel *)addressModel{
    EMShoppingAddressAddController *addController=[[EMShoppingAddressAddController alloc]  init];
    addController.addressModel=addressModel;
    return addController;
}
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
-(void)viewDidLoad{
   
    [super viewDidLoad];
    if (nil==self.addressModel) {
        self.navigationItem.title=@"添加收获地址";
    }else{
        self.navigationItem.title=@"修改收获地址";
    }
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didSaveButtonPressed)];
    _nameFieldModel   =[[OCTableCellTextFiledModel alloc] initWithTitle:@"收货人" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeUserName];
    _nameFieldModel.inputText=self.addressModel.userName;
    _nameFieldModel.tableCellStyle=UITableViewCellStyleValue1;
    
    _telFieldModel   =[[OCTableCellTextFiledModel alloc] initWithTitle:@"联系电话" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeTel];
    _telFieldModel.inputText=self.addressModel.userTel;
    _telFieldModel.tableCellStyle=UITableViewCellStyleValue1;
    
    _wechatDeitalModel=[[OCTableCellTextFiledModel alloc] initWithTitle:@"微信号" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeWeChat];
    _wechatDeitalModel.inputText=self.addressModel.wechatID;
    _wechatDeitalModel.tableCellStyle=UITableViewCellStyleValue1;
    
    _provienceDeitalModel=[[OCTableCellDetialTextModel alloc] initWithTitle:@"所在地区" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMShopAddressItemTypeArea];
    _provienceDeitalModel.detailText=[[self.addressModel.province stringByAppendingString:self.addressModel.city] stringByAppendingString:self.addressModel.country];
    _provienceDeitalModel.tableCellStyle=UITableViewCellStyleValue1;
    
    _detailTextViewModel=[[OCTableCellTextViewModel alloc] initWithTitle:@"街道" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeDetailAddress];
    _detailTextViewModel.inputText=self.addressModel.detailAddresss;
    
    _isDefialutModel=[[OCTableCellSwitchModel alloc] initWithTitle:@"设置常用地址" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeIsDefault];
    _isDefialutModel.on=self.addressModel.isDefault;
    _isDefialutModel.tableCellStyle=UITableViewCellStyleValue1;
    
    self.dataSourceArray=[[NSMutableArray alloc] initWithObjects:_nameFieldModel,_telFieldModel,_wechatDeitalModel,_provienceDeitalModel,_detailTextViewModel,_isDefialutModel, nil];
    [self.tableView reloadData];
}

- (void)didSaveButtonPressed{
    [self.view endEditing:YES];
    if ([NSString isNilOrEmptyForString:self.nameFieldModel.inputText]) {
        [self.tableView showHUDMessage:@"请输入收货人名称"];
    }else if ([NSString isNilOrEmptyForString:self.telFieldModel.inputText]){
        [self.tableView showHUDMessage:@"请输入收货人电话"];
    }else if ([ NSString isNilOrEmptyForString:self.telFieldModel.inputText]){
       [self.tableView showHUDMessage:@"请输入正确电话号码"];
    }else if ([NSString isNilOrEmptyForString:self.provienceDeitalModel.detailText]){
        [self.tableView showHUDMessage:@"请选择收获地址"];
    }else if ([NSString isNilOrEmptyForString:self.detailTextViewModel.inputText]){
        [self.tableView showHUDMessage:@"请输入详细收获地址"];
    }else{
        WEAKSELF
        [self.tableView showHUDLoading];
        EMAreaModel *proiveArea=[self.areaArray firstObject];
        EMAreaModel *cityArea=self.areaArray[1];
        EMAreaModel *countryArea=self.areaArray[2];
        NSString *countryName=countryArea.areaName;
        if (self.areaArray.count<=4) {
            EMAreaModel *streetArea=self.areaArray[3];
            countryName=[countryName stringByAppendingString:streetArea.areaName];
        }
      
        NSURLSessionTask *task=[EMMeNetService addOrEditShoppingAddressWithUrseID:[RI userID] addressID:self.addressModel.addressID receiver:self.nameFieldModel.inputText tel:self.telFieldModel.inputText provicen:proiveArea.areaName city:cityArea.areaName country:countryName detailAddress:self.detailTextViewModel.inputText wechatID:self.wechatDeitalModel.inputText state:self.isDefialutModel.on onCompletionBlock:^(OCResponseResult *responseResult) {
            if (responseResult.responseCode==OCCodeStateSuccess) {
                EMShopAddressModel *shopAddressModel=[[EMShopAddressModel alloc]  init];
                shopAddressModel.addressID=weakSelf.addressModel.addressID;
                shopAddressModel.province=proiveArea.areaName;
                shopAddressModel.city=cityArea.areaName;
                shopAddressModel.country=countryArea.areaName;
                shopAddressModel.street=countryArea.areaName;
                shopAddressModel.detailAddresss=weakSelf.detailTextViewModel.inputText;
                shopAddressModel.userName=weakSelf.nameFieldModel.inputText;
                shopAddressModel.userTel=weakSelf.telFieldModel.inputText;
                shopAddressModel.wechatID=weakSelf.wechatDeitalModel.inputText;
                shopAddressModel.isDefault=weakSelf.isDefialutModel.on;
                if (_delegate &&[_delegate respondsToSelector:@selector(shoppingAddressAddOrEditControllerDidShopingAddressChanged:)]) {
                    [_delegate shoppingAddressAddOrEditControllerDidShopingAddressChanged:shopAddressModel];
                }
                [weakSelf.tableView showHUDMessage:@"" completionBlock:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [weakSelf.tableView showHUDMessage:responseResult.responseMessage];
            }
        }];
        [self addSessionTask:task];
    }
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
    if (cellModel.type==EMShopAddressItemTypeTel) {
        [(OCUTableViewTextFieldCell *)cell textField].keyboardType=UIKeyboardTypePhonePad;
    }
    cell.cellModel=cellModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    if (cellModel.type==EMShopAddressItemTypeArea) {
        EMCitySelectViewController *citySelctController=[[EMCitySelectViewController alloc]  init];
        citySelctController.hidesBottomBarWhenPushed=YES;
        citySelctController.delegate=self;
        [self.navigationController pushViewController:citySelctController animated:YES];
        
        /*
        EMShopProvienceCityController *provienceViewController=[[EMShopProvienceCityController alloc] init];
        provienceViewController.delegate=self;
        provienceViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:provienceViewController animated:YES];
         */
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=44;
      OCTableCellModel *cellModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    if (cellModel.type==EMShopAddressItemTypeDetailAddress) {
        height=70;
    }
    return height;
}
#pragma mark - city select delegate
- (void)didFinishSelectWithAreaInfoArray:(NSArray <EMAreaModel *>*)aresInoArray{
    NSString *addressString=@"";
    self.areaArray=aresInoArray;
    for (NSInteger i=0; i<aresInoArray.count; i++) {
        EMAreaModel *aremModel=aresInoArray[i];
        addressString=[addressString stringByAppendingString:aremModel.areaName];
    }
    _provienceDeitalModel.detailText=addressString;
    [self.tableView reloadData];
}
#pragma mark -address delegate
- (void)shopProvicenceCityControllerDidSelectProvienceID:(NSString *)provienceID
                                           provienceName:(NSString *)provienceName
                                                  cityID:(NSString *)cityID
                                                cityName:(NSString *)cityName{
    self.addressModel.province=provienceName;
    self.addressModel.city=cityName;
    [self.tableView reloadData];
}
@end
