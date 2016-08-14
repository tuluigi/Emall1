//
//  EMMeViewController.m
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMMeViewController.h"
#import "OCUTableCellHeader.h"
#import "EMMEHeadView.h"
#import "EMMeOrderStateCell.h"
#import "EMOrderModel.h"
#import "EMLoginViewController.h"
#import "EMServiceController.h"
#import "EMShoppingAddressListController.h"
#import "EMOrderHomeListController.h"
#import "EMMeNetService.h"
#import "EMMeInfoViewController.h"
#import "EMEdiePwdViewController.h"
typedef NS_ENUM(NSInteger,EMUserTableCellModelType) {
    EMUserTableCellModelTypeOrder           =100,//订单
    EMUserTableCellModelTypeOrderState          ,//订单状态
    EMUserTableCellModelTypeShoppingAddress     ,//收货地址
    EMUserTableCellModelTypeServices            ,//联系客服
    EMUserTableCellModelTypeEditPwd           ,//修改买吗
    EMUserTableCellModelTypeLogout              ,//退出登录
    
};

@interface EMMeViewController ()<EMMeOrderStateCellDelegate>
@property (nonatomic,strong)EMMEHeadView *headView;
@property (nonatomic,strong)NSMutableArray *orderStateArray;
@end

@implementation EMMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onInitData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)onInitData{
    self.fd_prefersNavigationBarHidden=YES;
    
    self.navigationItem.title=@"我";
    self.tableView.separatorColor=[UIColor colorWithHexString:@"#eeeeee"];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    WEAKSELF
    [[NSNotificationCenter defaultCenter] addObserverForName:OCLoginSuccessNofication object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [weakSelf handleUserLoginStateDataSource];
        [weakSelf.tableView reloadData];
        
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:OCLogoutNofication object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
         [weakSelf.dataSourceArray removeObjectsInRange:NSMakeRange(weakSelf.dataSourceArray.count-2, 2)];
        [weakSelf.headView setUserName:[RI userName] headImageUrl:[RI avatar] level:1];
        [weakSelf.tableView reloadData];
    }];
    NSArray *groupArray0,*groupArray1,*groupArray2;
    OCTableCellDetialTextModel *userInfoModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"全部订单" imageName:@"me_order" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeOrder];
    userInfoModel.tableCellStyle=UITableViewCellStyleSubtitle;
    
    
    OCTableCellModel *orderModel=[[OCTableCellModel alloc]  initWithTitle:@"" imageName:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeOrderState];
    orderModel.tableCellStyle=UITableViewCellStyleSubtitle;
    orderModel.reusedCellIdentifer=@"OCTableCellOrderResuableCellIdentifer";
    orderModel.cellClassName=NSStringFromClass([EMMeOrderStateCell class]);
    groupArray0=@[userInfoModel,orderModel];
    
    OCTableCellDetialTextModel *addressModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"地址管理" imageName:@"me_address" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeShoppingAddress];
    addressModel.tableCellStyle=UITableViewCellStyleSubtitle;
    groupArray1=@[addressModel];
    
    OCTableCellDetialTextModel *serviceModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"联系客服" imageName:@"me_service" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeServices];
    serviceModel.tableCellStyle=UITableViewCellStyleSubtitle;
    groupArray2=@[serviceModel];
   
    
    self.dataSourceArray=[NSMutableArray arrayWithObjects:groupArray0,groupArray1,groupArray2, nil];
    
    
     [self handleUserLoginStateDataSource];
    [self.headView setUserName:[RI userName] headImageUrl:[RI avatar] level:1];
    CGSize size=[self.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.headView.frame=CGRectMake(0, 0, size.width, size.height);
    self.tableView.tableHeaderView=self.headView;
    UIEdgeInsets edgeInset=self.tableView.contentInset;
    self.tableView.contentInset=UIEdgeInsetsMake(edgeInset.top-20, edgeInset.left, edgeInset.bottom, edgeInset.right);
    
    self.orderStateArray=[NSMutableArray arrayWithArray:[EMOrderStateModel orderStateModelArray]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView reloadData];
    
    
}
- (void)handleUserLoginStateDataSource{
    if ([RI isLogined]) {
        OCTableCellDetialTextModel *editPwdModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"修改密码" imageName:@"me_passoword" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeEditPwd];
        editPwdModel.tableCellStyle=UITableViewCellStyleSubtitle;
        NSArray * groupArray3=@[editPwdModel];
        [self.dataSourceArray addObject:groupArray3];
        
        OCTableCellDetialTextModel *quitModel=[[OCTableCellDetialTextModel alloc]  initWithTitle:@"退出登录" imageName:@"me_logout" accessoryType:UITableViewCellAccessoryDisclosureIndicator type:EMUserTableCellModelTypeLogout];
        quitModel.tableCellStyle=UITableViewCellStyleSubtitle;
        NSArray * groupArray4=@[quitModel];
        [self.dataSourceArray addObject:groupArray4];
        [self.headView setUserName:[RI userName] headImageUrl:[RI avatar] level:1];
    }else{
       
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arry=[self.dataSourceArray objectAtIndex:section];
    NSInteger count=arry.count;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[cellModel reusedCellIdentifer]];
    if (nil==cell) {
        cell= [cellModel cellWithReuseIdentifer:[cellModel reusedCellIdentifer]];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    [(OCUTableViewCell *)cell setCellModel:cellModel];
    switch (cellModel.type) {
        case EMUserTableCellModelTypeOrderState:
        {
            cell.separatorInset=UIEdgeInsetsZero;
            cell.accessoryType=UITableViewCellAccessoryNone;
            [(EMMeOrderStateCell *)cell setDelegate:self];
            [(EMMeOrderStateCell *)cell setOrderStateArry:self.orderStateArray];
        }
            break;
        case EMUserTableCellModelTypeOrder:
        case EMUserTableCellModelTypeLogout:
        case EMUserTableCellModelTypeShoppingAddress:
        case EMUserTableCellModelTypeServices:{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCTableCellModel *cellModel=[[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CGFloat height= OCUISCALE(44);
    if (cellModel.type==EMUserTableCellModelTypeOrderState) {
        height=[EMMeOrderStateCell orderStateCellHeight];
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return OCUISCALE(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OCTableCellModel *cellModel=[[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (cellModel.type==EMUserTableCellModelTypeLogout){
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确定要退出当前账号吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        UIAlertAction *quitAction=[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [EMMeNetService userLogoutOnCompletionBlock:^{
                
            }];
        }];
        [alertController addAction:cancleAction];
        [alertController addAction:quitAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else if (cellModel.type==EMUserTableCellModelTypeServices) {
        EMServiceController *serviceController=[[EMServiceController alloc]  initWithStyle:UITableViewStyleGrouped];
        serviceController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:serviceController animated:YES];
    }else if (cellModel.type==EMUserTableCellModelTypeEditPwd){
        EMEdiePwdViewController *editPwdController=[[EMEdiePwdViewController alloc]  init];
        editPwdController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:editPwdController animated:YES];
    }
    else{
        if ([RI isLogined]) {
            if (cellModel.type==EMUserTableCellModelTypeShoppingAddress){
                EMShoppingAddressListController *shoppingAddressListController=[[EMShoppingAddressListController alloc]  init];
                shoppingAddressListController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:shoppingAddressListController animated:YES];
            } else if (cellModel.type==EMUserTableCellModelTypeOrder){
                EMOrderHomeListController *orderHomeListController=[[EMOrderHomeListController alloc]  initWithOrderState:EMOrderStateNone];
                orderHomeListController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:orderHomeListController animated:YES];
            }
        }else{
            [self showLoginControllerOnCompletionBlock:^(BOOL isSucceed) {
                
            }];
        }
    }
}

#pragma mark - EMMeOrderCellDelegate
- (void)orderStateCellDidSelectItem:(EMOrderStateModel *)stateModel{
    EMOrderHomeListController *orderHomeListController=[[EMOrderHomeListController alloc]  initWithOrderState:stateModel.state];
    orderHomeListController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:orderHomeListController animated:YES];
}

#pragma  mark - getter
- (EMMEHeadView *)headView{
    if (nil==_headView) {
        _headView=[EMMEHeadView meHeadViewOnTapedBlock:^{
            if ([RI isLogined]) {
                EMMeInfoViewController *infoController=[[EMMeInfoViewController alloc] init];
                infoController.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:infoController animated:YES];
            }else{
                [self showLoginControllerOnCompletionBlock:^(BOOL isSucceed) {
                    
                }];
            }
        }];
    }
    return _headView;
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
