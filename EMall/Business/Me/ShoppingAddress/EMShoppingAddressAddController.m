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

@interface EMShoppingAddressAddController ()<EMShopProvienceCityControllerDelegate>
@property (nonatomic,strong)EMShopAddressModel *addressModel;

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
    
    _wechatDeitalModel=[[OCTableCellTextFiledModel alloc] initWithTitle:@"微信号" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMShopAddressItemTypeWeChat];
    _wechatDeitalModel.inputText=self.addressModel.wechatID;
    _wechatDeitalModel.tableCellStyle=UITableViewCellStyleValue1;
    
    _provienceDeitalModel=[[OCTableCellDetialTextModel alloc] initWithTitle:@"所在地区" imageName:nil accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMShopAddressItemTypeProvience];
    _provienceDeitalModel.detailText=self.addressModel.province;
    _provienceDeitalModel.tableCellStyle=UITableViewCellStyleValue1;
    
    _detailTextViewModel=[[OCTableCellTextViewModel alloc] initWithTitle:@"街道" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeStreet];
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
    }else if (![self.telFieldModel.inputText isValidateEmail]){
       [self.tableView showHUDMessage:@"请输入正确电话号码"];
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
    switch (cellModel.type) {
        case EMShopAddressItemTypeProvience:
        {
            [(OCTableCellDetialTextModel *)cellModel setDetailText:[self.addressModel.province stringByAppendingString:self.addressModel.city]];
        }break;
        case EMShopAddressItemTypeCity:
        {
            
        }break;
        default:
            break;
    }
    cell.cellModel=cellModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    if (cellModel.type==EMShopAddressItemTypeProvience) {
        EMShopProvienceCityController *provienceViewController=[[EMShopProvienceCityController alloc] init];
        provienceViewController.delegate=self;
        provienceViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:provienceViewController animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=44;
      OCTableCellModel *cellModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    if (cellModel.type==EMShopAddressItemTypeStreet) {
        height=60;
    }
    return height;
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
